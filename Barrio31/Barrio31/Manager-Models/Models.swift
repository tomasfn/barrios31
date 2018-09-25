//
//  Models.swift
//  Barrio31
//
//  Created by air on 29/08/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct Category : Decodable {
  var name : String?
  var id : Int?
  var hexaColor : String?
  var onlyImages : Bool?
  var slug : String?

  func getColor() -> UIColor {
    switch hexaColor {
    case "blue":
      return UIColor.hexStringToUIColor(hex: "006fb6")
    case "red":
      return UIColor.hexStringToUIColor(hex: "d316a")
    case "yellow":
      return UIColor.hexStringToUIColor(hex: "f9a61d")
    case "green":
      return UIColor.hexStringToUIColor(hex: "3d7d36")
    /*case "blue":
      return UIColor.hexStringToUIColor(hex: "006fb6")*/
    default:
      return UIColor.white
    }
  }
  
  func getImageOff() -> UIImage! {
    switch slug {
    case "espacio-publico":
      return #imageLiteral(resourceName: "ic-espacio-publico-off")
    case "equip-social":
      return #imageLiteral(resourceName: "ic-equipamiento-soc-off")
    case "infraestructura":
      return UIImage.iconInfraOff()
    case "empate":
      return UIImage.iconMundoOff()
    default:
      return #imageLiteral(resourceName: "ic-info")
    }
  }
  
  func getImageOn() -> UIImage! {
    switch slug {
    case "espacio-publico":
      return #imageLiteral(resourceName: "ic-espacio-publico")
    case "equip-social":
      return #imageLiteral(resourceName: "ic-equipamiento-soc")
    case "infraestructura":
      return UIImage.iconInfraOn()
    case "empate":
      return UIImage.iconMundoOn()
    default:
      return #imageLiteral(resourceName: "ic-info")
    }
  }
}

struct Polygon  {
  var type : String?
  var color : String?
  var category : String?
  var id : Int?
  var coordinates = [CLLocationCoordinate2D]()

  init(JSON: [String : AnyObject]) {
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
  
}

struct PolygonDetail : Decodable {
  var id : Int?
  var name : String?
  var amount : Int?
  var categoryName : String?
  var categorySlug : String?
  var neighbors : Int?
  var m2 : Int?
  var state : String?
  //var drone : Dictionary<String : String>?
  //var street : Dictionary<String : String>?
  var videoUrl : String?
  var shortDescription : String?
  var m2Text : String?
  var neighborsText : String?



}
