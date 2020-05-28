//
//  CustomUIView.swift
//  Coronavirus Tracking
//
//  Created by Yasin Shamrat on 21/5/20.
//  Copyright © 2020 Yasin Shamrat. All rights reserved.
//

import UIKit

class CustomUIView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setRadiusAndShawdow()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setRadiusAndShawdow()
    }
    func setRadiusAndShawdow() {
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.masksToBounds = false
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowColor = UIColor.black.cgColor
    }
}
