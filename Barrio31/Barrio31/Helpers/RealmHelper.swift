//
//  RealmHelper.swift
//  Barrio31
//
//  Created by Tomás Fernandez Nuñez on 16/11/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import UIKit
import RealmSwift

//private let realmDataBaseName = "barrio31.realm"
//
//class RealmHelper: NSObject {
//
//    class func removeNotification( notificationToken: inout NotificationToken?) {
//        guard notificationToken != nil else { return }
//
//        notificationToken!.invalidate()
//        notificationToken = nil
//    }
//
//    class func customConfiguration() {
//
//        var config = Realm.Configuration(
//            schemaVersion: currentSchemaVersion,
//            migrationBlock: migrationBlock)
//
//        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent(realmDataBaseName)
//
//        Realm.Configuration.defaultConfiguration = config
//
//        _ = try! Realm()
//    }
//
//}
//
////MARK: Migrations
//extension RealmHelper {
//
//    static var currentSchemaVersion: UInt64 {
//        return 1
//    }
//
//    static var migrationBlock: MigrationBlock {
//        return { (migration, oldSchemaVersion) in
//            if (oldSchemaVersion < currentSchemaVersion) { }
//        }
//    }
//
//}
//
////MARK: Writters
//extension RealmHelper {
//    class func write(object: Object!, update: Bool = true) throws {
//        let realm = try Realm()
//        try realm.write({
//            realm.add(object, update: update)
//        })
//    }
//
//    class func writeObjects(objects: [Object], update: Bool = true) throws {
//        let realm = try Realm()
//        try realm.write({
//            realm.add(objects, update: update)
//        })
//    }
//
//    class func delete(object: Object!) throws {
//        let realm = try Realm()
//        try realm.write({
//            realm.delete(object)
//        })
//    }
//
//    class func deleteAllFromClass<T: Object>(objectClass: T.Type) throws {
//        let realm = try Realm()
//        try realm.write({
//            let allObjects = realm.objects(objectClass)
//            realm.delete(allObjects)
//        })
//    }
//
//}
//
////MARK: Readers
//extension RealmHelper {
//
//    class func getObject<T: Object>(objectClass: T.Type, withID id: String!) throws -> T? {
//        let filteredObject = try getObjects(objectClass: objectClass, withFilterPredicate: NSPredicate(format: "id = %@", id)).first
//        return filteredObject
//    }
//
//    class func getObjects<T: Object>(objectClass: T.Type, withFilterPredicate predicate: NSPredicate? = nil) throws -> Results<T> {
//        let allObjects = try Realm().objects(objectClass)
//
//        if let predicate = predicate {
//            return allObjects.filter(predicate)
//        } else {
//            return allObjects
//        }
//    }
//}
//
////MARK: Readers
//extension RealmHelper {
//
//    class func getPolygons() throws -> Results<Polygon> {
//        return try Realm().objects(Polygon.self)
//    }
//
//    class func getPolygonDetails() throws -> Results<PolygonDetail> {
//        return try Realm().objects(PolygonDetail.self)
//    }
//
//    class func getDisfrutaItem() throws -> Results<DisfrutaItem> {
//        return try Realm().objects(DisfrutaItem.self)
//    }
//}
//
////MARK: Custom writer
//extension RealmHelper {
//
//    class func writePolygon(_ polygons: [Polygon]?) throws {
//        let realm = try Realm()
//
//        if let polygons = polygons {
//            try realm.write({ () -> Void in
//                realm.add(polygons, update: true)
//            })
//
//        } else {
//            try realm.write({ () -> Void in
//                realm.delete(realm.objects(Polygon.self))
//                print("Polygons erased")
//            })
//        }
//    }
//
//    class func writePolygonDetail(_ polygonDetails: [PolygonDetail]?) throws {
//        let realm = try Realm()
//
//        if let polygonDetails = polygonDetails {
//            try realm.write({ () -> Void in
//                realm.add(polygonDetails, update: true)
//            })
//
//        } else {
//            try realm.write({ () -> Void in
//                realm.delete(realm.objects(PolygonDetail.self))
//                print("PolygonDetail erased")
//            })
//        }
//    }
//
//    class func writeCountry(_ disfrutaItem: DisfrutaItem?) throws {
//        let realm = try Realm()
//
//        if let disfrutaItem = disfrutaItem {
//            try realm.write({ () -> Void in
//                realm.add(disfrutaItem, update: true)
//            })
//
//        } else {
//            try realm.write({ () -> Void in
//                realm.delete(realm.objects(DisfrutaItem.self))
//                print("DisfrutaItem erased")
//            })
//        }
//    }
//}
