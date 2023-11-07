//
//  LikeTable.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/09/10.
//

import Foundation
import RealmSwift

class LikeTable: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var productId: String
    @Persisted var imageURL: String
    @Persisted var mallName: String
    @Persisted var title: String
    @Persisted var price: String
    @Persisted var createDate: Date

    convenience init(productId: String, imageURL: String, mallName: String, title: String, price: String) {
        self.init()
        
        self.productId = productId
        self.imageURL = imageURL
        self.mallName = mallName
        self.title = title
        self.price = price
    }
}
