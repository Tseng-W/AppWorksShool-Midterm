//
//  TextView+Extension.swift
//  Midterm
//
//  Created by 曾問 on 2021/5/7.
//

import UIKit



@IBDesignable
extension UITextView {
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            nil
        }
        
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
        
}
