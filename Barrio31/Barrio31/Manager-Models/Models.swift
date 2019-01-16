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
import RealmSwift

struct Category : Decodable {
  var name : String?
  var id : Int?
  var hexaColor : String?
  var onlyImages : Bool?
  var slug : String?
    
  func getColor() -> UIColor {
    return UIColor.hexStringToUIColor(hex: hexaColor!)
  }
  
  func getImageOff() -> UIImage! {
    switch slug {
    case "espacio-publico"?:
      return UIImage.espacioPublicoOff()
    case "equip-social"?:
      return UIImage.iconSocialOff()
    case "infraestructura"?:
      return UIImage.iconInfraOff()
    case "empate"?:
      return UIImage.iconMundoOff()
    case "salud"?:
      return UIImage.iconSaludOff()
    case "educacion"?:
      return UIImage.iconEducationOff()
    case "trabajo"?:
      return UIImage.iconJobOff()
    case "habitat"?:
      return UIImage.iconHabitatOff()
    case "parque-en-altura"?:
      return UIImage.iconParkOff()
    case "se-espacio-publico"?:
        return UIImage.espacioPublicoOff()
    case "se-equip-social"?:
        return UIImage.iconSocialOff()
    case "se-infraestructura"?:
        return UIImage.iconInfraOff()
    case "se-empate"?:
        return UIImage.iconMundoOff()
    case "se-salud"?:
        return UIImage.iconSaludOff()
    case "se-educacion"?:
        return UIImage.iconEducationOff()
    case "se-trabajo"?:
        return UIImage.iconJobOff()
    case "se-habitat"?:
        return UIImage.iconHabitatOff()
    case "se-parque-en-altura"?:
        return UIImage.iconParkOff()
    default:
        return UIImage.iconInfo()
    }
  }
  
  func getImageOn() -> UIImage! {
    switch slug {
    case "espacio-publico"?:
      return UIImage.espacioPublicoOn()
    case "equip-social"?:
      return UIImage.iconSocialOn()
    case "infraestructura"?:
      return UIImage.iconInfraOn()
    case "empate"?:
      return UIImage.iconMundoOn()
    case "salud"?:
    return UIImage.iconSaludOn()
    case "educacion"?:
        return UIImage.iconEducationOn()
    case "trabajo"?:
        return UIImage.iconJobOn()
    case "habitat"?:
        return UIImage.iconHabitatOn()
    case "parque-en-altura"?:
        return UIImage.iconParkOn()
    case "se-espacio-publico"?:
        return UIImage.espacioPublicoOn()
    case "se-equip-social"?:
        return UIImage.iconSocialOn()
    case "se-infraestructura"?:
        return UIImage.iconInfraOn()
    case "se-empate"?:
        return UIImage.iconMundoOn()
    case "se-salud"?:
        return UIImage.iconSaludOn()
    case "se-educacion"?:
        return UIImage.iconEducationOn()
    case "se-trabajo"?:
        return UIImage.iconJobOn()
    case "se-habitat"?:
        return UIImage.iconHabitatOn()
    case "se-parque-en-altura"?:
        return UIImage.iconParkOn()
    default:
      return UIImage.iconInfo()
    }
  }
}

