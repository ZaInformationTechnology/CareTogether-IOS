//
//  CommonState.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 16/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation
enum CommonState {
    case Loading
    case FetchSettingSuccess(data : SettingModel)
    case FetchSettingError
}
