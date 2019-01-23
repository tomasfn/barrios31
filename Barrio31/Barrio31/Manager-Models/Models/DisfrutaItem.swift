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
    @objc dynamic var name : String?
    @objc dynamic var type : String?
    @objc dynamic var address : String?
    var coordinate :CLLocationCoordinate2D?
    var details = [DisfrutaDetail]()
    
    convenience init(JSON: [String : AnyObject]) {
        self.init()
        
        if let properties = JSON["properties"] as? Dictionary<String, AnyObject> {
            if let idOK = properties["id"] as? Int {
                id = idOK
            }
            if let nameOk = properties["name"] as? String {
                name = nameOk
            }
            if let addressOk = properties["address"] as? String {
                address = addressOk
            }
            if let typeOk = properties["type"] as? String {
                type = typeOk
            }
            
            if let colorOK = properties["color"] as? String {
                color = colorOK
            }
            
            if let eventsArray = properties["events"] as? Array<AnyObject>  {
                for event in eventsArray {
                    let detail = DisfrutaDetail(JSON: event as! [String : AnyObject])
                    details.append(detail)
                }
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
        standaloneDisfrutaItem.type = type
        standaloneDisfrutaItem.name = name
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
