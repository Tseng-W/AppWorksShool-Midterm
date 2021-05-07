//
//  ViewController.swift
//  Midterm
//
//  Created by 曾問 on 2021/5/7.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let mockAuthor = Author(email: "mock@email.com", id: "mockId", name: "mockName")
    
    @IBOutlet var homeView: HomeView! {
        didSet {
            homeView.delegate = self
        }
    }
    
    @IBOutlet var publishView: UIView! {
        didSet {
            publishView.isUserInteractionEnabled = false
            publishView.alpha = 0
        }
    }
    
    private var articleData: [ArticleData] = [] {
        didSet {
            homeView.tableView.reloadData()
            homeView.endRefreshing()
            LKProgressHUD.dismiss()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PublishViewController {
            vc.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LKProgressHUD.show()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateArticalData(notification:)), name: .dataUpdated, object: nil)
        
        ArticleProvider.shared.snapData()
    }
    
    @objc func updateArticalData(notification: Notification) {
        guard let data = notification.userInfo!["data"] as? [ArticleData] else { return }
        articleData = data
    }
}

extension HomeViewController: HomeViewDelegate {
    
    func reloadData() {
        LKProgressHUD.show()
        ArticleProvider.shared.getData()
    }
    
    func toPublish() {
        publishView.isUserInteractionEnabled = true
        
        NotificationCenter.default.post(name: .updatePublishView, object: self, userInfo: nil)
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.publishView.alpha = 1
            self.publishView.layoutIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeTableViewCell.self), for: indexPath)
        
        if let cell = cell as? HomeTableViewCell {
            cell.titleLabel.text = articleData[indexPath.row].title
            cell.contentField.text = articleData[indexPath.row].content
            cell.authorLabel.text = articleData[indexPath.row].author.name
            cell.createdTime.text = Date(timeIntervalSince1970: articleData[indexPath.row].createdTime).toString()
            cell.categoryButton.setTitle(articleData[indexPath.row].category, for: .normal)
            
            // MARK:
            let fixedWidth = cell.contentField.frame.size.width
            let newSize = cell.contentField.sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
            cell.contentField.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            cell.contentField.isScrollEnabled = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        
        NotificationCenter.default.post(name: .updatePublishView, object: self, userInfo: ["data": articleData[indexPath.row]])
        
        publishView.isUserInteractionEnabled = true
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.publishView.alpha = 1
            self.publishView.layoutIfNeeded()
        }
    }
}

extension HomeViewController: PublishDelegate {
    
    func hidden(_ controller: PublishViewController) {
        publishView.isUserInteractionEnabled = false
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.publishView.alpha = 0
            self.publishView.layoutIfNeeded()
        }
    }
    
    func publish(_ controller: PublishViewController, title: String, category: String, content: String) {
        ArticleProvider.shared.addData(
            data: ArticleData(author: mockAuthor, title: title, content: content, category: category)) { isSuccess in
            if isSuccess {
                LKProgressHUD.showSuccess(text: "發布成功")
            } else {
                LKProgressHUD.showFailure(text: "發布失敗")
            }
        }
    }
}
