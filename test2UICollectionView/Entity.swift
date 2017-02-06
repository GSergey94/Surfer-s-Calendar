//
//  Entity.swift
//  test2UICollectionView
//
//  Created by Владимир on 03.02.16.
//  Copyright © 2016 Gorelovskiy. All rights reserved.
//

import Foundation
import CoreData


class Entity: NSManagedObject {

    @NSManaged var additional: String?
    @NSManaged var comment: String?
    @NSManaged var day: NSNumber?
    @NSManaged var endtraining: String?
    @NSManaged var location: String?
    @NSManaged var mouth: NSNumber?
    @NSManaged var photo: Data?
    @NSManaged var rate: String?
    @NSManaged var starttraining: String?
    @NSManaged var training: NSNumber?
    @NSManaged var weave: String?
    @NSManaged var year: NSNumber?
    @NSManaged var delete: NSNumber?
}
