//
//  AppFonts.swift
//  MiCountry
//
//  Created by Tomás Fernández on 28/4/17.
//  Copyright © 2017 Tomás Fernández Nuñez. All rights reserved.
//

import UIKit

extension UIFont {
  
  class func chalet(fontSize: Float!) -> UIFont {
    /*for family in UIFont.familyNames {
      print("\(family)")
      
      for name in UIFont.fontNames(forFamilyName: family) {
        print("   \(name)")
      }
    }*/
    return UIFont.init(name: "Chalet-NewYorkNineteenEighty", size: CGFloat(fontSize))!
  }
    
    class func MontserratSemiBold(fontSize: Float!) -> UIFont {
        return UIFont.init(name: "Montserrat-SemiBold", size: CGFloat(fontSize))!
    }
    
    class func MontserratBold(fontSize: Float!) -> UIFont {
        return UIFont.init(name: "Montserrat-Bold", size: CGFloat(fontSize))!
    }
    
    class func MontserratRegular(fontSize: Float!) -> UIFont {
        return UIFont.init(name: "Montserrat-Regular", size: CGFloat(fontSize))!
    }
  
  class func LibreBaskervilleBold(fontSize: Float!) -> UIFont {
    return UIFont.init(name: "LibreBaskerville-Bold", size: CGFloat(fontSize))!
  }
  
  class func LibreBaskervilleItalic(fontSize: Float!) -> UIFont {
    return UIFont.init(name: "LibreBaskerville-Italic", size: CGFloat(fontSize))!
  }
  
  class func OpenSansBold(fontSize: Float!) -> UIFont {
    return UIFont.init(name: "OpenSans-Bold", size: CGFloat(fontSize))!
  }
  
  class func OpenSansBoldItalic(fontSize: Float!) -> UIFont {
    return UIFont.init(name: "OpenSans-BoldItalic", size: CGFloat(fontSize))!
  }
  
  class func OpenSansExtraBoldItalic(fontSize: Float!) -> UIFont {
    return UIFont.init(name: "OpenSans-ExtraBoldItalic", size: CGFloat(fontSize))!
  }
  
  class func OpenSansExtraBold(fontSize: Float!) -> UIFont {
    return UIFont.init(name: "OpenSans-ExtraBold", size: CGFloat(fontSize))!
  }
  
  class func OpenSansItalic(fontSize: Float!) -> UIFont {
    return UIFont.init(name: "OpenSans-Italic", size: CGFloat(fontSize))!
  }
  
  class func OpenSansLight(fontSize: Float!) -> UIFont {
    return UIFont.init(name: "OpenSans-Light", size: CGFloat(fontSize))!
  }
  
  class func OpenSansLightItalic(fontSize: Float!) -> UIFont {
    return UIFont.init(name: "OpenSans-LightItalic", size: CGFloat(fontSize))!
  }
  
  class func OpenSansRegular(fontSize: Float!) -> UIFont {
    return UIFont.init(name: "OpenSans", size: CGFloat(fontSize))!
  }
  
  class func OpenSansSemiBold(fontSize: Float!) -> UIFont {
    return UIFont.init(name: "OpenSans-Semibold", size: CGFloat(fontSize))!
  }
  
  class func OpenSansSemiboldItalic(fontSize: Float!) -> UIFont {
    return UIFont.init(name: "OpenSans-SemiboldItalic", size: CGFloat(fontSize))!
  }
  
}
