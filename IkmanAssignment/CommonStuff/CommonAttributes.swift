//
//  CommonAttributes.swift
//  IkmanAssignment
//
//  Created by Hanushka Suren on 10/11/18.
//  Copyright © 2018 Hanushka Suren. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

struct CommonAttributes {
    
    public static let USER_DEFAULTS = UserDefaults.standard
    public static let SCREEN_WIDTH = UIScreen.main.bounds.width
    public static let SCREEN_HEIGHT = UIScreen.main.bounds.height
    public static let JSON_URL = "https://gist.githubusercontent.com/ashwini9241/6e0f26312ddc1e502e9d280806eed8bc/raw/7fab0cf3177f17ec4acd6a2092fc7c0f6bba9e1f/saltside-json-data"
    
    static var itemThumbnailHeight: CGFloat = 80.0 * 0.8
    static var itemThumbnailWidth: CGFloat = 80.0 * 0.8
}
