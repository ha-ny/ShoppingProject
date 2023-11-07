//
//  NaverSearchData.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/09/09.
//

import Foundation

struct NaverSearchData: Codable {
    let total, start, display: Int
    var items: [Item]
}

struct Item: Codable {
    let productId, title: String
    let link: String
    let image, mallName: String
    let lprice: String

    enum CodingKeys: String, CodingKey {
        case productId, title, link, image, lprice, mallName
    }
}
