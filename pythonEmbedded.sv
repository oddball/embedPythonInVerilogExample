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
