//
//  Date+Extension.swift
//  Midterm
//
//  Created by 曾問 on 2021/5/7.
//

import UIKit

extension Date {
    
    func toString() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        
        return formatter.string(from: self)
    }
}
