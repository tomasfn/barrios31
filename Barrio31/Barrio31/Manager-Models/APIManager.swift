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
typealias PolygonsCompletionBlock = ([Polygon]?, Error?) -> Void
typealias PolygonsDetailCompletionBlock = (PolygonDetail?, Error?) -> Void
typealias DisfrutaCompletionBlock = ([DisfrutaItem]?, Error?) -> Void
typealias DisfrutaDetailCompletionBlock = (DisfrutaDetail?, Error?) -> Void



public let apiServer = "http://barrio31.candoit.com.ar/api/"//"http://64.251.25.64:8083/api" //
private var mainHeader = ["Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiJ9.F0jfyuausMz2uHyzVWaXDExMGQfcgMAZRn-wVv540zCVlknYjSjg3fAatsru9HVOL7xiqpZcUB4eHQjlSIWpUw"]
private let acceptedContentTypes = ["audio/mp3", "audio/mpeg", "image/png", "image/jpeg", "application/json", "text/html"]


class APIManager: NSObject {
  
  // MARK: REcorre services
  
  class func getCategorys(completionBlock: @escaping CategorysCompletionBlock) {
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
