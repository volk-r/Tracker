//
//  CoreDataStackProtocol.swift
//  Tracker
//
//  Created by Roman Romanov on 17.09.2024.
//

import Foundation
import CoreData

protocol CoreDataStackProtocol: AnyObject {
    var context: NSManagedObjectContext { get }
    func saveContext()
}
