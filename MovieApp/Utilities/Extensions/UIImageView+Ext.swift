//
//  UIImageView+Ext.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 10.03.2024.
//

import UIKit

extension UIImageView {
    
    func makeRounded() {
        
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
}
