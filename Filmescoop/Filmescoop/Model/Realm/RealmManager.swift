//
//  RealmManager.swift
//  Filmescoop
//
//  Created by Danilo Pena on 24/06/20.
//  Copyright © 2020 Danilo Pena. All rights reserved.
//

import RealmSwift
import Foundation

final class RealmManager<T>: NSObject where T: Object {
        
    class func addObjectInRealm(object: T) -> NSError? {
        if let realm = try? Realm() {
            do {
                try realm.write {
                    realm.add(object, update: .all)
                }
            } catch let error as NSError {
                return error
            }
        }
        return nil
    }
    
    class func deleteObjectsInRealm(object: T) -> NSError? {
        if let realm = try? Realm() {
            do {
                try realm.write {
                    realm.delete(realm.objects(T.self))
                }
            } catch let error as NSError {
                return error
            }
        }
        
        return nil
    }
    
    class func checkRealmMigration() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 0,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { _, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        _ = try? Realm()
    }
}
