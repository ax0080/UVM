在 driver 中等待時鐘事件（@posedge top.clk）和給 DUT 中輸入端口賦值（top.rx_dv<=1‘b1）都是使用絕對路徑，絕對路徑的使用大大減弱了驗證平台的可移植性。一個最簡單的例子就是假如 clk 信號的層次從 top.clk 變成了 top.clk_inst.clk，那麼就需要對 driver 中的相關代碼做大量修改。因此，從根本上來說，應該盡量杜絕在驗證平台中使用絕對路徑。

interface只能用在module裡面。而在class中，我們要使用virtual interface。

build_phase 是UVM中的一個內建 phase，與 main_phase 一樣，當UVM啟動後，會自動執行 build_phase。build_phase 在 new 函數之後、main_phase 之前執行。在 build_phase 中主要通過 config_db 的 set 和 get 操作來傳遞一些數據，以及實例化成員變數等。需要注意的是，這裡需要加入 super.build_phase 語句，因為在其父類的 build_phase 中執行了一些必要的操作，這裡必須顯式地調用並執行它。build_phase 與 main_phase 不同的一點在於，build_phase 是一個函數 phase，而 main_phase 是一個任務 phase。build_phase 是不消耗仿真時間的。build_phase 總是在仿真時間（$time 函數打印出的時間）為0時執行。
