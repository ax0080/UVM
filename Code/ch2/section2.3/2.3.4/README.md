只有 uvm_component 才能作為樹的節點，像 my_transaction 這種使用 uvm_object_utils 宏實現的類是不能作為 UVM 樹的節點的。其次，在 my_env 的 build_phase 中，創建 i_agt 和 o_agt 的實例是在 build_phase 中；在 agent 中，創建 driver 和 monitor 的實例也是在 build_phase 中。按照前文所述的 build_phase 的從樹根到樹葉的執行順序，可以建立一棵完整的 UVM 樹。UVM 要求 UVM 樹最晚在 build_phase 時段完成，如果在 build_phase 後的某個 phase 實例化一個 component。






