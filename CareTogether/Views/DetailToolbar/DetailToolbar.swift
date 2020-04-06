//
//  DetailToolbar.swift
//  CareTogether
//
//  Created by HeinHtet on 31/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit
import SwiftHEXColors
import Foundation
class DetailToolbar: UIView {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var contentView : UIView!
    var navigationController : UINavigationController?
    override init(frame: CGRect) {
        super.init(frame : frame)
        initView()
        
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
        let bundle = Bundle(for: DetailToolbar.self)
        bundle.loadNibNamed("DetailToolbar", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame  = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        addGradientBackgound()
    }
    
    
    func addGradientBackgound(){
        let startColor : UIColor = UIColor(hexString: "#0d27e4")!
        let endColor : UIColor = UIColor(hexString: "#21ebe9")!
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.2, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        
        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
