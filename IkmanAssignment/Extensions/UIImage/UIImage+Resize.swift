//
//  UIImage+resize.swift
//  Vislaw
//
//  Created by Hanushka Suren on 3/25/17.
//  Copyright © 2017 OLIT. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    
    public func scaleTosize(_ newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
