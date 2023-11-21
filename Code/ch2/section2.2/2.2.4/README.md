在 driver 中等待時鐘事件（@posedge top.clk）和給 DUT 中輸入端口賦值（top.rx_dv<=1‘b1）都是使用絕對路徑，絕對路徑的使用大大減弱了驗證平台的可移植性。一個最簡單的例子就是假如 clk 信號的層次從 top.clk 變成了 top.clk_inst.clk，那麼就需要對 driver 中的相關代碼做大量修改。因此，從根本上來說，應該盡量杜絕在驗證平台中使用絕對路徑。

interface只能用在module裡面。而在class中，我們要使用virtual interface。
