//
//  ServiceView.swift
//  CareTogether
//
//  Created by HeinHtet on 04/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit

class ServiceView: UIView {
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var lbErrorMessage: UILabel!
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
        let bundle = Bundle(for: ServiceView.self)
        bundle.loadNibNamed("ServiceView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame  = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
    }
    
    @IBAction func btnPressedAllowPermission(_ sender: Any) {
        print("allow all permission")
        let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
        UIApplication.shared.open(settingsUrl)
    }
    
}
