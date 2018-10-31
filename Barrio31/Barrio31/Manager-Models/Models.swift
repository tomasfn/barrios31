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
    /*switch hexaColor {
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
     return UIColor.brown
     }*/
    return UIColor.hexStringToUIColor(hex: hexaColor!)
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
    case "salud":
      return #imageLiteral(resourceName: "ic-salud-inactivo")
    case "educacion":
      return #imageLiteral(resourceName: "ic-educacion-inactivo")
    case "trabajo":
      return #imageLiteral(resourceName: "ic-trabajo-inactivo")
    case "habitat":
      return #imageLiteral(resourceName: "ic-habitat-inactivo")
    case "parque-en-altura":
      return #imageLiteral(resourceName: "ic-alto-parque-inactivo")
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
    case "salud":
      return #imageLiteral(resourceName: "ic-salud-inactivo")
    case "educacion":
      return #imageLiteral(resourceName: "ic-educacion-inactivo")
    case "trabajo":
      return #imageLiteral(resourceName: "ic-trabajo-inactivo")
    case "habitat":
      return #imageLiteral(resourceName: "ic-habitat-inactivo")
    case "parque-en-altura":
      return #imageLiteral(resourceName: "ic-alto-parque-inactivo")
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

struct PolygonDetail {
  var id : Int?
  var name : String?
  var amount : Int?
  var categoryName : String?
  var categorySlug : String?
  var neighbors : String?
  var m2 : String?
  var state : String?
  var drone : [String : String]?
  var street : [String : String]?
  var videoUrl : String?
  var shortDescription : String?
  var m2Text : String?
  var neighborsText : String?
  var color : String?
  
  func getColor() -> UIColor {
    if let col = color {
      return UIColor.hexStringToUIColor(hex: col)
      
    }
    return UIColor.black
  }
  
  
  init(JSON: [String : AnyObject]) {
    
    if let idOK = JSON["id"] as? Int {
      id = idOK
    }
    
    if let nameOK = JSON["name"] as? String {
      name = nameOK
    }
    
    if let amountOK = JSON["amount"] as? Int {
      amount = amountOK
    }
    
    if let droneOK = JSON["drone"] as? [String : String] {
      drone = droneOK
    }
    
    if let streetOK = JSON["street"] as? [String : String] {
      street = streetOK
    }
    
    if let categoryNameOK = JSON["categoryName"] as? String {
      categoryName = categoryNameOK
    }
    
    if let categorySlugOK = JSON["categorySlug"] as? String {
      categorySlug = categorySlugOK
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
    
    if let videoUrlOK = JSON["videoUrl"] as? String {
      videoUrl = videoUrlOK
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
    
  }
  
}

struct DisfrutaItem {
  var id : Int?
  var color : String?
  var category : String?
  var coordinate :CLLocationCoordinate2D?
  
  func getColor() -> UIColor {
    if let col = color {
      return UIColor.hexStringToUIColor(hex: col)
      
    }
    return UIColor.black
  }
  
  init(JSON: [String : AnyObject]) {
    
    if let properties = JSON["properties"] as? Dictionary<String, AnyObject> {
      if let idOK = properties["id"] as? Int {
        id = idOK
      }
      if let categoryNameOK = properties["category"] as? String {
        category = categoryNameOK
      }
      if let colorOK = properties["color"] as? String {
        color = colorOK
      }
    }
    
    if let geometry = JSON["geometry"] as? Dictionary<String, AnyObject> {
      if let array = geometry["coordinates"] as? Array<AnyObject> {
        coordinate = CLLocationCoordinate2DMake(array[1] as! CLLocationDegrees, array[0] as! CLLocationDegrees)
      }
    }
    
  }
}

struct DisfrutaDetail : Decodable {
  var name : String?
  var id : Int?
  var shortDescription : String?
  var longDescription : String?
  var started : String?
  var ended : String?
  var price : String?
  var scheduled : String?
  var imageLink : String?
  var imageIpadLink : String?
  var imageSmartphoneLink : String?
  var imagesCarousel : [String]?
}
