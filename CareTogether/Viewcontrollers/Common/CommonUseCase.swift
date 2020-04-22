//
//  CommonUseCase.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 16/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation

protocol  CommonRepository  {
    
    func getSettings (completion : @escaping (_ state : CommonState)->Void)
}

class CommonUseCase  : CommonRepository{
    func getSettings(completion: @escaping (CommonState) -> Void) {
        if Reachability.isConnectedToNetwork(){
            Engine.apiService.request(.getAvailableLanguage) { (result) in
                switch (result) {
                case .failure(let error) :
                    completion(.FetchSettingError)
                    print("error setting list \(error)")
                case .success(let response) :
                    response.data.decode(completion: { (data) in
                        completion(.FetchSettingSuccess(data: data))
                    }) { (error) in
                        completion(.FetchSettingError)
                    }
                    print("new list respone \(response)")
                    
                }
            }
        }else{
            completion(.FetchSettingError)
        }
        
    }
}
