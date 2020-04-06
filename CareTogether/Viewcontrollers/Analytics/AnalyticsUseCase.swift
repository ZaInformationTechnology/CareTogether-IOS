//
//  AnalyticsUseCase.swift
//  CareTogether
//
//  Created by HeinHtet on 04/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation
protocol AnalyticsRepository {
    func storeTokenWithPhone ( token : String, completion : @escaping (_ state : AnalyticsState) ->Void)
     func fetchCountForUserr ( completion : @escaping (_ state : AnalyticsState) ->Void)
}

class AnalyticsUseCase : AnalyticsRepository {
    func storeTokenWithPhone(token: String, completion: @escaping (AnalyticsState) -> Void) {
        if Reachability.isConnectedToNetwork() {
            completion(.Loading)
            Engine.apiService.request(.storePhoneWithToken(token)) { (result) in
                switch (result) {
                case .failure(let error) :
                    completion(.StoreError)
                    print("error new list \(error)")
                case .success(let response) :
                    print("new list respone \(String(data: response.data, encoding: .utf8))")
                    if response.statusCode == 200 {
                        response.data.decode(completion: { (data) in
                            completion(.StoreSuccess(response : data))
                        }) { (error) in
                            completion(.StoreError)
                        }
                    }else{
                        completion(.StoreError)
                    }
                }
            }
        }else {
            completion(.StoreError)
        }
    }
    
    func fetchCountForUserr(completion: @escaping (AnalyticsState) -> Void) {
        if Reachability.isConnectedToNetwork() {
            completion(.Loading)
            Engine.apiService.request(.getCountForUser) { (result) in
                switch (result) {
                case .failure(let error) :
                    completion(.CountError)
                    print("error new list \(error)")
                case .success(let response) :
                    print("count  respone \(String(data: response.data, encoding: .utf8))")
                    if response.statusCode == 200 {
                        response.data.decode(completion: { (data) in
                            completion(.CountSuccess(count : data))
                        }) { (error) in
                            completion(.CountError)
                        }
                    }else{
                        completion(.CountError)
                    }
                }
            }
        }else {
            completion(.CountError)
        }
    }
    
    
}
