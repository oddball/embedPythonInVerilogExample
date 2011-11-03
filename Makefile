#These 2 lines were necessary on my debian derivative, to find glibc
INCLIBC  = -I/usr/include/i386-linux-gnu
export LIBRARY_PATH := /usr/lib/i386-linux-gnu



INCLUDE  = $(INCLIBC) -I/usr/include/python2.7 -I$(MTI_HOME)/include 
CFLAGS   = -gstabs -Wall -fpic -shared
COMPILER = $(MTI_GCC)/bin/gcc
LIBS     = -lc -lssl -lpthread -lm -ldl -lutil -lpython2.7

sim:	pythonEmbedded.h pythonEmbedded.so
	vsim top -c -sv_lib pythonEmbedded -do "run -all; quit -f"

pythonEmbedded.h: pythonEmbedded.sv
	vlib work
	vlog -sv -dpiheader pythonEmbedded.h pythonEmbedded.sv

pythonEmbedded.sv:

pythonEmbedded.so: pythonEmbedded.c
	$(COMPILER) $< $(CFLAGS) $(INCLUDE) $(LIBS) -o $@

clean:
	rm -f pythonEmbedded.h pythonEmbedded.so
	rm -f transcript *.wlf 
	rm -rf work
