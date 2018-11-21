//
//  CategoryHelper.swift
//  Barrio31
//
//  Created by Tomás Fernandez Nuñez on 20/11/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import UIKit

class CategoryHelper {
    
    class func setImagePatternForCategory(categorySlug: String) -> UIImage {
        
        switch categorySlug {
        case "espacio-publico":
            return UIImage.patternPublicSpace()
        case "equip-social":
            return UIImage.patternSocialEquip()
        case "infraestructura":
            return UIImage.patternInfrastructure()
        case "empate":
            return UIImage.iconMundoOff().imageWithColor(color1: .lightGray)
        case "salud":
            return UIImage.patternHealth()
        case "educacion":
            return UIImage.patternEducation()
        case "trabajo":
            return UIImage.patternJob()
        case "habitat":
            return UIImage.patternHabitat()
        case "parque-en-altura":
            return UIImage.patternHighPark()
        default:
            return UIImage.iconInfo()
        }
    }
    
}
