//
//  Engine.swift
//  CareTogether
//
//  Created by HeinHtet on 30/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Moya
class Engine {
   static let apiService = MoyaProvider<CareService>(plugins: [NetworkLoggerPlugin(), AccessTokenPlugin{_ in
//         guard let token = Store.instance.getUser()?.token else {
//             return ""
//         }
//         return token
    return ""
         }])
     
}
