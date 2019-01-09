//
//  APIManager.swift
//  Barrio31
//
//  Created by air on 28/08/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import Foundation
import Alamofire

typealias CategorysCompletionBlock = ([Category]?, Error?) -> Void
typealias ConoceItemsCompletionBlock = ([ConoceItem]?, Error?) -> Void
typealias PolygonsCompletionBlock = ([Polygon]?, Error?) -> Void
typealias PolygonsDetailCompletionBlock = (PolygonDetail?, Error?) -> Void
typealias DisfrutaCompletionBlock = ([DisfrutaItem]?, Error?) -> Void
typealias DisfrutaDetailCompletionBlock = (DisfrutaDetail?, Error?) -> Void
typealias AlamofireCompletionBlock = (AnyObject?, NSError?) -> Void


public let accessToken = "?access_token=eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiJ9.F0jfyuausMz2uHyzVWaXDExMGQfcgMAZRn-wVv540zCVlknYjSjg3fAatsru9HVOL7xiqpZcUB4eHQjlSIWpUw"//"http://64.251.25.64:8083/api" //
public let apiServer = "http://barrio31.candoit.com.ar/api/"//"http://64.251.25.64:8083/api" //
private var mainHeader = ["Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiJ9.F0jfyuausMz2uHyzVWaXDExMGQfcgMAZRn-wVv540zCVlknYjSjg3fAatsru9HVOL7xiqpZcUB4eHQjlSIWpUw"]
private let acceptedContentTypes = ["audio/mp3", "audio/mpeg", "image/png", "image/jpeg", "application/json", "text/html"]


class APIManager: NSObject {
  
  // MARK: REcorre services
  
  class func getRecorreCategorys(completionBlock: @escaping CategorysCompletionBlock) {
    let url = apiServer + "recorre/categorias"
    Alamofire.request(url, method: .get, parameters: nil, headers: mainHeader).validate(contentType: acceptedContentTypes).responseJSON { response in
      if let data = response.data, response.error == nil {
        do {
          let response = try JSONDecoder().decode([Category].self, from: data)
          completionBlock(response, nil)
        } catch {
          completionBlock(nil, ErrorManager.serverError())
        }
      }
      else {
        completionBlock(nil, ErrorManager.serverError())
      }
    }
  }
    
    class func getDisfrutaCategorys(completionBlock: @escaping CategorysCompletionBlock) {
        let url = apiServer + "disfruta/categorias"
        Alamofire.request(url, method: .get, parameters: nil, headers: mainHeader).validate(contentType: acceptedContentTypes).responseJSON { response in
            if let data = response.data, response.error == nil {
                do {
                    let response = try JSONDecoder().decode([Category].self, from: data)
                    completionBlock(response, nil)
                } catch {
                    completionBlock(nil, ErrorManager.serverError())
                }
            }
            else {
                completionBlock(nil, ErrorManager.serverError())
            }
        }
    }
  
  class func getPolygons(completionBlock: @escaping PolygonsCompletionBlock) {
    let url = apiServer + "recorre"
    Alamofire.request(url, method: .get, parameters: nil, headers: mainHeader).validate(contentType: acceptedContentTypes).responseJSON { response in
      if let data = response.result.value, response.error == nil {
        if let dic = data as? Dictionary<String, AnyObject> {
          if let array = dic["features"] as? Array<Dictionary<String, AnyObject>> {
            var polygons = [Polygon]()
            for item in array {
              let pol = Polygon.init(JSON: item)
              polygons.append(pol)
            }
            completionBlock(polygons, nil)
          }
        }
      }
      else {
        completionBlock(nil, ErrorManager.serverError())
      }
    }
  }
  
  class func getPolygonsDetails(withId: String , completionBlock: @escaping PolygonsDetailCompletionBlock) {
    let url = apiServer + "recorre/detalle/\(withId)"
    Alamofire.request(url, method: .get, parameters: nil, headers: mainHeader).validate(contentType: acceptedContentTypes).responseJSON { response in
      if let value = response.result.value as? [String : AnyObject], response.error == nil {
        let detail = PolygonDetail.init(JSON: value)
        
        completionBlock(detail, nil)
      }
      else {
        completionBlock(nil, ErrorManager.serverError())
      }
    }
  }
  
  class func getDisfruta(completionBlock: @escaping DisfrutaCompletionBlock) {
    let url = apiServer + "disfruta"
    Alamofire.request(url, method: .get, parameters: nil, headers: mainHeader).validate(contentType: acceptedContentTypes).responseJSON { response in
      if let data = response.result.value, response.error == nil {
        if let dic = data as? Dictionary<String, AnyObject> {
          if let array = dic["features"] as? Array<Dictionary<String, AnyObject>> {
            var dis = [DisfrutaItem]()
            for item in array {
              let obj = DisfrutaItem.init(JSON: item)
              dis.append(obj)
            }
            completionBlock(dis, nil)
          }
        }
      }
      else {
        completionBlock(nil, ErrorManager.serverError())
      }
    }
  }
  
  class func getDisfrutaDetails(withId: String , completionBlock: @escaping DisfrutaDetailCompletionBlock) {
    let url = apiServer + "disfruta/detalle/\(withId)"
    Alamofire.request(url, method: .get, parameters: nil, headers: mainHeader).validate(contentType: acceptedContentTypes).responseJSON { response in
      if let data = response.data, response.error == nil {
        do {
          let response = try JSONDecoder().decode(DisfrutaDetail.self, from: data)
          completionBlock(response, nil)
        } catch {
          completionBlock(nil, ErrorManager.serverError())
        }
      }
      else {
        completionBlock(nil, ErrorManager.serverError())
      }
    }
  }
    
    class func getAllConoceItems(completionBlock: @escaping ConoceItemsCompletionBlock) {
        
        let endpoint = "conoce\(accessToken)"
        getFromEndpoint(endpoint: endpoint) { (responseObject, error) in
            
            if error == nil {
                let conoceItems = ConoceItem.instancesFromJSONArray(jsonArray: responseObject as! [ConoceItemsJSON])
                completionBlock(conoceItems, nil)
            } else {
                completionBlock(nil, error)
            }
        }
    }
}

class ErrorManager {
  
  static let APIErrorDomain = "ar.com.barrio31.APIError"
  
  class func unknownError() -> NSError {
    return apiErrorWithCode(code: -989, andLocalizedDescription: "Error al recibir los datos. Por favor intente nuevamente.")
  }
  
  class func credentialError() -> NSError {
    return apiErrorWithCode(code: 401, andLocalizedDescription: "Los datos ingresados son incorrectos")
  }
  
  class func serverError() -> NSError {
    return apiErrorWithCode(code: -999, andLocalizedDescription: "Error connecting to the server")
  }
  
  class func apiErrorWithCode(code: Int, andLocalizedDescription localizedDescription: String) -> NSError {
    return NSError(domain: APIErrorDomain, code: code, userInfo: [NSLocalizedDescriptionKey : localizedDescription.localized()])
  }
}

extension APIManager {
    class func postToEndpoint(endpoint: String!, parameters: [String : AnyObject]? = nil, showActivityIndicator: Bool = true, completionBlock: AlamofireCompletionBlock?) {
        makeRequestWithMethod(method: .post, toEndpoint: endpoint, withParameters: parameters, showActivityIndicator: showActivityIndicator, completionBlock: completionBlock)
    }
    
    class func patchToEndpoint(endpoint: String!, parameters: [String : AnyObject]? = nil, showActivityIndicator: Bool = true, completionBlock: AlamofireCompletionBlock?) {
        makeRequestWithMethod(method: .patch, toEndpoint: endpoint, withParameters: parameters, showActivityIndicator: showActivityIndicator, completionBlock: completionBlock)
    }
    
    class func getFromEndpoint(endpoint: String!, parameters: [String : AnyObject]? = nil, showActivityIndicator: Bool = true, completionBlock: AlamofireCompletionBlock?) {
        makeRequestWithMethod(method: .get, toEndpoint: endpoint, withParameters: parameters, showActivityIndicator: showActivityIndicator, completionBlock: completionBlock)
    }
    
    private class func makeRequestWithMethod(method: Alamofire.HTTPMethod, toEndpoint endpoint: String!, withParameters parameters: [String : AnyObject]? = nil, andHeaders headers: [String : String]? = nil, showActivityIndicator: Bool, completionBlock: AlamofireCompletionBlock?) {
        
        
        let url = apiServer + endpoint
        
        let acceptedContentTypes = ["audio/mp3", "audio/mpeg", "image/png", "image/jpeg", "application/json", "text/html"]
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = showActivityIndicator
        
        Alamofire.request(url, method: method, parameters: parameters, headers: mainHeader).validate(contentType: acceptedContentTypes).responseJSON { response in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if response.result.error != nil {
                completionBlock?(nil, ErrorManager.serverError())
                return
            }
            
            if let code = response.response?.statusCode, let value = response.result.value, code == 200 {
                completionBlock?(value as AnyObject?, nil)
            } else {
                completionBlock?(nil, ErrorManager.unknownError())
            }
        }
    }
}
