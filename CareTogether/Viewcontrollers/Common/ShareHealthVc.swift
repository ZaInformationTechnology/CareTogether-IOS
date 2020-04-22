//
//  ShareHealthVc.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 20/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit

class ShareHealthVc: UIViewController {
    @IBOutlet weak var lyToolbar: DetailToolbar!
    @IBOutlet weak var edShareHealth : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lyToolbar.navigationController = self.navigationController
        lyToolbar.lbTitle.text = "text_share_current_health_title".localized()
        lyToolbar.btnShare.isHidden = true
        let paddingView: UIView = UIView(frame: CGRect(x: 16, y: 16, width: 5, height: 20))
        edShareHealth.leftView = paddingView
        edShareHealth.rightView = paddingView   
        edShareHealth.leftViewMode = .always
    }

}
