//
//  HomeView.swift
//  Midterm
//
//  Created by 曾問 on 2021/5/7.
//

import UIKit
import MJRefresh

protocol HomeViewDelegate: UITableViewDelegate, UITableViewDataSource {
    func reloadData()
    func toPublish()
}

class HomeView: UIView {
    
    
    @IBOutlet var toPublishButton: UIButton! {
        didSet {
            toPublishButton.layer.cornerRadius = toPublishButton.frame.width / 2
        }
    }
    
    weak var delegate: HomeViewDelegate? {
        didSet {
            guard let tableView = tableView else { return }
            tableView.delegate = delegate
            tableView.dataSource = delegate
        }
    }

    @IBOutlet var tableView: UITableView! {
        didSet {
            guard let delegate = delegate else { return }
            tableView.delegate = delegate
            tableView.dataSource = delegate
            
            tableView.lk_registerCell(nibName: String(describing: HomeTableViewCell.self), bundle: nil)
            
            tableView.mj_header = MJRefreshNormalHeader()
            tableView.mj_header?.setRefreshingTarget(self, refreshingAction: #selector(reloadTable))
        }
    }
    
    func endRefreshing() {
        tableView.mj_header?.endRefreshing()
    }
    
    @IBAction func toPublish(_ sender: Any) {
        delegate?.toPublish()
    }
    
    @objc func reloadTable() {
        delegate?.reloadData()
    }
}
