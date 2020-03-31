//
//  Utils.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 30/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit

extension Data{
    func decode<T : Codable>(completion : (T)->Void , completionError : (_ error : String)-> Void ) {
        do {
            let model = try JSONDecoder().decode(T.self, from: self)
            completion(model)
        }catch (let error){
            completionError(error.localizedDescription)
            print("Generic Decode Error \(error)")
           
        }
    }
}


extension Int {
    func isAuthorized(completion : @escaping () ->Void){
        if(self == 401){
            print("UnAuthorized")
            NotificationCenter.default.post(Notification.init(name: Notification.Name("EVENT_UNAUTHORIZED"), object: nil, userInfo: nil))
            
        }else{
            completion()
        }
    }
}
