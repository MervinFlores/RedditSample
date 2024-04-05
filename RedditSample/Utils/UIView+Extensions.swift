//
//  UIView+Extensions.swift
//  RedditSample
//
//  Created by Mervin Flores on 4/5/24.
//

import UIKit

extension UIView {
    func configureCornerRadiusAndShadow(cornerRadius: CGFloat = 12.0, shadowOpacity: Float = 0.5, shadowRadius: CGFloat = 4.0, shadowOffset: CGSize = CGSize(width: 0, height: 2), shadowColor: UIColor = .black) {
        
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
        
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
    }
}
