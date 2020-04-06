//
//  CIrcleImage.swift
//  CareTogether
//
//  Created by HeinHtet on 29/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit

class CIrcleImage: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        initShare()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initShare()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initShare()
    }
    
    func initShare(){
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    
}
