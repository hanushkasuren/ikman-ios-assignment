//
//  Item.swift
//  IkmanAssignment
//
//  Created by Hanushka Suren on 10/11/18.
//  Copyright © 2018 Hanushka Suren. All rights reserved.
//

import Foundation

struct Item {
    
    var imageURL: String?
    var title: String?
    var description: String?
    
    init() {
    }
    
    init(imageURL: String?, title: String?, description: String?) {
        
        self.imageURL = imageURL
        self.title = title
        self.description = description
    }
}
