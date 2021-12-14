//
//  Utilities.swift
//  RappiTestMovie
//
//  Created by Adrian Dominguez Gómez on 10/12/21.
//

import Foundation
import UIKit

extension UIView {
    
    func addCornerRadius() {
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
    
    func addCornerRadius(Radius: CGFloat) {
        self.layer.cornerRadius = Radius
        self.layer.masksToBounds = true
    }
    
    func addCornerRadius(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
