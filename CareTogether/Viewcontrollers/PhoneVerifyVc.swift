//
//  PhoneVerifyVc.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 29/03/2020.
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hud.textLabel.text  = "လုပ်ဆောင်နေပါသည်"
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
                Store.instance.setEncryptedDeviceName(token: result.token)
                //  self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
            }
        }
        
    }
    
    @IBAction func btnEnterPressed(_ sender: Any) {
        guard  let phone = edPhone.text  else {
            return
        }
        Store.instance.setPhoneNumber(phone: phone)
        Router.instance.navigate(routeName: "AppTabBar", storyboard: "Main")
    }
    @IBAction func countryCodeButtonClicked(_ sender: UIButton) {
        print("open coutn")
        
        openCountryPicker()
    }
    
}


