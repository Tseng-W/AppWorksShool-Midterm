//
//  UITableView+Extension.swift
//  Midterm
//
//  Created by 曾問 on 2021/5/7.
//

import UIKit

extension UITableView {
    
    func lk_registerCell(nibName: String, bundle: Bundle?) {
        register(UINib(nibName: nibName, bundle: bundle), forCellReuseIdentifier: nibName)
    }
}
