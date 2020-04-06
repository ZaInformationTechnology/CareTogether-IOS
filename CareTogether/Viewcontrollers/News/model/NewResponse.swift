//
//  NewResponse.swift
//  CareTogether
//
//  Created by HeinHtet on 31/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation

struct NewResponse : Codable {
    let data : [New]
    let meta : Meta
}

struct New : Codable {
    let id : Int
    let post_date : String
    let title : String
}


struct Meta : Codable {
    let current_page : Int
    let last_page : Int
}

