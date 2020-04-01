//
//  InfoState.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 31/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation
enum InfoState {
    case Loading
    case FetchStaticMyanmarSuccess(response : StaticMyanmarResponse)
    case FetchStaticError
    case FetchStaticGlobalError
    case FetchStaticAsianError
    case FetchGlobalSuccess(response : StaticCountryResponse)
    case FetchAsianSuccess(response : StaticCountryResponse)
    
}
