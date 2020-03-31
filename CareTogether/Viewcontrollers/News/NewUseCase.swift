//
//  NewUseCase.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 31/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation


protocol NewRepository {
    func fetchNewList( completion : @escaping (_ state : NewState) -> Void)
    func fetchNewDetail(id : Int, completion : @escaping (_ state : NewState) -> Void)
}

class NewUseCase  : NewRepository {
    
    func fetchNewList(completion: @escaping (NewState) -> Void) {
        if Reachability.isConnectedToNetwork() {
            completion(.Loading)
            Engine.apiService.request(.getNewsList) { (result) in
                switch (result) {
                case .failure(let error) :
                    completion(.FetchNewListError)
                    print("error new list \(error)")
                case .success(let response) :
                    response.data.decode(completion: { (data) in
                        completion(.FetchNewListSuccess(response: data))
                    }) { (error) in
                        completion(.FetchNewListError)
                    }
                    print("new list respone \(response)")
                    
                }
            }
        }else {
            completion(NewState.FetchNewListError)
        }
    }
    
    func fetchNewDetail(id : Int, completion: @escaping (NewState) -> Void) {
        if Reachability.isConnectedToNetwork() {
            completion(.Loading)
            Engine.apiService.request(.getNewDetail(id)) { (result) in
                switch (result) {
                case .failure(let error) :
                    completion(.FetchNewDetailError)
                    print("error new list \(error)")
                case .success(let response) :
                    response.data.decode(completion: { (data) in
                        completion(.FetchNewDetailSuccess(response: data))
                    }) { (error) in
                        completion(.FetchNewDetailError    )
                    }
                    print("new list respone \(response)")
                    
                }
            }
        }else {
            completion(NewState.FetchNewDetailError)
        }
        
    }
    
    
}
