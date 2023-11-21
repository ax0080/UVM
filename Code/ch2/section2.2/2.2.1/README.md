**`driver`** 所做的事情幾乎都在 **`main_phase`** 中完成。UVM 由 **`phase`** 來管理驗證平台的運行，這些  統一以 **`xxxx_phase`** 來命名，且都有一個類型為 **`uvm_phase`**、名字為  的參數。 是 **`uvm_driver`** 中預先定義好的一個任務。因此幾乎可以簡單地認為，實現一個  等於實現其 。

**`task main_phase(uvm_phase phase);`：** 這部分聲明了一個名為 **`main_phase`** 的 **`task`**，接受一個 **`uvm_phase`** 類型的參數 **`phase`**。 是一種用於描述並發出協同執行的 SystemVerilog 構造。
