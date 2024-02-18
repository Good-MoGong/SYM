//
//  DiaryEntity+CoreDataProperties.swift
//  
//
//  Created by 민근의 mac on 2/16/24.
//
//

import Foundation
import CoreData


extension DiaryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryEntity> {
        return NSFetchRequest<DiaryEntity>(entityName: "DiaryEntity")
    }

    @NSManaged public var action: String
    @NSManaged public var date: String
    @NSManaged public var emotion: [String]
    @NSManaged public var event: String
    @NSManaged public var idea: String
    @NSManaged public var userId: String

}
