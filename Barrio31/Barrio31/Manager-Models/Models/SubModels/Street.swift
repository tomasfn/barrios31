//
//  Street.swift
//  Barrio31
//
//  Created by Tomás Fernandez Nuñez on 16/11/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import Foundation
import RealmSwift

typealias StreetJSON = [String : AnyObject]

class Street: Object {
    
    @objc dynamic var beforeLink: String?
    @objc dynamic var afterLink: String?

    convenience init(JSON: [String : AnyObject]) {
        self.init()
        
        var beforeEndpoint = ""
        var afterEndpoint = ""
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            
            if let endPointAfter = JSON["ipadAfterLink"]  {
                afterEndpoint = endPointAfter as! String
            }
            
            if let endPointBefore = JSON["ipadBeforeLink"]  {
                beforeEndpoint = endPointBefore as! String
            }
            
        } else if UI_USER_INTERFACE_IDIOM() == .phone {
            
            if let endPointAfter = JSON["afterLink"]  {
                afterEndpoint = endPointAfter as! String
            }
            
            if let endPointBefore = JSON["beforeLink"]  {
                beforeEndpoint = endPointBefore as! String
            }
        }
        
        beforeLink = "http://barrio31.candoit.com.ar" + beforeEndpoint
        afterLink = "http://barrio31.candoit.com.ar" + afterEndpoint
        
    }
}


extension Street: StandaloneCopiable {
    
    func standaloneCopy() -> Street! {
        
        let standaloneStreet = Street()
        standaloneStreet.beforeLink = beforeLink
        standaloneStreet.afterLink = afterLink
        
        return standaloneStreet
    }
}

extension Street: ArrayInstanciable {
    
    static func instancesFromJSONArray(jsonArray: [[String : AnyObject]]) -> [Street]? {
        
        var street = [Street]()
        
        for aJSON in jsonArray {
            let anStreet = Street(JSON: aJSON)
            street.append(anStreet)
        }
        
        return street
    }
    
}
