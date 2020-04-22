//
//  SettingModel.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 16/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation

struct SettingModel : Codable {
    let ministry_on : Bool
    let ministry_on_test  : Bool
    let locals : [LocaleModel]
}


struct LocaleModel : Codable {
    let locale : String
    let name : String
}
