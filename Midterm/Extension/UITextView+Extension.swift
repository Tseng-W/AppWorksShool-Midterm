//
//  UITextView+Extension.swift
//  Midterm
//
//  Created by 曾問 on 2021/5/7.
//

import UIKit

extension UITextView {
    
    func newHeight(baseHeight: CGFloat) -> CGFloat {
        
        let fixedWidth = frame.size.width
        
        let newSize = sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        
        var newFrame = frame
        
        let height: CGFloat  = newSize.height > baseHeight ? newSize.height : baseHeight
        
        newFrame.size = CGSize(width: newSize
                                .width, height: height)
        
        return newFrame.height
    }
}
