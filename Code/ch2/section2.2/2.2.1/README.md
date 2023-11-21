**`driver`** 所做的事情幾乎都在 **`main_phase`** 中完成。UVM 由 **`phase`** 來管理驗證平台的運行，這些  統一以 **`xxxx_phase`** 來命名，且都有一個類型為 **`uvm_phase`**、名字為  的參數。 是 **`uvm_driver`** 中預先定義好的一個任務。因此幾乎可以簡單地認為，實現一個  等於實現其 。

**`task main_phase(uvm_phase phase);`：** 這部分聲明了一個名為 **`main_phase`** 的 **`task`**，接受一個 **`uvm_phase`** 類型的參數 **`phase`**。 是一種用於描述並發出協同執行的 SystemVerilog 構造。

**`uvm_info`** 宏(Macro)在UVM（Universal Verification Methodology）測試環境中用於生成日誌信息，並與Verilog中的 **`display`** 语句類似，但更為強大。它有三個參數，分別是：

1. 第一個參數（字符串）：用於將打印的信息歸類，標識信息的來源或類型。
2. 第二個參數（字符串）：具體需要打印的信息內容。
3. 第三個參數：冗余級別，表示消息的詳細程度。通常有不同的級別，如UVM_LOW、UVM_MEDIUM、UVM_HIGH。UVM_LOW 表示低級冗余，UVM_HIGH 表示高級冗余。
    
    在驗證平台中，某些信息可能非常關鍵，可以將這些信息的冗余級別設置為 UVM_LOW。而有些信息可能是可有可無的，可以將其冗余級別設置為 UVM_HIGH。介於兩者之間的信息可以設置為 UVM_MEDIUM。UVM默認僅顯示 UVM_MEDIUM 或 UVM_LOW 級別的信息，這有助於在測試過程中更有效地檢視關鍵信息。
