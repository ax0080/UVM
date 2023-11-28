一個 sequence 在向 sequencer 發送 transaction 前，必須先向 sequencer 發送請求。sequencer 把這個請求放在一個仲裁隊列中。作為 sequencer，它需要執行兩個任務：首先，檢查仲裁隊列中是否有某個 sequence 發送 transaction 的請求；其次，檢查 driver 是否申請 transaction。

1）如果仲裁隊列中有發送請求，但是 driver 沒有申請 transaction，那麼 sequencer 將一直處於等待 driver 的狀態，直到 driver 申請新的 transaction。在這種情況下，sequencer 同意 sequence 的發送請求，sequence 在得到 sequencer 的批准後，產生一個 transaction 並交給 sequencer，後者將這個 transaction 交給 driver。

2）如果仲裁隊列中沒有發送請求，但是 driver 向 sequencer 申請新的 transaction，那麼 sequencer 將處於等待 sequence 的狀態，一直到有 sequence 提交發送請求為止。sequencer 馬上同意這個請求，sequence 產生 transaction 並交給 sequencer，最終 driver 獲得這個 transaction。

3）如果仲裁隊列中有發送請求，同時 driver 也在向 sequencer 申請新的 transaction，那麼 sequencer 會同意發送請求，sequence 產生 transaction 並交給 sequencer，最終 driver 獲得這個 transaction。

driver 如何向 sequencer 申請 transaction 呢？在 uvm_driver 中有成員變量 seq_item_port，而在 uvm_sequencer 中有成員變量 seq_item_export，這兩者之間可以建立一個「通道」，通道中傳遞的 transaction 類型就是定義 my_sequencer 和 my_driver 時指定的 transaction 類型，在這裡是 my_transaction。當然了，這裡並不需要顯式地指定「通道」的類型，UVM 已經做好了。在 my_agent 中，使用 connect 函數把兩者聯繫在一起。
