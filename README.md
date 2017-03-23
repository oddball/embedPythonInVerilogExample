Wanted to show how easy it is to use Python together with Verilog or VHDL. With just a few lines the Python interpreter can be embedded and call tasks or functions in SystemVerilog. I am using the proprietary simulator Questasim in this example.

The SystemVerilog code looks like this

```v
`timescale 1 ns/1 ns
module top;
      import "DPI-C" context task startPython();
      export "DPI-C" task sv_write;
 
   // Exported SV task.  Can be called by C,SV or Python using c_write
   task sv_write(input int data,address);
      begin
     $display("sv_write(data = %d, address = %d)",data,address);
      end
   endtask
 
   initial
     begin
    startPython();
    $display("DONE!!");
     end
 
endmodule
```


The C code looks like this

```c
#include
#include "vpi_user.h"
#include "pythonEmbedded.h"
 
static PyObject * c_write(PyObject *self, PyObject *args) {
  int address,data;
  if(!PyArg_ParseTuple(args, "ii", &data, &address))
    return NULL;
  sv_write(address,data);
  return Py_BuildValue("");
}
 
static PyMethodDef EmbMethods[] = {
  {"c_write",c_write, METH_VARARGS,"c_write(data,address)"},
  {NULL, NULL, 0, NULL}
};
 
DPI_DLLESPEC
int startPython(){
    Py_Initialize();
    Py_InitModule("emb", EmbMethods);
    PyRun_SimpleString("import emb\n"
               "emb.c_write(0,1)\n");
    Py_Finalize();
    return 0;
}
```

Easiest way to try it out:

```bash
git clone http://github.com/oddball/embedPythonInVerilogExample.git
cd embedPythonInVerilogExample
make
```
