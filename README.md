# UVM
This is an UVM Project

ref 
"UVM實戰" by 張強


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Cadence的irun和ncverilog的include功能有問題，
因此我把用到的每個function都放進filelist中。
此外，每一層會呼叫UVM的function的code都需要加入
`include "uvm_macros.svh"
import uvm_pkg::*;
