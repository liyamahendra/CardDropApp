//
//  CategoryData.swift
//  CardDropApp
//
//  Created by Mahendra Liya on 01/09/20.
//  Copyright © 2020 Varm Yoga. All rights reserved.
//

import Foundation

struct CategoryData : Codable {
   
    var categoryID        : String?
    var name              : String?
    var imageURL          : String?
    var description       : String?
    var isActive          : Bool?
    var displayOrder      : Int?
    var createdBy         : String?
    var createdDatetime   : String?
    var modifiedBy        : String?
    var modifiedDatetime  : String?
    var poses             : [Pose]?
    
    private enum CodingKeys : String, CodingKey {
        case categoryID = "category_id",
        name,
        imageURL = "image_url",
        description,
        isActive = "is_active",
        displayOrder = "display_order",
        createdBy = "created_by",
        createdDatetime = "created_datetime",
        modifiedBy = "modified_by",
        modifiedDatetime = "modified_datetime",
        poses
    }
}
