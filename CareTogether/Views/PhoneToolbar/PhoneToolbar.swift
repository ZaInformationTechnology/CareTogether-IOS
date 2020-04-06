//
//  PhoneToolbar.swift
//  CareTogether
//
//  Created by HeinHtet on 29/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit

class PhoneToolbar: UIView {
    
    @IBOutlet weak var contentView : UIView!
    
    @IBOutlet weak var ivWifiStatus: CIrcleImage!
    @IBOutlet weak var lbPhone: UILabel!
    override init(frame: CGRect) {
        super.init(frame : frame)
        initView()
        
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
        
    }
    
    
    
    
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
        
        if phone.count >= 11 {
            var chars = Array(phone)     // gets an array of characters
            chars[4] = "X"
            chars[5]  = "X"
            chars[6]  = "X"
            chars[7] = "X"
            let modifiedString = String(chars)
            lbPhone.text = modifiedString
            
        }
    }
}
