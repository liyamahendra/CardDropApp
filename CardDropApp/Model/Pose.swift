//
//  Images.swift
//  CardDrop
//
//  Created by Brian Advent on 08.08.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import Foundation

struct Pose : Decodable {
    var imageID: String
    var imageName:String
    var photographer:String
    var description:String
    var mediaPath: String
    var isLocal: Bool
}
