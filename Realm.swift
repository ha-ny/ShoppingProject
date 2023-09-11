//
//  Realm.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/09/11.
//

import Foundation
import RealmSwift

func likeTableCreate(data: Item) {

    do {
        try realm.write {
            realm.add(LikeTable(productId: data.productId, imageURL: data.image, mallName: data.mallName, title: data.title, price: data.lprice))
        }
    } catch {
        print(error)
    }
}

func likeTableDelete(data: Results<LikeTable>) {
    
    do {
        try realm.write {
            realm.delete(data)
        }
    }catch {
        print(error)
    }
}
