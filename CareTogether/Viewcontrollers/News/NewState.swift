//
//  NewState.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 31/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation

enum NewState {
    case Loading
    case FetchNewListSuccess(response : NewResponse)
    case FetchNewListError
    
    case FetchNewDetailSuccess(response : NewDetailResponse)
    case FetchNewDetailError
    
}
