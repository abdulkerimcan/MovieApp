//
//  UIView+Ext.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 10.03.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}
