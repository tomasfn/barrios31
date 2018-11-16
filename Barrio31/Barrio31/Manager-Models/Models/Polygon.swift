//
//  Polygon.swift
//  Barrio31
//
//  Created by Tomás Fernandez Nuñez on 16/11/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

typealias PolygonsJSON = [String : AnyObject]

class Polygon: Object {
    
    @objc dynamic var type : String?
    @objc dynamic var color : String?
    @objc dynamic var category : String?
    @objc dynamic var id: Int = -1
    var coordinates = [CLLocationCoordinate2D]()
    
    convenience init(JSON: [String : AnyObject]) {
        self.init()
        
        if let typeOK = JSON["type"] as? String {
            type = typeOK
        }
        
        if let properties = JSON["properties"] as? Dictionary<String, AnyObject> {
            if let colorOK = properties["color"] as? String {
                color = colorOK
            }
            if let categoryOK = properties["category"] as? String {
                category = categoryOK
            }
            if let idOK = properties["id"] as? Int {
                id = idOK
            }
        }
        
        if let geometry = JSON["geometry"] as? Dictionary<String, AnyObject> {
            if let array = geometry["coordinates"] as? Array<AnyObject> {
                for innerArray in array {
                    if let coordsArray = innerArray as? Array<AnyObject> {
                        for innerArray in coordsArray {
                            if let latLon = innerArray as? Array<AnyObject> {
                                //print(latLon)
                                let coordinate = CLLocationCoordinate2DMake(latLon[1] as! CLLocationDegrees, latLon[0] as! CLLocationDegrees)
                                coordinates.append(coordinate)
                            }
                        }
                    }
                }
            }
        }
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }    
}



extension Polygon: StandaloneCopiable {
    
    func standaloneCopy() -> Polygon! {
        
        let standalonePolygon = Polygon()
        standalonePolygon.type = type
        standalonePolygon.color = color
        standalonePolygon.category = category
        standalonePolygon.id = id
        standalonePolygon.coordinates = coordinates
        
        return standalonePolygon
    }
}

extension Polygon: ArrayInstanciable {
    
    static func instancesFromJSONArray(jsonArray: [[String : AnyObject]]) -> [Polygon]? {
        
        var Polygons = [Polygon]()
        
        for aJSON in jsonArray {
            let aPolygon = Polygon(JSON: aJSON)
            Polygons.append(aPolygon)
        }
        
        return Polygons
    }
    
}
