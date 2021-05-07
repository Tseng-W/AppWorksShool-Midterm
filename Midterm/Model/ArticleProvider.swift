//
//  Object.swift
//  Midterm
//
//  Created by 曾問 on 2021/5/7.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class ArticleProvider {
    
    enum Collection: String {
        case articles
    }
    
    static let shared = ArticleProvider()
    
    var articleData: BoxLisener<[ArticleData]?> = BoxLisener(nil)
    
    let db = Firestore.firestore()
    
    func getData() {
        let articles = db.collection(Collection.articles.rawValue)
        articles.getDocuments { snapShot, error in
            if let error = error {
                print(error)
            } else {
                self.articleData.value = snapShot!.documents.compactMap {
                    snapShot in
                    try? snapShot.data(as: ArticleData.self)
                }.sorted { $0.createdTime > $1.createdTime }
            }
        }
    }
    
    func snapData() {
        db.collection(Collection.articles.rawValue)
            .addSnapshotListener  { snapShot, error in
                guard let documentChange = snapShot else {
                    LKProgressHUD.showFailure(text: "snapShot 連接失敗")
                    return
                }
                
                var originData = self.articleData.value ?? []
                
                documentChange.documentChanges.forEach { diff in
                    switch diff.type {
                    case .added:
                        do {
                            try originData.insert(diff.document.data(as: ArticleData.self)!, at: 0)
                        } catch let error {
                            print(error)
                        }
                    case .modified:
                        break
                    case .removed:
                        do {
                            let removedData = try diff.document.data(as: ArticleData.self)
                            originData.remove(at: originData.firstIndex { $0.createdTime == removedData?.createdTime && $0.id == removedData?.id }!)
                        } catch let error {
                            print(error)
                        }
                    }
                }
                self.articleData.value = originData.sorted { $0.createdTime > $1.createdTime }
            }
    }
    
    func addData(data: ArticleData, completion: @escaping (Bool) -> Void) {
        let articles = db.collection(Collection.articles.rawValue)
        let document = articles.document()
        var newData =  data
        newData.setUniqueInfo(id: document.documentID, createdTime: NSDate().timeIntervalSince1970)
        do {
            try document.setData(from: newData)
            completion(true)
        } catch let error {
            print("error: \(error)")
            completion(false)
        }
    }
}
