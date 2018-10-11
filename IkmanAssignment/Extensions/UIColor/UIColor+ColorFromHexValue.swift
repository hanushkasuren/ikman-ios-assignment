//
//  UIColor+colorFromHexValue.swift
//  IkmanAssignment
//
//  Created by Hanushka Suren on 10/11/18.
//  Copyright © 2018 Hanushka Suren. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int,alphaValue:CGFloat) {
        assert(red >= 0 && red <= 255, "Invalid red component");
        assert(green >= 0 && green <= 255, "Invalid green component");
        assert(blue >= 0 && blue <= 255, "Invalid blue component");
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alphaValue);
    }
    
    convenience init(netHex:Int,alpha:CGFloat = 1.0) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff, alphaValue:alpha);
    }
}
