//
//  PhoneVerifyVc.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 29/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit
import SKCountryPicker


class PhoneVerifyVc: UIViewController {
    @IBOutlet weak var edPhone: UITextField!
    @IBOutlet weak var countryCodeImageView: UIImageView!
    @IBOutlet weak var countryCodeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        countryCodeButton.clipsToBounds = true
        let tap = UITapGestureRecognizer(target:self, action: #selector(openCountryPicker))
        self.countryCodeImageView.addGestureRecognizer(tap)
        
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


