//
//  Item.swift
//  IkmanAssignment
//
//  Created by Hanushka Suren on 10/11/18.
//  Copyright © 2018 Hanushka Suren. All rights reserved.
//

import Foundation
import UIKit

struct Item {
    
    var imageURL: String?
    var title: String?
    var description: String?
    var imageThumbnail: UIImage?
    
    init() {
    }
    
    init(imageURL: String?, title: String?, description: String?, imageThumbnail: UIImage?) {
        
        self.imageURL = imageURL
        self.title = title
        self.description = description
        self.imageThumbnail = imageThumbnail
    }
}
