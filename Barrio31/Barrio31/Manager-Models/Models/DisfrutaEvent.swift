//
//  DisfrutaDetail.swift
//  Barrio31
//
//  Created by Tomás Fernandez Nuñez on 10/01/2019.
//  Copyright © 2019 Carlos Garcia. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

typealias DisfrutaDetailJSON = [String : AnyObject]

class DisfrutaDetail: Object {
    
    @objc dynamic var name : String?
    @objc dynamic var id: Int = -1
    @objc dynamic var shortDescription : String?
    @objc dynamic var longDescription : String?
    @objc dynamic var started : String?
    @objc dynamic var ended : String?
    @objc dynamic var price : String?
    @objc dynamic var schedule : String?
    @objc dynamic var imageLink : String?
    @objc dynamic var imageIpadLink : String?
    @objc dynamic var imageSmartphoneLink : String?
    var imagesCarousel = [String]()
    @objc dynamic var spotName : String?
    @objc dynamic var categoryName : String?
    @objc dynamic var categorySlug : String?

    //restante:
//    "imagesCarousel": [
//    "/multimedia/image/1778"
//    ],

    convenience init(JSON: [String : AnyObject]) {
        self.init()
        
        if let idOK = JSON["id"] as? Int {
            id = idOK
        }
        
        if let nameOK = JSON["name"] as? String {
            name = nameOK
        }
        
        if let shortDescriptionOK = JSON["shortDescription"] as? String {
            shortDescription = shortDescriptionOK
        }
        
        if let longDescriptionOK = JSON["longDescription"] as? String {
            longDescription = longDescriptionOK
        }
        
        if let startedOK = JSON["started"] as? String {
            started = startedOK
        }
        
        if let endedOK = JSON["ended"] as? String {
            ended = endedOK
        }
        
        if let priceOK = JSON["price"] as? String {
            price = priceOK
        }
        
        if let scheduleOK = JSON["schedule"] as? String {
            schedule = scheduleOK
        }
        
        if let imageLinkOK = JSON["imageLink"] as? String {
            let imageUrlLink = "http://barrio31-test.candoit.com.ar/api" + imageLinkOK + accessToken
            imageLink = imageUrlLink
        }
        
        if let imageIpadLinkOK = JSON["imageIpadLink"] as? String {
                let imageUrlLink = "http://barrio31-test.candoit.com.ar/api" + imageIpadLinkOK + accessToken
            imageIpadLink = imageUrlLink
        }
        
        if let imageSmartphoneLinkOK = JSON["imageSmartphoneLink"] as? String {
            let imageUrlLink = "http://barrio31-test.candoit.com.ar/api" + imageSmartphoneLinkOK + accessToken
            imageSmartphoneLink = imageUrlLink
        }
        
        if let imageCarouselOK = JSON["imagesCarousel"] as? [String] {
            for imageLink in imageCarouselOK {
                let urlLink = "http://barrio31-test.candoit.com.ar/api" + imageLink + accessToken
                imagesCarousel.append(urlLink)
            }
        }
        
        if let spotNameOK = JSON["spotName"] as? String {
            spotName = spotNameOK
        }
        
        if let categoryNameOK = JSON["categoryName"] as? String {
            categoryName = categoryNameOK
        }
        
        if let categorySlugOK = JSON["categorySlug"] as? String {
            categorySlug = categorySlugOK
        }
        
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}



extension DisfrutaDetail: StandaloneCopiable {
    
    func standaloneCopy() -> DisfrutaDetail! {
        
        let standaloneDisfrutaDetailItem = DisfrutaDetail()
        standaloneDisfrutaDetailItem.id = id
        standaloneDisfrutaDetailItem.name = name
        
        return standaloneDisfrutaDetailItem
    }
}

extension DisfrutaDetail: ArrayInstanciable {
    
    static func instancesFromJSONArray(jsonArray: [[String : AnyObject]]) -> [DisfrutaDetail]? {
        
        var DisfrutaDetailItems = [DisfrutaDetail]()
        
        for aJSON in jsonArray {
            let aDisfrutaDetailItem = DisfrutaDetail(JSON: aJSON)
            DisfrutaDetailItems.append(aDisfrutaDetailItem)
        }
        
        return DisfrutaDetailItems
    }
    
}


