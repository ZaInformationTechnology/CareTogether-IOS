//
//  PhoneToolbar.swift
//  CareTogether
//
//  Created by HeinHtet on 29/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit

protocol PhoneToolbarCallback {
    func goSettingVc()
    func goPPLVc()
    func goInfoVc()
}

class PhoneToolbar: UIView {
    
    @IBOutlet weak var ivLocale: UIImageView!
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var ivWifiStatus: CIrcleImage!
    @IBOutlet weak var lbPhone: UILabel!
    var delegate : PhoneToolbarCallback? = nil
    override init(frame: CGRect) {
        super.init(frame : frame)
        initView()
        
    }
    
    @IBOutlet weak var ivSetting: CIrcleImage!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
        
    }
    
    
    func checkLanguage(){
        let currentLanguage = Store.instance.getCurrentLanguage()
        if (currentLanguage != nil){
            let image = UIImage(named: "\(currentLanguage!.locale)")
            ivLocale.image = image
        }
    }
    
    
    @IBOutlet weak var ivInfo: CIrcleImage!
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initView()
        
    }
    
    
    private func initView(){
        let bundle = Bundle(for: PhoneToolbar.self)
        bundle.loadNibNamed("PhoneToolbar", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame  = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        let phone = Store.instance.getPhoneNumber() ?? "-"
        
        //        if !Reachability.isConnectedToNetwork() {
        //            ivWifiStatus.image = UIImage(named: "no_wifi")
        //        }
        
        if phone.count >= 11 {
            var chars = Array(phone)     // gets an array of characters
            chars[4] = "X"
            chars[5]  = "X"
            chars[6]  = "X"
            chars[7] = "X"
            let modifiedString = String(chars)
            lbPhone.text = modifiedString
            
        }
        
        let settingPress = UITapGestureRecognizer(target: self, action: #selector(goSettingVc))
        ivSetting.isUserInteractionEnabled = true
        ivSetting.addGestureRecognizer(settingPress)
        
        
        
        let pplPressed = UITapGestureRecognizer(target: self, action: #selector(goPPLVc))
        ivWifiStatus.isUserInteractionEnabled = true
        ivWifiStatus.addGestureRecognizer(pplPressed)
        
        
        
        let infoPress = UITapGestureRecognizer(target: self, action: #selector(goInfo))
        ivInfo.isUserInteractionEnabled = true
        ivInfo.addGestureRecognizer(infoPress)
        
        
    }
    
    @objc func goPPLVc(){
        delegate?.goPPLVc()
    }
    
    @objc func goInfo(){
        delegate?.goInfoVc()
    }
    
    @objc func goSettingVc(){
        delegate?.goSettingVc()
    }
}
