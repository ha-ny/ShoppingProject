//
//  BaseCollectionViewCell.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/09/08.
//

import UIKit
import SnapKit

class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configuration() { }
    func setConstraints() { }
}
