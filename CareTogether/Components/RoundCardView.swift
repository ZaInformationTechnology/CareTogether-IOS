//
//  RoundCardView.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 29/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit

class RoundCardView: UIView {
    
    
    var cornerRadius: CGFloat = 16
    var shadowOffsetWidth: Int = 0
    var shadowOffsetHeight: Int = 5
    var shadowColor: UIColor? = UIColor.gray
    var shadowOpacity: Float = 0.5
    
    
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
    
    
    
    override func layoutSubviews() {
        initShare()
    }
    
    
    
    func initShare(){
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
}
