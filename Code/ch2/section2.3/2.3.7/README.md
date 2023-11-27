在2.3.3節中引入 my_monitor 時，在 my_transaction 中加入了 my_print 函數；在2.3.5節中引入 reference model 時，加入了 my_copy 函數；在2.3.6節引入 scoreboard 時，加入了 my_compare 函數。上述三個函數雖然各自不同，但是對於不同的 transaction 來說，都是類似的：它們都需要逐字段地對 transaction 進行某些操作。

那麼有沒有某種簡單的方法，可以通過定義某些規則自動實現這三個函數呢？答案是肯定的。這就是 UVM 中的 field_automation 機制，使用 uvm_field 系列宏實現

引入 field_automation 機制的另外一大好處是簡化了 driver 和 monitor。在2.3.1節及2.3.3節中，my_driver 的 drv_one_pkt 任務和 my_monitor 的 collect_one_pkt 任務代碼很長，但是幾乎都是一些重複性的代碼。
