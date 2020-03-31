//
//  InfoUseCase.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 31/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation

protocol InfoRepository {
    func getStaticMyanmar ( completion : @escaping (_ state : InfoState) ->Void)
}

class InfoUseCase: InfoRepository {
    func getStaticMyanmar(completion: @escaping (InfoState) -> Void) {

        
            if Reachability.isConnectedToNetwork() {
                completion(.Loading)
                Engine.apiService.request(.getStaticMyanmar) { (result) in
                    switch (result) {
                    case .failure(let error) :
                        completion(.FetchStaticError)
                        print("error new list \(error)")
                    case .success(let response) :
                        response.data.decode(completion: { (data) in
                            completion(.FetchStaticMyanmarSuccess(response : data))
                        }) { (error) in
                            completion(.FetchStaticError)
                        }
                        print("new list respone \(response)")
                        
                    }
                }
            }else {
                completion(.FetchStaticError)
            }
        }
    
}
