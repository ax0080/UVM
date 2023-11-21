在驗證平台中加入參考模型（reference model）、分數板（scoreboard）等之前，思考一個問題：假設這些組件已經定義好了，那麼在驗證平台的什麼位置對它們進行實例化呢？在 **`top_tb`** 中使用 **`run_test`** 進行實例化顯然是不行的，因為 **`run_test`** 函數雖然強大，但也只能實例化一個實例；如果在 **`top_tb`** 中使用 2.2.1 節中實例化 **`driver`** 的方式顯然也不可行，因為 **`run_test`** 相當於在 **`top_tb`** 結構層次之外建立一個新的結構層次，而 2.2.1 節的方式則是基於 **`top_tb`** 的層次結構，如果基於此進行實例化，那麼 **`run_test`** 的引用也就沒有太大的意義了；如果在 **`driver`** 中進行實例化則更加不合理。

這個問題的解決方案是引入一個容器類，在這個容器類中實例化 **`driver`**、**`monitor`**、**`reference model`** 和 **`scoreboard`** 等。在調用 **`run_test`** 時，傳遞的參數不再是 **`my_driver`**，而是這個容器類，即讓 UVM 自動創建這個容器類的實例。在 UVM 中，這個容器類稱為 **`uvm_env`**。

在 **`my_env`** 的定義中，最讓人難以理解的是第 14 行 **`drv`** 的實例化。這裡沒有直接調用 **`my_driver`** 的 **`new`** 函數，而是使用了一種古怪的方式。這種方式就是 factory 机制帶來的獨特的實例化方式。只有使用 factory 机制註冊過的類才能使用這種方式實例化；只有使用這種方式實例化的實例，才能使用後文要講述的 factory 機制中最為強大的重載功能。驗證平台中的組件在實例化時都應該使用 **`type_name::type_id::create`** 的方式。

在 **`drv`** 實例化時，傳遞了兩個參數，一個是名字 **`drv`**，另外一個是 **`this`** 指針，表示 **`my_env`**。

回顧一下 **`my_driver`** 的 **`new`** 函數

```verilog
function new(string name = "my_driver", uvm_component parent = null);
	super.new(name, parent);
endfunction
```

這個 **`new`** 函數有兩個參數，第一個參數是實例的名字，第二個則是 **`parent`**。由於 **`my_driver`** 在 **`uvm_env`** 中實例化，所以 **`my_driver`** 的父節點（**`parent`**）就是 **`my_env`**。通過 **`parent`** 的形式，UVM 建立起了樹形的組織結構。在這種樹形的組織結構中，由 **`run_test`** 創建的實例是樹根（這裡是 **`my_env`**），並且樹根的名字是固定的，為 **`uvm_test_top`**，這在前文中已經講述過；在樹根之後會生長出枝葉（這裡只有 **`my_driver`**），長出枝葉的過程需要在 **`my_env`** 的 **`build_phase`** 中手動實現。無論是樹根還是樹葉，都必須由 **`uvm_component`** 或者其派生類繼承而來。整棵 UVM 樹的結構如圖所示。

整個驗證平台中存在兩個 **`build_phase`**，一個是 **`my_env`** 的，一個是 **`my_driver`** 的。那麼這兩個 **`build_phase`** 按照何種順序執行呢？在 UVM 的樹形結構中，**`build_phase`** 的執行遵從從樹根到樹葉的順序，即先執行 **`my_env`** 的 **`build_phase`**，再執行 **`my_driver`** 的 **`build_phase`**。當把整棵樹的 **`build_phase`** 都執行完畢後，再執行後面的 **`phase`**。
