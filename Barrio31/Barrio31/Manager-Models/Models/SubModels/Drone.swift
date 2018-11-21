//
//  Drone.swift
//  Barrio31
//
//  Created by Tomás Fernandez Nuñez on 16/11/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//


import Foundation
import RealmSwift
import AlamofireImage

typealias DroneJSON = [String : AnyObject]

class Drone: Object {
    
    @objc dynamic var beforeLink: String = ""
    @objc dynamic var afterLink: String = ""
    
    convenience init(JSON: [String : AnyObject]) {
        self.init()
        
        var beforeEndpoint = ""
        var afterEndpoint = ""
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            
            afterEndpoint = JSON["ipadAfterLink"] as! String
            beforeEndpoint = JSON["ipadBeforeLink"] as! String
            
        } else if UI_USER_INTERFACE_IDIOM() == .phone {
            
            afterEndpoint = JSON["afterLink"] as! String
            beforeEndpoint = JSON["beforeLink"] as! String
        }
        
        beforeLink = "http://barrio31.candoit.com.ar" + beforeEndpoint
        afterLink = "http://barrio31.candoit.com.ar" + afterEndpoint
        
    }
}


extension Drone: StandaloneCopiable {
    
    func standaloneCopy() -> Drone! {
        
        let standaloneDrone = Drone()
        standaloneDrone.beforeLink = beforeLink
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
