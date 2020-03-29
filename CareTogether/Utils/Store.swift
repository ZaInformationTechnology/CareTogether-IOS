//
//  Store.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 29/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation

class Store {
    static let instance = Store()
    
    private let PHONE = "USER_PHONE"
    
    
    init() {
        UserDefaults.standard.register(defaults: [PHONE : ""])
    }
    
    func setPhoneNumber(phone : String){
        UserDefaults.standard.set(phone, forKey: PHONE)
    }
    
    func getPhoneNumber()->String?{
        return UserDefaults.standard.string(forKey: PHONE)
        
    }
}
