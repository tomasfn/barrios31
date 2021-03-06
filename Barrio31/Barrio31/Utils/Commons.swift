//
//  Commons.swift
//  MiCountry
//
//  Created by Tomás Fernández on 28/4/17.
//  Copyright © 2017 Tomás Fernández Nuñez. All rights reserved.
//

import UIKit
import SVProgressHUD
import AVFoundation

extension String {
  
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
    
    func animShow(){
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
        self.alpha = 1
    }
    func animHide(){
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
            self.alpha = 0
        })
    }
    
  
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
  
  public func roundCorners(_ radius: CGFloat) {
    layer.cornerRadius = radius
    layer.masksToBounds = radius > 0
  }
    
    public func roundView(updateLayout layoutIfNeeded: Bool = true) {
        if layoutIfNeeded { self.layoutIfNeeded() }
        roundCorners(radius: min(width, height)/2)
    }
  
  func setCellShadow() {
    self.layer.shadowColor = UIColor.darkGray.cgColor
    self.layer.shadowOffset = CGSize(width: 0, height: 1)
    self.layer.shadowOpacity = 1
    self.layer.shadowRadius = 1.0
    self.layer.masksToBounds = true
    self.clipsToBounds = true
    self.layer.cornerRadius = 10
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


extension String {
  public func localized(_ comment: String = "") -> String {
    return NSLocalizedString(self, comment: comment)
  }
  
  var words: [String] {
    get { return components(separatedBy: " ") }
  }
}

extension UIColor {
  class func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
      cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
      return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
  
  public class func color(_ r: Int, g: Int, b: Int, a: Float! = 1) -> UIColor! {
    let red = min(abs(r), 255), green = min(abs(g), 255), blue = min(abs(b), 255), alpha = min(abs(a), 1)
    return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: CGFloat(alpha))
  }
}

extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
  public class func imageWithColor(_ red: Float!, green: Float!, blue: Float!, alpha: Float!) -> UIImage! {
    let color = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    return self.imageWithColor(color)
  }
  
  public class func imageWithColor(_ color: UIColor!) -> UIImage! {
    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0);
    UIGraphicsBeginImageContext(rect.size);
    let context = UIGraphicsGetCurrentContext();
    
    context!.setFillColor(color.cgColor);
    context!.fill(rect);
    
    let image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
  }
  
  func colored(_ color : UIColor) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    let context = UIGraphicsGetCurrentContext()
    context!.setBlendMode(.multiply)
    context!.translateBy(x: 0, y: self.size.height)
    context!.scaleBy(x: 1.0, y: -1.0)
    context!.draw(self.cgImage!, in: rect)
    context!.clip(to: rect, mask: self.cgImage!)
    context!.setFillColor(color.cgColor)
    context!.fill(rect)
    let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return coloredImage!
  }
}

extension UIButton {
  
  public func titleLines(_ lines: Int) {
    guard lines >= 0 else { return }
    titleLabel?.numberOfLines = lines
    titleLabel?.baselineAdjustment = .alignCenters
  }
  
  public func titleUniformMargin(_ margin: CGFloat) {
    titleEdgeInsets = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
  }
  
}

extension Data {
  func stringFromDeviceToken() -> String! {
    
    var bytes = [UInt8](repeating: 0, count: self.count)
    (self as NSData).getBytes(&bytes, length: bytes.count)
    var token = String()
    
    for i in 0 ..< bytes.count {
      token += String(format: "%02.2hhX", bytes[i])
    }
    
    return token
  }
}

extension Array where Element : Equatable {
  mutating func removeObject(_ object : Iterator.Element, onlyFirst: Bool = false) {
    if let index = index(of: object) {
      remove(at: index)
    } else {
      return
    }
    
    if onlyFirst == false {
      removeObject(object, onlyFirst: false)
    }
    
  }
}

extension Bool {
  static func randomValue() -> Bool {
    return arc4random_uniform(2) == 0 ? false : true
  }
}

extension UIViewController {
  var isFirstInStack : Bool {
    get { return navigationController?.viewControllers.index(of: self) == 0 }
  }
  
  var isModallyPresented : Bool {
    get { return presentingViewController != nil }
  }
  
  func backViewController() {
    navigationController?.popViewController(animated: true)
  }
  
  func backToRootViewController() {
    navigationController?.popToRootViewController(animated: true)
  }
  
  func dismissViewController() {
    navigationController?.dismiss(animated: true, completion: nil)
  }
}

extension UIApplication {
  class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController {
      return topViewController(nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
      if let selected = tab.selectedViewController {
        return topViewController(selected)
      }
    }
    if let presented = base?.presentedViewController {
      return topViewController(presented)
    }
    return base
  }
}

extension TimeInterval {
  
  typealias HoursMinutesSeconds = (hours: Double, minutes: Double, seconds: Double)
  
  static func hoursMinutesSeconds(_ timeInterval: TimeInterval) -> HoursMinutesSeconds {
    return timeInterval.hoursMinutesSeconds()
  }
  
  func hoursMinutesSeconds() -> HoursMinutesSeconds {
    let (hr,  minf) = modf(self / 3600)
    let (min, secf) = modf(60 * minf)
    let (sec, _ /*milif*/) = modf(60 * secf)
    return (hr, min, sec)
  }
  
}

extension UIApplication {
  
  enum AppLinkOpenService {
    case browser, iTunes, appStore
    
    var prefix: String {
      switch self {
      case .browser: return "http://"
      case .iTunes: return "itms://"
      case .appStore: return "itms-apps://"
      }
    }
  }
  
  func openAppLink(_ appName: String, appId: String, service: AppLinkOpenService = .appStore) -> Bool {
    
    let stringUrl = service.prefix + "itunes.apple.com/app/" + appName + "/id" + appId + "?mt=8"
    if let url = URL(string: stringUrl), canOpenURL(url) == true {
      return canOpenURL(url)
    }
    
    return false
    
  }
  
}



public extension DispatchQueue {
  
  private static var onceTokens = [Int]()
  private static var internalQueue = DispatchQueue(label: "dispatchqueue.once")
  
  public class func once(token: Int, closure: ()->Void) {
    internalQueue.sync {
      if onceTokens.contains(token) {
        return
      }else{
        onceTokens.append(token)
      }
      closure()
    }
  }
}


extension NSMutableAttributedString {
  
  public func setAsLink(textToFind:String, linkURL:String) -> Bool {
    
    let foundRange = self.mutableString.range(of: textToFind)
    if foundRange.location != NSNotFound {
      self.addAttribute(NSAttributedStringKey.link, value: linkURL, range: foundRange)
      return true
    }
    return false
  }
}

extension String {
  
  var encodeEmoji: String{
    if let encodeStr = NSString(cString: self.cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue){
      return encodeStr as String
    }
    return self
  }
  
  var decodeEmoji: String{
    let data = self.data(using: String.Encoding.utf8);
    let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
    if let str = decodedStr{
      return str as String
    }
    return self
  }
}

extension URL {
  
  static var cachesDirectory: URL {
    return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
  }
  
  static var documentsDirectory: URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  }
  
}

extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension UILabel {
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    public var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        guard let text = self.text else { return super.intrinsicContentSize }
        
        var contentSize = super.intrinsicContentSize
        var textWidth: CGFloat = frame.size.width
        var insetsHeight: CGFloat = 0.0
        
        if let insets = padding {
            textWidth -= insets.left + insets.right
            insetsHeight += insets.top + insets.bottom
        }
        
        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                        attributes: [NSAttributedStringKey.font: self.font], context: nil)
        
        contentSize.height = ceil(newSize.size.height) + insetsHeight
        
        return contentSize
    }
}

extension UIImageView {
    /// Loads image from web asynchronosly and caches it, in case you have to load url
    /// again, it will be loaded from cache if available
    func load(url: URL, placeholder: UIImage?, cache: URLCache? = nil) {
        let cache = cache ?? URLCache.shared
        let request = URLRequest(url: url)
        
        SVProgressHUD.show()

        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            self.image = image
            SVProgressHUD.dismiss()

        } else {
            self.image = placeholder
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    
                    DispatchQueue.main.async {
                        self.image = image
                        SVProgressHUD.dismiss()
                    }
                }
            }).resume()
        }
    }
}

extension UIScrollView {
    
    func resizeScrollViewContentSize() {
        
        var contentRect = CGRect.zero
        for view in self.subviews {
            contentRect = contentRect.union(view.frame)
        }
        
        self.contentSize = contentRect.size
    }
}

extension UILabel {
    func resizeToText() {
        self.numberOfLines = 0
        self.sizeToFit()
    }
    
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

extension UIPanGestureRecognizer {
    
    enum GestureDirection {
        case Up
        case Down
        case Left
        case Right
    }
    
    /// Get current vertical direction
    ///
    /// - Parameter target: view target
    /// - Returns: current direction
    func verticalDirection(target: UIView) -> GestureDirection {
        return self.velocity(in: target).y > 0 ? .Down : .Up
    }
    
    /// Get current horizontal direction
    ///
    /// - Parameter target: view target
    /// - Returns: current direction
    func horizontalDirection(target: UIView) -> GestureDirection {
        return self.velocity(in: target).x > 0 ? .Right : .Left
    }
    
    /// Get a tuple for current horizontal/vertical direction
    ///
    /// - Parameter target: view target
    /// - Returns: current direction
    func versus(target: UIView) -> (horizontal: GestureDirection, vertical: GestureDirection) {
        return (self.horizontalDirection(target: target), self.verticalDirection(target: target))
    }
    
}

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UIScrollView {
    
    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }
    
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    
    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
    
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}





