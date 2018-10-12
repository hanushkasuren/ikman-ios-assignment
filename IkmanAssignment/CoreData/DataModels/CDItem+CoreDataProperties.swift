//
//  CDItem+CoreDataProperties.swift
//  IkmanAssignment
//
//  Created by Hanushka Suren on 10/12/18.
//  Copyright © 2018 Hanushka Suren. All rights reserved.
//
//

import Foundation
import CoreData


extension CDItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDItem> {
        return NSFetchRequest<CDItem>(entityName: "CDItem")
    }

    @NSManaged public var desc: String?
    @NSManaged public var image_thumbnail_data: NSData?
    @NSManaged public var image_url: String?
    @NSManaged public var title: String?

}
