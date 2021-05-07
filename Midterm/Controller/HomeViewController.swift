//
//  ViewController.swift
//  Midterm
//
//  Created by 曾問 on 2021/5/7.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let mockAuthor = Author(email: "mock@email.com", id: "mockId", name: "mockName")
    
    private var viewingData: BoxLisener<ArticleData?> = BoxLisener(nil)
    
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
    
    var articleData = ArticleProvider.shared.articleData
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? PublishViewController {
            controller.delegate = self
            viewingData.bind { articleData in
                controller.viewStatus = articleData == nil ?
                    .edit : .view(data: articleData!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LKProgressHUD.show()
        
        ArticleProvider.shared.articleData.bind { data in
            self.homeView.tableView.reloadData()
            self.homeView.endRefreshing()
            LKProgressHUD.dismiss()
        }
        
        ArticleProvider.shared.snapData()
    }
    
    func switchHidden(controller: UIView, isHidden: Bool) {
        
        publishView.isUserInteractionEnabled = !isHidden
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.publishView.alpha = isHidden ? 0 : 1
            self.publishView.layoutIfNeeded()
        }
    }
}

extension HomeViewController: HomeViewDelegate {
    
    func reloadData() {
        LKProgressHUD.show()
        ArticleProvider.shared.getData()
    }
    
    func toPublish() {
        viewingData.value = nil
        switchHidden(controller: publishView, isHidden: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articleData.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeTableViewCell.self), for: indexPath)
        
        if let cell = cell as? HomeTableViewCell {
            cell.titleLabel.text = articleData.value![indexPath.row].title
            cell.contentField.text = articleData.value![indexPath.row].content
            cell.authorLabel.text = articleData.value![indexPath.row].author.name
            cell.createdTime.text = Date(timeIntervalSince1970: articleData.value![indexPath.row].createdTime).toString()
            cell.categoryButton.setTitle(articleData.value![indexPath.row].category, for: .normal)
            
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
        viewingData.value = articleData.value![indexPath.row]
        
        switchHidden(controller: publishView, isHidden: false)
    }
}

extension HomeViewController: PublishDelegate {
    
    func hidden(_ controller: PublishViewController) {
        switchHidden(controller: publishView, isHidden: true)
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
