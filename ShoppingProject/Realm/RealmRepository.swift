//
//  Realm.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/09/11.
//

import Foundation
import RealmSwift

class RealmRepository {
    
    private let realm = try? Realm()
    
    func read() -> [LikeTable] {
        guard let realm else { return [] }
        return Array(realm.objects(LikeTable.self))
    }

    func create(data: LikeTable) {
        guard let realm else { return }
        
        do {
            try realm.write {
                data.title = data.title.replacingOccurrences(of: "[<b></b>]", with: "", options: .regularExpression)
                realm.add(data)
            }
        } catch { }
    }

    func delete(data: LikeTable) {
        guard let realm else { return }
        
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch { }
    }
}
