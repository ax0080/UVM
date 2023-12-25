+access+rw
-sv
-uvm
-disable_sem2009
-timescale 1ns/10ps
+UVM_TESTNAME=my_case0
+UVM_NO_RELNOTES
//+sv_lib=/home/tools/uvm/uvm-1.2/src/uvm_macros.svh
+incdir+/home/tools/uvm/uvm-1.2/src/uvm_macros.svh

./dut.sv
./my_if.sv
./my_transaction.sv
./my_driver.sv
./my_monitor.sv
./my_model.sv
./my_sequence.sv
./my_sequencer.sv
./my_scoreboard.sv
./my_agent.sv
./my_env.sv
//./base_test.sv
//./my_case0.sv
./top_tb.sv


