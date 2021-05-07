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
                submitButton.backgroundColor = .systemIndigo
            } else {
                submitButton.backgroundColor = .systemGray3
            }
        }
    }
    
    private var presentingData: ArticleData? {
        didSet {
            let canEdit = presentingData != nil
            titleTextField.isEnabled = canEdit
            categoryTextField.isEnabled = canEdit
            contentTextView.isEditable = canEdit
            submitButton.isHidden = !canEdit
            
            if canEdit {
                titleTextField.text = .empty
                categoryTextField.text = .empty
                contentTextView.text = contentViewPlaceHolder
                contentTextView.textColor = .systemGray3
            } else {
                titleTextField.text = presentingData!.title
                categoryTextField.text = presentingData!.category
                contentTextView.text = presentingData!.content
                contentTextView.textColor = .black
            }
        }
    }

    private let contentViewPlaceHolder = "輸入內容"
    
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
            presentingData = nil
            return
        }
        presentingData = articleData
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
            delegate?.hidden(self)
            return
        }
        
        LKProgressHUD.showFailure(text: "請輸入內容")
    }
}

extension PublishViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if categoryTextField.text != .empty,
           titleTextField.text != .empty,
           contentTextView.text != .empty,
           contentTextView.text != contentViewPlaceHolder {
            isCanPublish = true
            return
        }
        isCanPublish = false
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = .black
        if textView.text == contentViewPlaceHolder {
            textView.text = .empty
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if categoryTextField.text != .empty,
           titleTextField.text != .empty,
           contentTextView.text != .empty,
           contentTextView.text != contentViewPlaceHolder {
            isCanPublish = true
            return
        }
        
        if contentTextView.text == .empty {
            contentTextView.textColor = .systemGray3
            contentTextView.text = contentViewPlaceHolder
        }
        
        isCanPublish = false
    }
}
