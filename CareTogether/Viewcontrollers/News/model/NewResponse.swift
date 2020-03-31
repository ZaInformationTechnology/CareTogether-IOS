//
//  NewResponse.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 31/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation

struct NewResponse : Codable {
    let data : [New]
}

struct New : Codable {
    let id : Int
    let post_date : String
    let title : String
}
