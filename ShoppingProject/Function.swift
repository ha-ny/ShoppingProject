//
//  Function.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/09/09.
//

import UIKit

func messageAlert(message: String) {
    let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "확인", style: .cancel))
    
}
