//
//  Persister.swift
//  Braavos
//
//  Created by Richard Blanchard on 2/11/19.
//  Copyright © 2019 Richard Blanchard. All rights reserved.
//

import Foundation
import CoreData

public protocol Persister {
    associatedtype ResponseDataType
    associatedtype PersistedType: NSManagedObject

    func transform(responseDataType: ResponseDataType, in context: NSManagedObjectContext) throws -> PersistedType?
}
