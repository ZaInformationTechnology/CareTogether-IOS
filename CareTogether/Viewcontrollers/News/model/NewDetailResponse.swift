//
//  NewDetailResponse.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 31/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation

struct NewDetailResponse : Codable {
    let data : NewDetail
}

struct NewDetail : Codable {
    let id : Int
    let post_date : String
    let title : String
    let paragraphs : [String]
    let images : [String]?
}


