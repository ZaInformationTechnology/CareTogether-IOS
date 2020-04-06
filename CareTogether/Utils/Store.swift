//
//  Store.swift
//  CareTogether
//
//  Created by HeinHtet on 29/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation

class Store {
    static let instance = Store()
    
    private let PHONE = "USER_PHONE"
    private let ENCRYPTED_DEVICE_NAME = "ENCRYPTED_DEVICE_NAME"
    private let FB_TOKEN = "FB_TOKEN"

    
    init() {
        UserDefaults.standard.register(defaults: [PHONE : "",ENCRYPTED_DEVICE_NAME : "", FB_TOKEN : ""])
    }
    
    func setPhoneNumber(phone : String){
        UserDefaults.standard.set(phone, forKey: PHONE)
    }
    
    func getPhoneNumber()->String?{
        return UserDefaults.standard.string(forKey: PHONE)
        
    }
    
    
    func getEncryptedDeviceName() -> String? {
        return UserDefaults.standard.string(forKey: ENCRYPTED_DEVICE_NAME)
    }
    
    func getFireBaseToken() -> String? {
        return UserDefaults.standard.string(forKey: FB_TOKEN)
    }
    
    func setFBToken(token : String)  {
        UserDefaults.standard.set(token,forKey: FB_TOKEN)
    }
    
    func setEncryptedDeviceName(phone : String)  {
           UserDefaults.standard.set(phone,forKey: ENCRYPTED_DEVICE_NAME)
       }
}
