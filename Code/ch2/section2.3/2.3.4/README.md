所有的 agent 都要派生自 uvm_agent 類，且其本身是一個 component，應該使用 uvm_component_utils 宏來實現 factory 註冊。這裡最令人困惑的可能是 build_phase 中為何根據 is_active 這個變數的值來決定是否創建 driver 的實例。is_active 是 uvm_agent 的一個成員變數。

只有 uvm_component 才能作為樹的節點，像 my_transaction 這種使用 uvm_object_utils 宏實現的類是不能作為 UVM 樹的節點的。其次，在 my_env 的 build_phase 中，創建 i_agt 和 o_agt 的實例是在 build_phase 中；在 agent 中，創建 driver 和 monitor 的實例也是在 build_phase 中。按照前文所述的 build_phase 的從樹根到樹葉的執行順序，可以建立一棵完整的 UVM 樹。

UVM 要求 UVM 樹最晚在 build_phase 時段完成，如果在 build_phase 後的某個 phase 實例化一個 component。那麼是不是只能在 build_phase 中執行實例化的動作呢？答案是否定的。其實還可以在 new 函數中執行實例化的動作。例如，可以在 my_agent 的 new 函數中實例化 driver 和 monitor：這樣引起的一個問題是無法通過直接賦值的方式向 uvm_agent 傳遞 is_active 的值。在 my_env 的 build_phase（或者 new 函數）中，向 i_agt 和 o_agt 的 is_active 賦值，根本不會產生效果。因此 i_agt 和 o_agt 都工作在 active 模式（is_active 的默認值是 UVM_ACTIVE），這與預想差距甚遠。要解決這個問題，可以在 my_agent 實例化之前使用 config_db 語句傳遞 is_active 的值：

只是在 UVM 中約定俗成的還是在 build_phase 中完成實例化工作。因此，強烈建議僅在 build_phase 中完成實例化。

