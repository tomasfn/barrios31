//
//  PolygonDetailDetail.swift
//  Barrio31
//
//  Created by Tomás Fernandez Nuñez on 16/11/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import Foundation
import RealmSwift

typealias PolygonDetailsJSON = [String : AnyObject]

class PolygonDetail: Object {

    @objc dynamic var id: Int = -1
    @objc dynamic var name : String?
    @objc dynamic var amount: Int = -1
    @objc dynamic var amountStr : String?
    @objc dynamic var categoryName : String?
    @objc dynamic var categorySlug : String?
    @objc dynamic var neighbors : String?
    @objc dynamic var m2 : String?
    @objc dynamic var state : String?
    @objc dynamic var drone : Drone?
    @objc dynamic var street : Street?
    @objc dynamic var videoUrl : String?
    @objc dynamic var shortDescription : String?
    @objc dynamic var m2Text : String?
    @objc dynamic var neighborsText : String?
    @objc dynamic var color : String?
    @objc dynamic var started : String?
    @objc dynamic var ended : String?

    convenience init(JSON: [String : AnyObject]) {
        self.init()

        if let idOK = JSON["id"] as? Int {
            id = idOK
        }

        if let nameOK = JSON["name"] as? String {
            name = nameOK
        }
        
        if let amountOK = JSON["amount"] as? Int {
            amount = amountOK
        }

        if let amountStrOK = JSON["amountFormat"] as? String {
            amountStr = amountStrOK
        }

        if let droneArray = JSON["drone"] as? DroneJSON {
            drone = Drone(JSON: droneArray)
        }

        if let streetArray = JSON["street"] as? StreetJSON {
            street = Street(JSON: streetArray)
        }

        if let categoryNameOK = JSON["categoryName"] as? String {
            categoryName = categoryNameOK
        }

        if let categorySlugOK = JSON["categorySlug"] as? String {
            categorySlug = categorySlugOK
        }

        if let startedOK = JSON["started"] as? String {
            started = startedOK
        }

        if let endedOK = JSON["ended"] as? String {
            ended = endedOK
        }

        if let neighborsOK = JSON["neighbors"] as? String {
            neighbors = neighborsOK
        }

        if let m2OK = JSON["m2"] as? String {
            m2 = m2OK
        }

        if let stateOK = JSON["state"] as? String {
            state = stateOK
        }

        if let videoUrlOK = JSON["videoDownloadUrl"] as? String {
            videoUrl = "http://barrio31-test.candoit.com.ar/api" + videoUrlOK + accessToken
        }

        if let shortDescriptionOK = JSON["shortDescription"] as? String {
            shortDescription = shortDescriptionOK
        }

        if let m2TextOK = JSON["m2Text"] as? String {
            m2Text = m2TextOK
        }

        if let neighborsTextOK = JSON["neighborsText"] as? String {
            neighborsText = neighborsTextOK
        }
        
        print(JSON)

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



extension PolygonDetail: StandaloneCopiable {

    func standaloneCopy() -> PolygonDetail! {

        let standalonePolygonDetail = PolygonDetail()
        standalonePolygonDetail.id = id
        standalonePolygonDetail.name = name
        standalonePolygonDetail.amount = amount
        standalonePolygonDetail.categoryName = categoryName
        standalonePolygonDetail.neighbors = neighbors
        standalonePolygonDetail.m2 = m2
        standalonePolygonDetail.state = state

        standalonePolygonDetail.videoUrl = videoUrl
        standalonePolygonDetail.shortDescription = shortDescription
        standalonePolygonDetail.m2Text = m2Text
        standalonePolygonDetail.neighborsText = neighborsText
        standalonePolygonDetail.color = color
        standalonePolygonDetail.started = started
        standalonePolygonDetail.ended = ended

        return standalonePolygonDetail
    }
}

extension PolygonDetail: ArrayInstanciable {

    static func instancesFromJSONArray(jsonArray: [[String : AnyObject]]) -> [PolygonDetail]? {

        var PolygonDetails = [PolygonDetail]()

        for aJSON in jsonArray {
            let aPolygonDetail = PolygonDetail(JSON: aJSON)
            PolygonDetails.append(aPolygonDetail)
        }

        return PolygonDetails
    }

}




