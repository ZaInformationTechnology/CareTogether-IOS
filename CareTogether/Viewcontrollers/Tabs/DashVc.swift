//
//  DashVc.swift
//  CareTogether
//
//  Created by HeinHtet on 06/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation
 import UIKit

class DashVc : UIViewController {
    @IBAction func btnPressedTerm(_ sender: Any) {
       let vc   = storyboard?.instantiateViewController(identifier: "TermVc") as! TermVc
       self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func btnPressedInfo(_ sender: Any) {
        let vc   = storyboard?.instantiateViewController(identifier: "AboutVc") as! AboutVcViewController
               self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
