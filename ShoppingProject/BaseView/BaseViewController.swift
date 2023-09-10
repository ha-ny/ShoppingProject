//
//  BaseViewController.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/09/08.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configuration()
        setConstraints()
    }
    
    func configuration() { }
    func setConstraints() { }
}
