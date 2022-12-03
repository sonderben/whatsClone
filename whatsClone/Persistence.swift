//
//  Persistence.swift
//  whatsClone
//
//  Created by Benderson Phanor on 16/8/22.
//

import Foundation
import CoreData

struct PersistenceControler{
    static let shared = PersistenceControler()
    let container: NSPersistentContainer
    
    init(){
        container = NSPersistentContainer(name:"CoreData")
        container.loadPersistentStores{ (storeDescription,error) in
            if let error = error as NSError?{
                fatalError("container load failed: \(error)")
            }
            
        }
        
    }
}
