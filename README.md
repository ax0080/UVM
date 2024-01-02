# UVM
This is an UVM Project

ref 
"UVM實戰" by 張強


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

1.Cadence的xrun若只在最上層加入`timescale 1ns/1ps，會有模擬時間不匹配的問題，最好的做法是使用filelist，並統一在filelist定義時間解析度。

2.需在第一份被編譯到的code中加入
`include "uvm_macros.svh"
import uvm_pkg::*;

3.在top_tb.sv中include其餘的block

4.在filelist中，要把最上層的放最下面，底層的放上面(compiler會照順序編譯)
