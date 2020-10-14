//
//  Category.swift
//  CardDropApp
//
//  Created by Mahendra Liya on 01/09/20.
//  Copyright © 2020 Varm Yoga. All rights reserved.
//

import Foundation

struct Category : Codable {
    var count   : Int?
    var offset  : Int?
    var limit   : Int?
    var data    : [CategoryData]?
}

