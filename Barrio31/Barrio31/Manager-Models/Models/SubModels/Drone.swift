//
//  Drone.swift
//  Barrio31
//
//  Created by Tomás Fernandez Nuñez on 16/11/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//


import Foundation
import RealmSwift

typealias DroneJSON = [String : AnyObject]

class Drone: Object {
    
    @objc dynamic var beforeLink: String = ""
    @objc dynamic var ipadAfterLink: String = ""
    @objc dynamic var ipadBeforeLink: String = ""
    @objc dynamic var afterLink: String = ""
    
    convenience init(JSON: [String : AnyObject]) {
        self.init()
        
        beforeLink = JSON["beforeLink"] as! String
        ipadAfterLink = JSON["ipadAfterLink"] as! String
        ipadBeforeLink = JSON["ipadBeforeLink"] as! String
        afterLink = JSON["afterLink"] as! String
        
    }
}


extension Drone: StandaloneCopiable {
    
    func standaloneCopy() -> Drone! {
        
        let standaloneDrone = Drone()
        standaloneDrone.beforeLink = beforeLink
        standaloneDrone.ipadAfterLink = ipadAfterLink
        standaloneDrone.ipadBeforeLink = ipadBeforeLink
        standaloneDrone.afterLink = afterLink
        
        return standaloneDrone
    }
}

extension Drone: ArrayInstanciable {
    
    static func instancesFromJSONArray(jsonArray: [[String : AnyObject]]) -> [Drone]? {
        
        var drone = [Drone]()
        
        for aJSON in jsonArray {
            let anDrone = Drone(JSON: aJSON)
            drone.append(anDrone)
        }
        
        return drone
    }
    
}
