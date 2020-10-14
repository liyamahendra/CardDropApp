//
//  Constants.swift
//  CardDropApp
//
//  Created by Mahendra Liya on 01/09/20.
//  Copyright © 2020 Varm Yoga. All rights reserved.
//

import Foundation
import UIKit

class URLs {
    static let kBaseURL = "https://varmapp.no/api"
    static let getAllCategories = "/categories"
    static let getAllCategoryPoses = "/poses"
}

struct Validations {
    static let kTicketNumberLength = 1
    static let kUploadLimit = 10
    static let kUploadCharLimit = 256
    static let kOSDUploadLimit = 1
}

class DataStore {
    static var categories: Category?
    static var poses: [Pose]?
    
    class func getCategory(categoryID: String) -> CategoryData? {
        if let i = DataStore.categories?.data?.firstIndex(where: { $0.categoryID == categoryID }) {
            return DataStore.categories?.data?[i]
        }
        
        return nil
    }
}

struct GlobalReferences {
    static let kUserDefaults: UserDefaults = UserDefaults.standard
    static let kAppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    static let kFileManager: FileManager = FileManager.default
}

struct Constants {
    static let kSomethingWentWrong = "The operation couldn't be completed. Please try again later."
    //Network Related Messages
    static let KNoInternet = "No Internet! \n Make sure you are connected to intenet"
}

struct ResponseStatusCode {
    static let kSuccess = 200
    static let kSuccess202 = 202
    static let kWrongPin = 403
    static let kUserNotAvaialbe = 404
    static let noInternetErrorCode = 123
    static let kInvalidToken = 401
    static let kInvalidCredentails = 406
    static let kAlreadyExist = 409
}

