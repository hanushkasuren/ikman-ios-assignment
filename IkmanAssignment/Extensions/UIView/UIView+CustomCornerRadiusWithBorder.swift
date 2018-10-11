//
//  UIView+CustomCornerRadius.swift
//  IkmanAssignment
//
//  Created by Hanushka Suren on 10/11/18.
//  Copyright © 2018 Hanushka Suren. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func customRoundCornersWithBorder(corners:UIRectCorner, radius: CGFloat, borderColor: UIColor?, borderWidth: CGFloat?) {
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
        if borderColor != nil && borderWidth != nil{
            
            let frameLayer = CAShapeLayer()
            frameLayer.frame = bounds
            frameLayer.path = path.cgPath
            frameLayer.strokeColor = borderColor!.cgColor
            frameLayer.fillColor = nil
            frameLayer.lineWidth = borderWidth!
            
            self.layer.addSublayer(frameLayer)
        }
       
    }
}
