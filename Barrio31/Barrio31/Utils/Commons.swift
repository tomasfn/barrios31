//
//  Commons.swift
//  MiCountry
//
//  Created by Tomás Fernández on 28/4/17.
//  Copyright © 2017 Tomás Fernández Nuñez. All rights reserved.
//

import UIKit

extension String {
  public func localized(comment: String = "") -> String {
    return NSLocalizedString(self, comment: comment)
  }
  
  func isValidEmail(str:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: str)
  }
}

extension NSObject {
  public class var nameOfClass: String {
    return String(describing: self).components(separatedBy: ".").last!
  }
}

extension UIViewController {

  static func getTopViewController() -> UIViewController {
    
    var viewController = UIViewController()
    
    if let vc =  UIApplication.shared.delegate?.window??.rootViewController {
      
      viewController = vc
      var presented = vc
      
      while let top = presented.presentedViewController {
        presented = top
        viewController = top
      }
    }
    
    return viewController
  }
}

extension UIView {
  
  class func initFromNib() -> UIView {
    let mainBundle = Bundle.main
    let className  = NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    
    if ( mainBundle.path(forResource: className, ofType: "nib") != nil ) {
      let objects = mainBundle.loadNibNamed(className, owner: self, options: [:])
      
      for object in objects! {
        if let view = object as? UIView {
          return view
        }
      }
    }
    
    return UIView(frame: CGRect.zero)
  }
  
  func addConstraintsWithFormat(_ format: String, views: UIView...) {
  var viewsDictionary = [String: UIView]()
  for (index, view) in views.enumerated() {
  let key = "v\(index)"
  viewsDictionary[key] = view
  view.translatesAutoresizingMaskIntoConstraints = false
  }
  
  addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
  }
  
  public func fillSuperview() {
    translatesAutoresizingMaskIntoConstraints = false
    if let superview = superview {
      leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
      rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
      topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
      bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    }
  }
  
  public func anchor(_ top: NSLayoutYAxisAnchor? , leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
    
    translatesAutoresizingMaskIntoConstraints = false
    
    if let top = top {
      topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
    }
    
    if let leading = leading {
      leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
    }
    
    if let bottom = bottom {
      bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
    }
    
    if let trailing = trailing {
      trailingAnchor.constraint(equalTo: trailing, constant: padding.right).isActive = true
    }
    
    
    if size.height != 0 {
      heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
    if size.width != 0 {
      widthAnchor.constraint(equalToConstant: size.width).isActive = true
    }
  }
  
  /*public func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) {
    translatesAutoresizingMaskIntoConstraints = false
    
    _ = anchorWithReturnAnchors(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant, widthConstant: widthConstant, heightConstant: heightConstant)
  }*/
  
  public func anchorWithReturnAnchors(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
    translatesAutoresizingMaskIntoConstraints = false
    
    var anchors = [NSLayoutConstraint]()
    
    if let top = top {
      anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
    }
    
    if let left = left {
      anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
    }
    
    if let bottom = bottom {
      anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
    }
    
    if let right = right {
      anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
    }
    
    if widthConstant > 0 {
      anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
    }
    
    if heightConstant > 0 {
      anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
    }
    
    anchors.forEach({$0.isActive = true})
    
    return anchors
  }
  
  public func anchorCenterXToSuperview(constant: CGFloat = 0) {
    translatesAutoresizingMaskIntoConstraints = false
    if let anchor = superview?.centerXAnchor {
      centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }
  }
  
  public func anchorCenterYToSuperview(constant: CGFloat = 0) {
    translatesAutoresizingMaskIntoConstraints = false
    if let anchor = superview?.centerYAnchor {
      centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }
  }
  
  public func anchorCenterSuperview() {
    anchorCenterXToSuperview()
    anchorCenterYToSuperview()
  }

    
}

extension CAGradientLayer {
  
  convenience init(frame: CGRect, colors: [UIColor]) {
    self.init()
    self.frame = frame
    self.colors = []
    for color in colors {
      self.colors?.append(color.cgColor)
    }
    startPoint = CGPoint(x: 0, y: 0)
    endPoint = CGPoint(x: 0, y: 1)
  }
  
  func creatGradientImage() -> UIImage? {
    
    var image: UIImage? = nil
    UIGraphicsBeginImageContext(bounds.size)
    if let context = UIGraphicsGetCurrentContext() {
      render(in: context)
      image = UIGraphicsGetImageFromCurrentImageContext()
    }
    UIGraphicsEndImageContext()
    return image
  }
  
}

extension UINavigationBar {
  
  func setGradientBackground(colors: [UIColor]) {
    
    var updatedFrame = bounds
    updatedFrame.size.height += 20
    let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
    
    setBackgroundImage(gradientLayer.creatGradientImage(), for: UIBarMetrics.default)
  }
}

extension Date{
  func yearsTo(_ date : Date) -> Int{
    return Calendar.current.dateComponents([.year], from: self, to: date).year ?? 0
  }
}

public extension DispatchQueue {
  
  private static var _onceTracker = [String]()
  
  /**
   Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
   only execute the code once even in the presence of multithreaded calls.
   
   - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
   - parameter block: Block to execute once
   */
    public class func once(token: String, block:()->Void) {
    objc_sync_enter(self); defer { objc_sync_exit(self) }
    
    if _onceTracker.contains(token) {
      return
    }
    
    _onceTracker.append(token)
        block()
  }
}

extension CGRect{
  init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
    self.init(x:x,y:y,width:width,height:height)
  }
  
}
extension CGSize{
  init(_ width:CGFloat,_ height:CGFloat) {
    self.init(width:width,height:height)
  }
}
extension CGPoint{
  init(_ x:CGFloat,_ y:CGFloat) {
    self.init(x:x,y:y)
  }
}

extension UIColor {
  
  convenience init(r: Int, g: Int, b: Int, a: Float = 1) {
    let red = CGFloat(min(abs(r), 255)) / 255
    let green = CGFloat(min(abs(g), 255)) / 255
    let blue = CGFloat(min(abs(b), 255)) / 255
    let alpha = CGFloat(min(abs(a), 1))
    
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}

extension UICollectionView {
  
  func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
    
    register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
  }
}

extension UICollectionView {
  
  func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: NSIndexPath) -> T where T: ReusableView {
    guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as? T else {
      fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
    }
    return cell
  }
}

extension UITextView {
  func setHTMLFromString(htmlText: String) {
    
    let htmlData = NSString(string: htmlText).data(using: String.Encoding.unicode.rawValue)
    
    let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
    
    let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
    self.attributedText = attributedString
  }
}

