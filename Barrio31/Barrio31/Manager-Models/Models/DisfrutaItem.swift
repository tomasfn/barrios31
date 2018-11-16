//
//  DisfrutaItem.swift
//  Barrio31
//
//  Created by Tomás Fernandez Nuñez on 16/11/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

typealias DisfrutaItemsJSON = [String : AnyObject]

class DisfrutaItem: Object {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var color : String?
    @objc dynamic var category : String?
    var coordinate :CLLocationCoordinate2D?
    
    convenience init(JSON: [String : AnyObject]) {
        self.init()
        
        if let properties = JSON["properties"] as? Dictionary<String, AnyObject> {
            if let idOK = properties["id"] as? Int {
                id = idOK
            }
            if let categoryNameOK = properties["category"] as? String {
                category = categoryNameOK
            }
            if let colorOK = properties["color"] as? String {
                color = colorOK
            }
        }
        
        if let geometry = JSON["geometry"] as? Dictionary<String, AnyObject> {
            if let array = geometry["coordinates"] as? Array<AnyObject> {
                coordinate = CLLocationCoordinate2DMake(array[1] as! CLLocationDegrees, array[0] as! CLLocationDegrees)
            }
        }
        
    }
    
    func getColor() -> UIColor {
        if let col = color {
            return UIColor.hexStringToUIColor(hex: col)
            
        }
        return UIColor.black
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}



extension DisfrutaItem: StandaloneCopiable {
    
    func standaloneCopy() -> DisfrutaItem! {
        
        let standaloneDisfrutaItem = DisfrutaItem()
        standaloneDisfrutaItem.id = id
        standaloneDisfrutaItem.category = category
        standaloneDisfrutaItem.color = color
        standaloneDisfrutaItem.coordinate = coordinate
        
        return standaloneDisfrutaItem
    }
}

extension DisfrutaItem: ArrayInstanciable {
    
    static func instancesFromJSONArray(jsonArray: [[String : AnyObject]]) -> [DisfrutaItem]? {
        
        var DisfrutaItems = [DisfrutaItem]()
        
        for aJSON in jsonArray {
            let aDisfrutaItem = DisfrutaItem(JSON: aJSON)
            DisfrutaItems.append(aDisfrutaItem)
        }
        
        return DisfrutaItems
    }
    
}
