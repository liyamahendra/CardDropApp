//
//  APIClient.swift
//  CardDropApp
//
//  Created by Mahendra Liya on 01/09/20.
//  Copyright © 2020 Varm Yoga. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - NETWORK MANAGER
class NetWorkManager {

    static let sharedManager = NetworkReachabilityManager(host: "www.google.com")
    static func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

// MARK: - BACKGROUND MODE MANAGER
class BackgroundModeManager {

    static func beginBackgroundTask() -> UIBackgroundTaskIdentifier {
        return UIApplication.shared.beginBackgroundTask(expirationHandler: {})
    }

    static func endBackgroundTask(taskID: UIBackgroundTaskIdentifier) {
        UIApplication.shared.endBackgroundTask(taskID)
    }
}

// MARK: - CLIENT API MANAGER
class APIClient {

    static let sharedInstance = APIClient()
    var dataRequest: DataRequest?

    func noInternetToast(competion: @escaping (_ responseresult: ResponseModel) -> Void) {
        let responseModelObject = ResponseModel()
        responseModelObject.responseStatusCode = ResponseStatusCode.noInternetErrorCode
        competion(responseModelObject)
        // TODO: Show no internet feedback to the user
    }

    func failureToast(message: String, competion: @escaping (_ responseresult: ResponseModel) -> Void) {
        let responseModelObject = ResponseModel()
        responseModelObject.responseStatusCode = ResponseStatusCode.kWrongPin
        competion(responseModelObject)
        //UIApplication.shared.keyWindow?.rootViewController?.showCustomToast(message: message)
    }

    func customErrorToast(statuscode: Int, competion: @escaping (_ responseresult: ResponseModel) -> Void) {
        let responseModelObject = ResponseModel()
        responseModelObject.responseStatusCode = statuscode
        responseModelObject.showErrorMessage()
        competion(responseModelObject)
    }

    // MARK: - API Handlers
    func performRequest(request: URLRequestConvertible, canCancelRequest: Bool, completion: @escaping (_ responseresult: ResponseModel) -> Void) {
        
        if NetWorkManager.isConnectedToInternet() == true {
            
            //request.checkForValidToken(completion: { (requestChecked) in
            self.dataRequest?.cancel()
            let request = Alamofire.AF.request(request, interceptor: nil).responseJSON { (response) in
                self.printRequest(request: request, response: response)
                
                let statusCode = response.response?.statusCode
                if statusCode == ResponseStatusCode.kInvalidToken {
                    print("*** Token is invalid, refreshing it ***")
                }
                else {
                    let responseObj: ResponseModel =  ResponseModel()
                    responseObj.parseResponseFromServer(response: response, completion: { (_) in
                        completion(responseObj)
                    })
                }
            }
            if canCancelRequest == true {
                self.dataRequest = request
            }
            //})
        }
        else {
            noInternetToast(competion: completion)
        }
    }


    func printRequest(request: URLRequestConvertible, response: AFDataResponse<Any>) {

        var bodyAsString = "Body not set" as NSString
        if let body = request.urlRequest?.httpBody {
            bodyAsString = NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "Unable to decode body"
        }

        var responseHeaders = "Unable to get response headers"
        var statusCode = "Status code not set"
        if let cResponse = response.response {
            statusCode = "\(cResponse.statusCode)"
            responseHeaders = "\(cResponse.allHeaderFields)"
        }

        var returnedData = "No data returned" as NSString
        if let cData = response.data {
            returnedData = NSString(data: cData, encoding: String.Encoding.utf8.rawValue) ?? "Unable to decode returned data"
        }

        //print("\n\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\nRequest URL: \(request.urlRequest?.url?.absoluteString ?? "URL NOT SET")\n-----------------------\nRequest Type:\n\(request.urlRequest?.httpMethod ?? "REQUEST TYPE NOT SET")\n-----------------------\nHeaders:\n\(request.urlRequest?.allHTTPHeaderFields ?? ["EMPTY": "HEADERS NOT SET"])\n-----------------------\nBody:\n\(bodyAsString)\n-----------------------\nResponse:\nStatus code: \(statusCode)\nHeaders:\(responseHeaders)\n-----------------------\nReceived data:\n\(returnedData)\n-----------------------\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n\n")
    }

    func cancelTheRunningRequest() {
        self.dataRequest?.cancel()
    }
}
