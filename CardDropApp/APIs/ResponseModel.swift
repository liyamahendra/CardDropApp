//
//  ResponseModel.swift
//  CardDropApp
//
//  Created by Mahendra Liya on 01/09/20.
//  Copyright © 2020 Varm Yoga. All rights reserved.
//

import UIKit
import Alamofire

class ResponseModel: NSObject {
    typealias completionHandler = (_ responseresult: ResponseModel) -> Void
    var resultObj: AnyObject?
    var responseStatusCode: Int?
    var responseObj: AFDataResponse<Any>?
    var isSuccess: Bool?
    
    func parseResponseFromServer(response: AFDataResponse<Any>!, completion: @escaping completionHandler) {
        //print("response is \(response)")
        self.responseObj = response
        responseStatusCode = response.response?.statusCode
        if response.response != nil {
            do {
                let json = try response.result.get()
                self.resultObj = json as AnyObject?
                //print("result Obj:", self.resultObj ?? "Json value empty")
            }
            catch {
            }
            
            if response.response?.statusCode == ResponseStatusCode.kSuccess || response.response?.statusCode == ResponseStatusCode.kSuccess202 {
                isSuccess = true
            }
            else if response.response?.statusCode == ResponseStatusCode.kInvalidCredentails || response.response?.statusCode == ResponseStatusCode.kAlreadyExist {
                isSuccess = false
            }
        }
        completion(self)
    }
    
    func showErrorMessage() {
        var error: String = ""
        if let errorStr = self.resultObj?["Message"] as? String {
            error = errorStr
        } else {
            error = self.responseObj?.error?.localizedDescription ?? Constants.kSomethingWentWrong
            if let err = self.responseObj?.error as? AFError {
                if err.isResponseSerializationError == true {
                    error = Constants.kSomethingWentWrong
                }
            }
        }
        // TODO: Show error message back to the user
    }
}

