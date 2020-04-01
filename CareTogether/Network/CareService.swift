//
//  CareService.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 30/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation
import Moya

public enum CareService{
    case getNewsList
    case getNewDetail(Int)
    case getStaticMyanmar
    case getStaticGlobal
    case getStaticAsian
}


extension CareService  : TargetType , AccessTokenAuthorizable{
    public var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    
    public var baseURL: URL {
        let BASE_URL = "https://ct.zacompany.dev/api"
        return URL(string: BASE_URL)!
    }
    
    public var path : String {
        switch self {
        case .getNewsList: return "/news"
        case .getNewDetail(let id) : return "/news/\(id)"
        case .getStaticMyanmar : return "/statistic/myanmar-with-region"
        case .getStaticAsian : return "/statistic/asean-list"
        case .getStaticGlobal : return "/statistic/global"
            
        }
    }
    
    public var method: Moya.Method {
        switch self{
        case .getNewsList : return .get
        case .getNewDetail(_) : return .get
        case .getStaticMyanmar : return .get
        case .getStaticAsian : return .get
        case .getStaticGlobal : return .get
            
        }
    }
    
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        
        switch self {
        case .getNewsList:
            let phoneNumber = Store.instance.getPhoneNumber() ??  ""
            let p = ["phone_number" : phoneNumber
                ] as [String : Any]
            return .requestParameters(parameters: p, encoding:URLEncoding.default )
            
        case .getNewDetail(_) : return .requestPlain
        case .getStaticMyanmar : return .requestPlain
        case .getStaticGlobal : return .requestPlain
        case .getStaticAsian : return .requestPlain
        }
        
    }
    
    public var headers: [String : String]? {
        var httpHeaders: [String: String] = [:]
        httpHeaders["Content-Type"] = "application/json"
        httpHeaders["X-API-TOKEN"] = "2p8j3fen7kg5850y1b2abdy9a3exzq6c5"
        httpHeaders["Accept"] = "application/json"
        return httpHeaders
    }
}

func infoForKey(_ key: String) -> String? {
    return (Bundle.main.infoDictionary?[key] as? String)?
        .replacingOccurrences(of: "\\", with: "")
}
