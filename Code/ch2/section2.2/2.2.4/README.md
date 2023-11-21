在 driver 中等待時鐘事件（@posedge top.clk）和給 DUT 中輸入端口賦值（top.rx_dv<=1‘b1）都是使用絕對路徑，絕對路徑的使用大大減弱了驗證平台的可移植性。一個最簡單的例子就是假如 clk 信號的層次從 top.clk 變成了 top.clk_inst.clk，那麼就需要對 driver 中的相關代碼做大量修改。因此，從根本上來說，應該盡量杜絕在驗證平台中使用絕對路徑。
interface只能用在module裡面。而在class中，我們要使用virtual interface。

build_phase 是UVM中的一個內建 phase，與 main_phase 一樣，當UVM啟動後，會自動執行 build_phase。build_phase 在 new 函數之後、main_phase 之前執行。在 build_phase 中主要通過 config_db 的 set 和 get 操作來傳遞一些數據，以及實例化成員變數等。需要注意的是，這裡需要加入 super.build_phase 語句，因為在其父類的 build_phase 中執行了一些必要的操作，這裡必須顯式地調用並執行它。build_phase 與 main_phase 不同的一點在於，build_phase 是一個函數 phase，而 main_phase 是一個任務 phase。build_phase 是不消耗仿真時間的。build_phase 總是在仿真時間（$time 函數打印出的時間）為0時執行。

在 build_phase 中出現了 uvm_fatal 宏，uvm_fatal 宏是一個類似於 uvm_info 的宏，但是它只有兩個參數，這兩個參數與 uvm_info 宏的前兩個參數的意義完全一樣。與 uvm_info 宏不同的是，當它打印第二個參數所示的信息後，會直接調用 Verilog 的 finish 函數來結束仿真。uvm_fatal 的出現表示驗證平台出現了重大問題而無法繼續下去，必須停止仿真並做相應的檢查。所以對於 uvm_fatal 來說，uvm_info 中出現的第三個參數的冗余度級別是完全沒有意義的，只要是 uvm_fatal 打印的信息，就一定是非常關鍵的，所以無需設置第三個參數。
