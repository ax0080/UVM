在driver中等待時鐘事件 **`（@posedge top.clk）`**和給DUT中輸入端口賦值**`（top.rx_dv <= 1‘b1）`**都是使用絕對路徑，
絕對路徑的使用大大減弱了驗證平台的可移植性。一個最簡單的例子就是假如clk信號的層次從**`top.clk`**變成了**`top.clk_inst.clk`**，
那麼就需要對driver中的相關代碼做大量修改。因此，從根本上來說，應該盡量杜絕在驗證平台中使用絕對路徑。

interface只能用在module裡面。而在class中，我們要使用virtual interface。

build_phase是UVM中的一個內建phase，與**`main_phase`**一樣，當UVM啟動後，會自動執行**`build_phas`**。**`build_phase`**在new函數之後、**`main_phase`**之前執行。在**`build_phase`**中主要通過**`config_db`**的set和get操作來傳遞一些數據，以及實例化成員變數等。需要注意的是，這裡需要加入**`super.build_phase`**語句，因為在其父類的**`build_phase`**中執行了一些必要的操作，這裡必須顯式地調用並執行它。**`build_phase`**與**`main_phase`**不同的一點在於，build_phase`**是一個函數phase，而**`main_phase`**是一個任務phase。**`build_phase`**是不消耗仿真時間的。**`build_phase`**總是在仿真時間（$time函數打印出的時間）為0時執行。

在**`build_phase`**中出現了**`uvm_fatal`**宏，**`uvm_fatal`**宏是一個類似於**`uvm_info`**的宏，但是它只有兩個參數，這兩個參數與**`uvm_info`**宏的前兩個參數的意義完全一樣。與uvm_info宏不同的是，當它打印第二個參數所示的信息後，會直接調用Verilog的**`finish`**函數來結束仿真。**`uvm_fatal`**的出現表示驗證平台出現了重大問題而無法繼續下去，必須停止仿真並做相應的檢查。所以對於**`uvm_fatal`**來說，**`uvm_info`**中出現的第三個參數的冗余度級別是完全沒有意義的，只要是**`uvm_fatal`**打印的信息，就一定是非常關鍵的，所以無需設置第三個參數。


要將 **`top_tb`** 中的 **`input_if`** 和 **`my_driver`** 中的 **`vif`** 對應起來，最簡單的方法是直接進行賦值。然而，這會引出一個新的問題：在 **`top_tb`** 中通過 **`run_test`** 語句建立了一個 **`my_driver`** 的實例，但應該如何引用這個實例呢？不可能像引用 **`my_dut`** 那樣直接引用 **`my_driver`** 中的變數：**`top_tb.my_dut.xxx`** 是可以的，但是 **`top_tb.my_driver.xxx`** 是不可以的。這個問題的根本原因在於UVM通過 **`run_test`** 語句實例化了一個脫離了 **`top_tb`** 層次結構的實例，建立了一個新的層次結構。

對於這種脫離了 **`top_tb`** 層次結構，同時又期望在 **`top_tb`** 中對其進行某些操作的實例，UVM引入了config_db機制。在config_db機制中，分為 set 和 get 兩步操作。所謂 set 操作，讀者可以簡單地理解成是“寄信”，而 get 則相當於是“收信”。在 **`top_tb`** 中執行 set 操作

**`config_db`** 的 **`set`** 和 **`get`** 函數都有四個參數，這兩個函數的第三個參數必須完全一致。**`set`** 函數的第四個參數表示要將哪個 interface 通過 **`config_db`** 傳遞給 **`my_driver`**，**`get`** 函數的第四個參數表示把得到的 interface 傳遞給哪個 **`my_driver`** 的成員變數。**`set`** 函數的第二個參數表示的是路徑索引，即在 2.2.1 节介绍 **`uvm_info`** 宏時提及的路徑索引。在 **`top_tb`** 中通過 **`run_test`** 創建了一個 **`my_driver`** 的實例，那麼這個實例的名字是什麼呢？答案是 **`uvm_test_top`**：UVM 通過 **`run_test`** 語句創建一個名為 **`uvm_test_top`** 的實例。

**`config_db`** 的 **`set`** 和 **`get`** 函數都有四個參數，這兩個函數的第三個參數必須完全一致。**`set`** 函數的第四個參數表示要將哪個 interface 通過 **`config_db`** 傳遞給 **`my_driver`**，**`get`** 函數的第四個參數表示把得到的 interface 傳遞給哪個 **`my_driver`** 的成員變數。**`set`** 函數的第二個參數表示的是路徑索引，即在 2.2.1 节介绍 **`uvm_info`** 宏時提及的路徑索引。

在 **`top_tb`** 中通過 **`run_test`** 創建了一個 **`my_driver`** 的實例，那麼這個實例的名字是什麼呢？答案是 **`uvm_test_top`**：UVM 通過 **`run_test`** 語句創建一個名為 **`uvm_test_top`** 的實例。讀者可以通過查看代碼清單2-3中的語句插入 **`my_driver`**（在 **`build_phase`** 或 **`main_phase`** 中）來進行驗證。無論傳遞給 **`run_test`** 的參數是什麼，創建的實例的名字都為 **`uvm_test_top`**。由於 **`set`** 操作的目標是 **`my_driver`**，所以 **`set`** 函數的第二個參數就是 **`uvm_test_top`**。**`set`** 函數的第一個參數 **`null`** 以及 **`get`** 函數的第一和第二個參數可以暫時放在一邊，後文會詳細說明。

**`set`** 函數與 **`get`** 函數讓人疑惑的另外一點是其古怪的寫法。使用雙冒號是因為這兩個函數都是靜態函數，而 **`uvm_config_db#（virtual my_if）`** 則是一個參數化的類別，其參數就是要寄信的類型，這裡是 **`virtual my_if`**。
