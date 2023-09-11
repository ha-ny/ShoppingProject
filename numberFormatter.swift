//
//  numberFormatter.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/09/11.
//

import Foundation

func numberFormatter(number: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    
    return numberFormatter.string(from: NSNumber(value: number))!
}
