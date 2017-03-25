//
//  UITableView+LC.swift
//  TableViewPlaceHolderDemo
//
//  Created by 梁亦明 on 2017/3/20.
//  Copyright © 2017年 EMA-Tech. All rights reserved.
//

import Foundation

@objc protocol LCTableViewDataSource: class, UITableViewDataSource {
    optional
    func placeHolderView(tableView: UITableView) -> UIView
}

extension UITableView {
    
    func lc_reloadRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation: UITableViewRowAnimation) {
        reloadRowsAtIndexPaths(indexPaths, withRowAnimation: withRowAnimation)
        checkEmpty()
    }
    
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
