//
//  Object.swift
//  Midterm
//
//  Created by 曾問 on 2021/5/7.
//

import Foundation

enum Result<T> {
    
    case success(T)
    
    case failed(Error)
}

struct ArticleData: Codable {
    
    var id: String
    var createdTime: TimeInterval
    
    var author: Author
    var title: String
    var content: String
    var category: String
    
    init(id: String, createdTime: TimeInterval, author: Author, title: String, content: String, category: String) {
        self.id = id
        self.createdTime = createdTime
        self.author = author
        self.title = title
        self.content = content
        self.category = category
    }
    
    init(author: Author, title: String, content: String, category: String) {
        self.init(id: "", createdTime: 0, author: author, title: title, content: content, category: category)
    }
    
    
    mutating func setUniqueInfo(id: String, createdTime: TimeInterval){
        self.id = id
        self.createdTime = createdTime
    }
}

struct Author: Codable {
    
    var email: String
    var id: String
    var name: String
}
