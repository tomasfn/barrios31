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


extension Street: StandaloneCopiable {
    
    func standaloneCopy() -> Street! {
        
        let standaloneStreet = Street()
        standaloneStreet.beforeLink = beforeLink
        standaloneStreet.ipadAfterLink = ipadAfterLink
        standaloneStreet.ipadBeforeLink = ipadBeforeLink
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
