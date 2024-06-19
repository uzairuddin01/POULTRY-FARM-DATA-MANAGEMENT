//
//  Poultryfarm+CoreDataProperties.swift
//  poultry farm
//
//  Created by Apple on 18/06/24.
//
//

import Foundation
import CoreData


extension Poultryfarm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Poultryfarm> {
        return NSFetchRequest<Poultryfarm>(entityName: "Poultryfarm")
    }

    @NSManaged public var name: String?
    @NSManaged public var quantity: Int64
    @NSManaged public var purchasePrice: Double

}

extension Poultryfarm : Identifiable {

}
