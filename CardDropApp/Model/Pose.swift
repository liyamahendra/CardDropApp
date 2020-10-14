//
//  Images.swift
//  CardDrop
//
//  Created by Brian Advent on 08.08.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import Foundation

struct Pose : Codable {
    var poseID             : String?
    var categoryID         : String?
    var name               : String?
    var description        : String?
    var photographer       : String?
    var imageURL           : String?
    var videoURL           : String?
    var isActive           : Bool?
    var displayOrder       : Int?
    var createdBy          : String?
    var createdDatetime    : String?
    var modifiedBy         : String?
    var modifiedDatetime   : String?
    
    private enum CodingKeys : String, CodingKey {
        case poseID = "pose_id",
        categoryID = "category_id",
        name,
        description,
        photographer,
        imageURL = "image_url",
        videoURL = "video_url",
        isActive = "is_active",
        displayOrder = "display_order",
        createdBy = "created_by",
        createdDatetime = "created_datetime",
        modifiedBy = "modified_by",
        modifiedDatetime = "modified_datetime"
    }
}
