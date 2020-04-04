//
//  AnalyticsState.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 04/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation

enum AnalyticsState {
    case Loading
    case StoreError
    case StoreSuccess(response : EncodedModel)
}
