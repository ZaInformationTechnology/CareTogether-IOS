//
//  ViewController.swift
//  CareTogether
//
//  Created by HeinHtet on 29/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit

class ChooseFontVc: UIViewController {
    
    @IBOutlet weak var lyCheckUniCode: UIView!
    @IBOutlet weak var lyCheckZawGyi: UIView!
    @IBOutlet weak var lyUniCode: RoundCardView!
    @IBOutlet weak var lyZawGyi: RoundCardView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponent()
        
    }
    
    
    @IBAction func btnStartPress(_ sender: Any) {
         self.showVc(componentId: "PhoneVerifyVc", storyboardName: "Main")
     }
    
    private func initComponent(){
        let zgTap = UITapGestureRecognizer(target: self, action: #selector(chooseZG))
        let uniTap = UITapGestureRecognizer(target: self, action: #selector(chooseUni))
        lyZawGyi.addGestureRecognizer(zgTap)
        lyUniCode.addGestureRecognizer(uniTap)
    }
    
    
    @objc func chooseZG(){
        lyZawGyi.animatePress()
        lyCheckUniCode.isHidden = true
        lyCheckZawGyi.isHidden = false
    }
    @objc func chooseUni(){
        lyUniCode.animatePress()
        lyCheckUniCode.isHidden = false
        lyCheckZawGyi.isHidden = true
    }
    
}

