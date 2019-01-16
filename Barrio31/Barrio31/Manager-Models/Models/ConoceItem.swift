//
//  ConoceItem.swift
//  Barrio31
//
//  Created by Tomás Fernandez Nuñez on 29/11/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import Foundation
import RealmSwift

typealias ConoceItemsJSON = [String : AnyObject]

class ConoceItem: Object {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var order: Int = -1
    @objc dynamic var name : String?
    @objc dynamic var imgLink : String?
    
    convenience init(JSON: [String : AnyObject]) {
        self.init()
        
        if let idOK = JSON["id"] as? Int {
            id = idOK
        }
        
        if let orderOK = JSON["order"] as? Int {
            order = orderOK
        }
        
        if let nameOK = JSON["name"] as? String {
            name = nameOK
        }
        
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            
            var imageLink = ""
            if let imgLink = JSON["imgIpadLink"]  {
                imageLink = imgLink as! String
            }
            
            imgLink = "http://barrio31-test.candoit.com.ar/api" + imageLink + accessToken
            
        } else if UI_USER_INTERFACE_IDIOM() == .phone {
            
            var imageLink = ""
            if let imgLink = JSON["imgLink"]  {
                imageLink = imgLink as! String
            }
            
            imgLink = "http://barrio31-test.candoit.com.ar/api" + imageLink + accessToken
        }
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}



extension ConoceItem: StandaloneCopiable {
    
    func standaloneCopy() -> ConoceItem! {
        
        let standaloneConoceItem = ConoceItem()
        standaloneConoceItem.id = id
        standaloneConoceItem.order = order
        standaloneConoceItem.name = name
        standaloneConoceItem.imgLink = imgLink
        
        return standaloneConoceItem
    }
}

extension ConoceItem: ArrayInstanciable {
    
    static func instancesFromJSONArray(jsonArray: [[String : AnyObject]]) -> [ConoceItem]? {
        
        var ConoceItems = [ConoceItem]()
        
        for aJSON in jsonArray {
            let aConoceItem = ConoceItem(JSON: aJSON)
            ConoceItems.append(aConoceItem)
        }
        
        return ConoceItems
    }
    
}
