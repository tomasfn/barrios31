//
//  ImageCache.swift
//
//  Created by Michael Adaixo on 16/07/15.
//

import UIKit

// TODO:
// - Implement LRU Algorithm ( Least-Recently-Used ) to clear unused images from memory
// - Try to make some sort of PriorityQueue out of this..
// - Be awesome. ( Check )

//class ImageCache {
//    static let sharedInstance = ImageCache()
//
//    private var _cache: [String : UIImage]!
//
//    init()  {
//        _cache = [String : UIImage]()
//    }
//
//    func find( imageUrl: String ) -> UIImage? {
//        if isCached( imageUrl: imageUrl ) {
//            let key = stringToBase64( string: imageUrl )
//            return _cache[key!]
//        }
//        return nil
//    }
//
//    func cacheImage( imageUrl: String ) {
//        if !isCached(imageUrl: imageUrl) {
//            UIImage().loadAsyncFromUrl(path: imageUrl, complete: { (resultingImage) -> Void in
//                if let image = resultingImage {
//                    self.addNewImage(imageUrl: imageUrl, image: image)
//                }
//            })
//        }
//    }
//
//    func findOrLoadAsync( imageUrl: String, completionHandler: @escaping ( _ image: UIImage? ) -> Void ) {
//        if let image = find( imageUrl: imageUrl ) {
//            completionHandler( image )
//        }
//        else
//        {
//            UIImage().loadAsyncFromUrl(path: imageUrl, complete: { (resultingImage) -> Void in
//                if let image = resultingImage {
//                    self.addNewImage(imageUrl: imageUrl, image: image)
//                    completionHandler( image )
//                }
//            })
//        }
//    }
//
//    private func addNewImage( imageUrl: String, image: UIImage ) {
//        if !isCached( imageUrl: imageUrl ) {
//            let key = stringToBase64( string: imageUrl )
//            _cache[key!] = image
//        }
//    }
//
//    private func isCached( imageUrl: String ) -> Bool {
//        if let key = stringToBase64( string: imageUrl ) {
//            if _cache[key] != nil {
//                return true
//            }
//        }
//        return false
//    }
//
//    private func stringToBase64( string: String ) -> String? {
//        let imageData = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
//        return imageData?.base64EncodedString(options: [])
//    }
//}
//
//extension UIImage {
//
//    // Will asynchronously download an image from the path(url)
//    // that you provide, and return you the UIImage on the main queue
//    func loadAsyncFromUrl( path: String, complete: @escaping (_ resultingImage: UIImage?) -> Void ) {
//        // example fetch photo
//
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        let url = NSURL(string: path)
//        var request: NSURLRequest = NSURLRequest(url: url! as URL)
//        NSURLConnection.sendAsynchronousRequest(request as URLRequest,
//                                                queue: OperationQueue.mainQueue,
//
//                                                completionHandler: {(response: URLResponse?, data: NSData?, error: NSError?) -> Void in
//
//
//                                                    UIApplication.shared.networkActivityIndicatorVisible = false
//                                                    if error != nil {
//                                                        println("[UIImage.loadAsyncFromURL] Error: \(error)")
//                                                    }
//                                                    else
//                                                    {
//                                                        var image = UIImage(data: data)
//                                                        complete(resultingImage: image)
//                                                    }
//
//
//
//    })
//
//    }
//}
