//
//  PhoneVerifyVc.swift
//  CareTogether
//
//  Created by HeinHtet on 29/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit
import SKCountryPicker
import FirebaseMessaging
import FirebaseInstanceID
import JGProgressHUD

class PhoneVerifyVc: UIViewController {
    @IBOutlet weak var edPhone: UITextField!
    @IBOutlet weak var countryCodeImageView: UIImageView!
    @IBOutlet weak var countryCodeButton: UIButton!
    let hud = JGProgressHUD(style: .dark)
    var useCase = AnalyticsUseCase()
    
    
    var firebaseToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hud.textLabel.text  = "text_loading".localized()
        let encryptedName = Store.instance.getEncryptedDeviceName()
        
        if(encryptedName != nil && encryptedName != ""){
            return
        }
        checkNetwork()
    }
    
    
    
    func checkNetwork()  {
        if Reachability.isConnectedToNetwork() {
            retrieveToken()
        }else{
            showErrorMessageAlertWithRetry(message: "အင်တာနက်ဖွင့်ရန်လိုအပ်ပါသည်။") { (retry) in
                self.checkNetwork()
            }
        }
    }
    
    @objc func openCountryPicker(){
        
        // Invoke below static method to present country picker without section control
        // CountryPickerController.presentController(on: self) { ... }
        
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
            
            guard let self = self else { return }
            
            self.countryCodeImageView.image = country.flag
            self.countryCodeButton.setTitle(country.dialingCode, for: .normal)
            
        }
        countryController.detailColor = UIColor.red
        
    }
    
    func retrieveToken(){
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.firebaseToken = result.token
                Store.instance.setFBToken(token : result.token)
            }
        }
        
    }
    
    @IBAction func btnEnterPressed(_ sender: Any) {
        guard  let phone = edPhone.text  else {
            return
        }
        Store.instance.setPhoneNumber(phone: "0\(phone)")
        
        if !phone.isEmpty {
            if !firebaseToken.isEmpty {
                useCase.storeTokenWithPhone(token: firebaseToken) { (state) in
                    self.renderStatus(state: state)
                }
            }else{
                checkNetwork()
            }
        }else{
           showErrorMessageAlertWithClose(message: "မှန်ကန်သောဖုန်းနံပါတ်အားထည့်သွင်းပေးပါ")
        }
   
    }
    
    func renderStatus(state : AnalyticsState){
        switch state {
        case .Loading:
            self.hud.show(in: self.view)
        case .StoreError :
            self.hud.dismiss(animated: true)
        case .StoreSuccess(let data) :
            self.hud.dismiss(animated: true)
            Store.instance.setEncryptedDeviceName(phone: data.phone)
            Router.instance.navigate(routeName: "AppTabBar", storyboard: "Main")

        default:
            print("other")
        }

    }
    
    @IBAction func countryCodeButtonClicked(_ sender: UIButton) {
        print("open coutn")
        
        openCountryPicker()
    }
    
}


