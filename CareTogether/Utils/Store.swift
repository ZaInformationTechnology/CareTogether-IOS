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
    private let CURRENT_LANGUAGE = "CURRENT_LANGUAGE"
    
    private let DEFAULT_LOCALES = "DEFAULT_LOCALE"

    
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
    
  
    func setCurrentLanguage(loginResponse: LocaleModel){
          if let encoded = try? JSONEncoder().encode(loginResponse) {
              UserDefaults.standard.set(encoded, forKey: CURRENT_LANGUAGE)
          }
      }
      
      func getCurrentLanguage() -> LocaleModel?{
          if let rawData = UserDefaults.standard.data(forKey: CURRENT_LANGUAGE),
              let user = try? JSONDecoder().decode(LocaleModel.self, from: rawData) {
              return user
          }
          return nil
      }
    
    
    func setLocales(locales: [LocaleModel]){
           if let encoded = try? JSONEncoder().encode(locales) {
               UserDefaults.standard.set(encoded, forKey: DEFAULT_LOCALES)
           }
       }
       
       func getLocales() -> [LocaleModel]?{
           if let rawData = UserDefaults.standard.data(forKey: DEFAULT_LOCALES),
               let locales = try? JSONDecoder().decode([LocaleModel].self, from: rawData) {
               return locales
           }
           return nil
       }
}
