//
//  RoundButton.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 29/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit
class RoundButton: UIButton {
    
   
    
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initShare()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initShare()
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        initShare()
    }
  
    
    func initShare(){
           self.clipsToBounds = true
           self.layer.cornerRadius = 16
       }

}
