
//
//  StaticMyanmarResponse.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 31/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation

struct StaticMyanmarResponse  : Codable {
    let overall_counts : OverAll
    let data_by_regions : [DataByHospital]
}


struct OverAll : Codable {
    let total_quarantined : String?
    let total_quarantined_suspected : String?
    let pending : String?
    let suspected : String?
    let negative : String?
    let confirmed : String?
    let deaths : String?
    let recovered : String?
}

struct DataByHospital : Codable {
    let region : String
    let hospital : String?
    let quarantined_suspected : String
    let quarantined : String
    let suspected : String
    let negative : String
    let confirmed : String
    let pending : String
//    let extra : Extra
//    let positions : LatLng
    let no : Int
}

struct LatLng  : Codable{
    let lat : Double
    let lon : Double
}

struct Extra : Codable {
    let male : Int
    let female : Int
    let adult : Int
    let child : Int
}
