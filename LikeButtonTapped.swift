//
//  LikeButtonTapped.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/09/11.
//

import Foundation
import RealmSwift

let realm = try! Realm()

func isLike(data: [Item], tableEdit: Bool = false) -> Bool {
    var data = data[0]
    do {
        let likeData = realm.objects(LikeTable.self).where {
            $0.productId == data.productId
        }
        
        if likeData.count > 0 {
            
            if tableEdit{
                //기존에 있는 productId -> 이미 좋아요 눌린 상태 -> 좋아요 해지
                likeTableDelete(data: likeData)
                return false
            }
            //tableEdit false -> 지금 좋아요 상태
            return true
            
        }else {
            
            if tableEdit{
                likeTableCreate(data: data)
                return true
            }

            return false
        }
    } catch {
        print(error)
    }
}
