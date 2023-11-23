
reference model 用於完成和 DUT 相同的功能。reference model 的輸出被 scoreboard 接收，用於和 DUT 的輸出相比較。

my_model 是從 i_agt 中得到 my_transaction，並將 my_transaction 傳遞給 my_scoreboard。在 UVM 中，通常使用 TLM（Transaction Level Modeling）實現 component 之間 transaction 級別的通信。

要實現通信，有兩點是值得考慮的：第一，數據是如何發送的？第二，數據是如何接收的？在 UVM 的 transaction 級別通信中，數據的發送有多種方式，其中一種是使用 uvm_analysis_port。

uvm_analysis_port 是一個參數化的類，其參數就是這個 analysis_port 需要傳遞的數據的類型，在本節中是 my_transaction。聲明了 ap 後，需要在 monitor 的 build_phase 中將其實例化：

write 是 uvm_analysis_port 的一個內建函數。到此，在 my_monitor 中需要為 transaction 通信準備的工作已經全部完成。UVM 的 transaction 級別通信數據接收方式也有多種，其中一種就是使用 uvm_blocking_get_port。這也是一個參數化的類，其參數是要在其中傳遞的 transaction 的類型。在 my_model 的第 6 行中，定義了一個端口，并在 build_phase 中對其進行實例化。在 main_phase 中，通過 port.get 任務來得到從 i_agt 的 monitor 中發出的 transaction。

在 my_monitor 和 my_model 中定義並實現了各自的端口之後，通信的功能並沒有實現，還需要在 my_env 中使用 fifo 將兩個端口聯繫在一起。在 my_env 中定義一個 fifo，並在 build_phase 中將其實例化：

fifo 的類型是 uvm_tlm_analysis_fifo，它本身也是一個參數化的類，其參數是存儲在其中的 transaction 的類型，這裡是 my_transaction。
之後，在 connect_phase 中將 fifo 分別與 my_monitor 中的 analysis_port 和 my_model 中的 blocking_get_port 相連：

這裡引入了 connect_phase。與 build_phase 及 main_phase 類似，connect_phase 也是 UVM 內建的一個 phase，它在 build_phase 執行完成之後馬上執行。但是與 build_phase 不同的是，它的執行順序並不是從樹根到樹葉，而是從樹葉到樹根——先執行 driver 和 monitor 的 connect_phase，再執行 agent 的 connect_phase，最後執行 env 的 connect_phase。
為什麼這裡需要一個 fifo 呢？不能直接把 my_monitor 中的 analysis_port 和 my_model 中的 blocking_get_port 相連吧？由於 analysis_port 是非阻塞性質的，ap.write 函數調用完成後馬上返回，不會等待數據被接收。假如當 write 函數調用時，blocking_get_port 正在忙於其他事情，而沒有準備好接收新的數據時，此時被 write 函數寫入的 my_transaction 就需要一個暫存的位置，這就是 fifo。

在如上的連接中，用到了 i_agt 的一個成員變量 ap，它的定義與 my_monitor 中 ap 的定義完全一樣：

與 my_monitor 中的 ap 不同的是，不需要對 my_agent 中的 ap 進行實例化，而只需要在 my_agent 的 connect_phase 中將 monitor 的值
賦給它，換句話說，這相當於是一個指向 my_monitor 的 ap 的指針：

根據前面介紹的 connect_phase 的執行順序，my_agent 的 connect_phase 的執行順序早於 my_env 的 connect_phase 的執行順序，從而可以保證執行到 i_agt.ap.connect 語句時，i_agt.ap 不是一個空指針。
