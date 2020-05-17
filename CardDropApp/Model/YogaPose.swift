//
//  YogaPose.swift
//  CardDrop
//
//  Created by Brian Advent on 08.08.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import Foundation

struct YogaPose : Decodable {
    var categoryID:String
    var categoryName:String
    var categoryImageName:String
    var categoryDescription:String
    var poses: [Pose]
}
