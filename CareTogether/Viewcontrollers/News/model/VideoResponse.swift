//
//  VideoResponse.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 06/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation

struct VideoResponse : Codable {
    let data : [VideoData]
}


struct VideoData : Codable {
    let id : String
       let title : String
    let image : String
}
