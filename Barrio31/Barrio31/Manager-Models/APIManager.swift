//
//  APIManager.swift
//  Barrio31
//
//  Created by air on 28/08/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import Foundation
import Alamofire

typealias AlamofireCompletionBlock = ([Category]?, Error?) -> Void

public let apiServer = "http://barrio31.candoit.com.ar/api/"//"http://64.251.25.64:8083/api" //
private var mainHeader = ["Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiJ9.F0jfyuausMz2uHyzVWaXDExMGQfcgMAZRn-wVv540zCVlknYjSjg3fAatsru9HVOL7xiqpZcUB4eHQjlSIWpUw"]
private let acceptedContentTypes = ["audio/mp3", "audio/mpeg", "image/png", "image/jpeg", "application/json", "text/html"]


class APIManager: NSObject {
  
  // MARK: REcorre services
  
  class func getUser(completionBlock: @escaping AlamofireCompletionBlock) {
    
    let url = apiServer + "recorre/categorias"
    
    Alamofire.request(url, method: .get, parameters: nil, headers: mainHeader).validate(contentType: acceptedContentTypes).responseJSON { response in
      
      if let data = response.data, response.error == nil {
        print("Data: \(data)") // original server data as UTF8 string
        
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
  
}

class ErrorManager {
  
  static let APIErrorDomain = "ar.com.barrio31.APIError"
  
  class func unknownError() -> NSError {
    return apiErrorWithCode(code: -999, andLocalizedDescription: "Error al recibir los datos. Por favor intente nuevamente.")
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
