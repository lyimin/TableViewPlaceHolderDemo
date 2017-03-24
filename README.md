# Swift如何设置TableView无数据占位图

在开发中经常会遇到从服务器中加载数据，数据返回的数组数量为0的情况，遇到这种情况App端需要一个View来提示用户。具体做法如下

### 1.定义一个协议LCTableViewDataSource，这个协议继承UITableViewDataSource，在这个协议中定义一个返回UIView的方法给Controller调用。

```swift
@objc protocol LCTableViewDataSource: class, UITableViewDataSource {
    optional
    func placeHolderView(tableView: UITableView) -> UIView
}
```

### 2.扩展UITableView，提供一个lc_reloadData方法刷新界面

```swift
extension UITableView {
    func lc_reloadData() {
        reloadData()
        checkEmpty()
    }
}
```

### 3.提供一个checkEmpty的方法检测数据源是否为空，如果为空就显示占位图。

```swift
extension UITableView {
    func lc_reloadData() {
        reloadData()
        checkEmpty()
    }
    
    /// 检测tableView dataSource是否为空
    private func checkEmpty() {
        guard dataSource != nil else {
            return
        }
        
        guard dataSource is LCTableViewDataSource else {
            return
        }
        
        let ds = dataSource as! LCTableViewDataSource
        // 获取tableView组数
        var sections = 1
        if ds.respondsToSelector(#selector(ds.numberOfSectionsInTableView(_:))) {
            sections = ds.numberOfSectionsInTableView!(self)
        }
        // 判断是否有行数
        var isEmpty = true
        [sections].forEach {
            if ds.tableView(self, numberOfRowsInSection: $0) != 0 {
                isEmpty = false
            }
        }
        
        if isEmpty {
            if ds.respondsToSelector(#selector(ds.placeHolderView)) {
                let placeHolderView = ds.placeHolderView!(self)
                placeHolderView.frame = bounds
                placeHolderView.center = center
                addSubview(placeHolderView)
            } 
        }
    }
}
```

### 具体用法
- 实现LCTableViewDataSource的placeHolderView方法
- 刷新数据时使用lc_reloadData方法

```swift
class ViewController: UITableViewDelegate, LCTableViewDataSource {
    ...
    func placeHolderView(tableView: UITableView) -> UIView {
        ...
    }
}
```
