//
//  Item+CoreDataProperties.swift
//  IkmanAssignment
//
//  Created by Hanushka Suren on 10/13/18.
//  Copyright © 2018 Hanushka Suren. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var desc: String?
    @NSManaged public var id: Int16
    @NSManaged public var image_thumbnail_data: NSData?
    @NSManaged public var image_url: String?
    @NSManaged public var title: String?

}
