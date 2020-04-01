//
//  StaticCountryResponse.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 01/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation


struct StaticCountryResponse : Codable {
    let data : [DataByCountry]
}


struct DataByCountry : Codable {
    let country : String
    let total_cases : String
    let new_cases : String
    let active_case : String
    let total_recovered : String
    let total_deaths : String
    let new_deaths : String
}
