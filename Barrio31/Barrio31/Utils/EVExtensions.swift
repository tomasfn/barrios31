//
//  EVExtensions.swift
//  MiCountry
//
//  Created by Tomás Fernández on 15/5/17.
//  Copyright © 2017 Tomás Fernández Nuñez. All rights reserved.
//

import UIKit

enum AppInfo {
  
  static var version: String? {
    return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
  }
  
  static var build: String? {
    return Bundle.main.infoDictionary?["CFBundleVersionString"] as? String
  }
  
  static var bundleName: String? {
    return Bundle.main.infoDictionary?["CFBundleName"] as? String
  }
  
}

extension UIButton {
  
  public func titleLines(lines: Int) {
    guard lines >= 0 else { return }
    titleLabel?.numberOfLines = lines
    titleLabel?.baselineAdjustment = .alignCenters
  }
  
  public func titleUniformMargin(margin: CGFloat) {
    titleEdgeInsets = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
  }
  
}


extension UIView {
  public var x: CGFloat {
    get { return origin.x }
    set { origin = CGPoint(x: newValue, y: y) }
  }
  
  public var y: CGFloat {
    get { return origin.y }
    set { origin = CGPoint(x: x, y: newValue) }
  }
  
  public var width: CGFloat {
    get { return size.width }
    set { size = CGSize(width: newValue, height: height) }
  }
  
  public var height: CGFloat {
    get { return size.height }
    set { size = CGSize(width: width, height: newValue) }
  }
  
  public var size: CGSize {
    get { return bounds.size }
    set { frame = CGRect(origin: origin, size: newValue) }
  }
  
  public var origin: CGPoint {
    get { return frame.origin }
    set { frame = CGRect(origin: newValue, size: size) }
  }
  
  
  public func roundCorners(radius: CGFloat) {
    layer.cornerRadius = radius
    layer.masksToBounds = radius > 0
  }
    
}

extension UIScreen {
  public var width: CGFloat {
    return size.width
  }
  
  public var height: CGFloat {
    return size.height
  }
  
  public var size: CGSize {
    return bounds.size
  }
}

extension NSData {
  func stringFromDeviceToken() -> String! {
    
    var bytes = [UInt8](repeating: 0, count: self.length)
    self.getBytes(&bytes, length: bytes.count)
    var token = String()
    
    for i in 0 ..< bytes.count {
      token += String(format: "%02.2hhX", bytes[i])
    }
    
    return token
  }
}

extension Array {
  var randomElement: Element? {
    get {
      guard isEmpty == false else { return nil }
      
      let randomIndex = arc4random_uniform(UInt32(count))
      return self[Int(randomIndex)]
    }
  }
}




extension Dictionary {
  func removeNulls() -> Dictionary {
    var dict = self
    
    for key in dict.keys {
      if dict[key] is NSNull {
        dict.removeValue(forKey: key)
      }
    }
    
    return dict
  }
}

extension CGSize {
  public var aspectRatio: CGFloat {
    return width / height
  }
}




