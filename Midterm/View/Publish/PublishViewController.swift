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
    
    enum Status {
        case view(data: ArticleData)
        case edit
    }
    
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
    
    // Mark: Record current article data, if not nil, hidden button and all text field can't edit.
    var viewStatus: Status? {
        didSet {
            guard let status = viewStatus,
                  let _ = titleTextField else { return }
            initView(status: status)
        }
    }

    private let contentViewPlaceHolder: String = .placeHolder
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapListener = UITapGestureRecognizer(target: self, action: #selector(disappear))
        tapListener.numberOfTapsRequired = 1
        tapListener.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapListener)
    }
 
    func initView(status: Status) {
        switch status {
        case .edit:
            titleTextField.isEnabled = true
            categoryTextField.isEnabled = true
            contentTextView.isEditable = true
            submitButton.isHidden = false
            
            titleTextField.text = .empty
            categoryTextField.text = .empty
            contentTextView.text = contentViewPlaceHolder
            contentTextView.textColor = .systemGray3
        case .view(let data):
            titleTextField.isEnabled = false
            categoryTextField.isEnabled = false
            contentTextView.isEditable = false
            submitButton.isHidden = true
            
            titleTextField.text = data.title
            categoryTextField.text = data.category
            contentTextView.text = data.content
            contentTextView.textColor = .black
        }
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
