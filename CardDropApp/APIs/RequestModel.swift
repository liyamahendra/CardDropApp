//
//  RequestModel.swift
//  CardDropApp
//
//  Created by Mahendra Liya on 01/09/20.
//  Copyright © 2020 Varm Yoga. All rights reserved.
//

import Foundation
import Alamofire

enum RequestModel {
    
    static let baseURLString = URLs.kBaseURL
    
    case getAllCategories
    case getAllPOses(_ applianceSerialNum : String)
    
    var httpHeaders: HTTPHeaders {
         let headers = HTTPHeaders.init([HTTPHeader.init(name: "Content-Type", value: "application/json")])
         return headers
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getAllCategories , .getAllPOses:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getAllCategories:
            return URLs.getAllCategories
        case .getAllPOses(let categoryID):
            return URLs.getAllCategoryPoses + "/" + categoryID
        }
    }
    
    func constructURLRequest() -> URLRequest? {
        
        var urlString = RequestModel.baseURLString+path
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? urlString
        guard let url = URL(string: urlString) else {
            print("Handle me.Unable to form URL with:\(urlString)")
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = 30
        urlRequest.allHTTPHeaderFields = httpHeaders.dictionary
        do {
            switch self {
            case .getAllCategories , .getAllPOses:
                return try Alamofire.JSONEncoding.default.encode(urlRequest, with: nil)
            }
        }
        catch {
            debugPrint("Handle me , unable to construct request")
            return nil
        }
    }
}

