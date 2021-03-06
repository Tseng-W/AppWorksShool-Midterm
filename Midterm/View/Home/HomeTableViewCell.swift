//
//  HomeTableViewCell.swift
//  Midterm
//
//  Created by 曾問 on 2021/5/7.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    let randomColor: [UIColor] = [.systemRed, .systemBlue, .systemPink, .systemTeal, .systemGreen,. systemOrange, .systemYellow, .systemPurple]
    
    var previousColorIndex = 0
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var authorLabel: UILabel!
    
    @IBOutlet var createdTime: UILabel!
    
    @IBOutlet var categoryButton: UIButton! {
        didSet {
            categoryButton.layer.cornerRadius = categoryButton.frame.width / 4
            categoryButton.setTitleColor(randomColor[previousColorIndex % randomColor.count], for: .normal)
            previousColorIndex += 1
        }
    }
    
    @IBOutlet var contentField: UITextView! {
        didSet {
            contentField.translatesAutoresizingMaskIntoConstraints = true
            contentField.sizeToFit()
            contentField.isScrollEnabled = false
            
            contentField.delegate = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        categoryButton.setTitleColor(randomColor[previousColorIndex % randomColor.count], for: .normal)
        previousColorIndex += 1
    }
}

extension HomeTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        //        let height = textView.newHeight(baseHeight: 200)
        print("textViewDidChange")
    }
}
