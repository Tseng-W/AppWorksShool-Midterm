//
//  PublishViewController.swift
//  Midterm
//
//  Created by 曾問 on 2021/5/7.
//

import UIKit

protocol PublishDelegate: AnyObject {
    
    func hidden(_ controller: PublishViewController)
    
    func publish(_ controller: PublishViewController, title: String, category: String, content: String)
}

class PublishViewController: UIViewController {
    
    @IBOutlet var titleTextField: UITextField! {
        didSet {
            titleTextField.delegate = self
        }
    }
    
    @IBOutlet var categoryTextField: UITextField! {
        didSet {
            categoryTextField.delegate = self
        }
    }
    
    @IBOutlet var contentTextView: UITextView! {
        didSet {
            contentTextView.delegate = self
            contentTextView.textColor = .systemGray3
        }
    }
    
    @IBOutlet var submitButton: UIButton! {
        didSet {
            isCanPublish = false
        }
    }
    
    weak var delegate: PublishDelegate?
    
    private var isCanPublish = false {
        didSet {
            guard let submitButton = submitButton else { return }
            if isCanPublish {
                submitButton.backgroundColor = .systemGray3
            } else {
                submitButton.backgroundColor = .systemIndigo
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapListener = UITapGestureRecognizer(target: self, action: #selector(disappear))
        tapListener.numberOfTapsRequired = 1
        tapListener.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapListener)
        
        NotificationCenter.default.addObserver(self, selector: #selector(initView(notification:)), name: .updatePublishView, object: nil)
    }
    
    @objc func initView(notification: Notification) {
        
        guard let articleData = notification.userInfo?["data"] as? ArticleData else {
            titleTextField.isEnabled = true
            categoryTextField.isEnabled = true
            contentTextView.isEditable = true
            submitButton.isHidden = false
            titleTextField.text = .empty
            categoryTextField.text = .empty
            contentTextView.text = .empty
            return
        }
        titleTextField.isEnabled = false
        categoryTextField.isEnabled = false
        contentTextView.isEditable = false
        submitButton.isHidden = true
        titleTextField.text = articleData.title
        categoryTextField.text = articleData.category
        contentTextView.text = articleData.content
    }
    
    @objc func disappear() {
        delegate?.hidden(self)
        titleTextField.text = .none
        categoryTextField.text = .none
        contentTextView.text = .none
        contentTextView.textColor = .systemGray3
    }
    
    @IBAction func doPublish(_ sender: UIButton) {
        if titleTextField.text != .empty,
           contentTextView.text != .empty,
           categoryTextField.text != .empty {
            delegate?.publish(self, title: titleTextField.text!, category: categoryTextField.text!, content: contentTextView.text)
            isCanPublish = false
            return
        }
        
        LKProgressHUD.showFailure(text: "請輸入內容")
    }
}

extension PublishViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let _ = titleTextField.text,
              let _ = contentTextView.text,
              let _ = categoryTextField.text else {
            isCanPublish = false
            return
        }
        isCanPublish = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.tintColor = .black
        if textField.text == "輸入內容" {
            textField.text = .empty
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let _ = titleTextField.text,
              let _ = contentTextView.text,
              let _ = categoryTextField.text else {
            isCanPublish = false
            return
        }
        isCanPublish = true
    }
}
