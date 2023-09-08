//
//  BaseViewController.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/09/08.
//

import UIKit
import SnapKit

//protocol viewSettingProtocol {
//    func configuration()
//    func addConstraints()
//}

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configuration()
        addConstraints()
    }
    
    func configuration() { }
    
    func addConstraints() { }
}
