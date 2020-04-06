//
//  TermVc.swift
//  CareTogether
//
//  Created by HeinHtet on 06/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit

class TermVc: UIViewController {
    
    @IBOutlet weak var lyToolbar: DetailToolbar!
    
    @IBOutlet weak var lbMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lyToolbar.navigationController = self.navigationController
        lyToolbar.lbTitle.text = Const.instance.term
        lbMessage.text = Const.instance.term_message
        lyToolbar.btnShare.isHidden = true

    }
}
