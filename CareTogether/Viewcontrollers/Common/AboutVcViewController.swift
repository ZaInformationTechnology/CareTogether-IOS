//
//  AboutVcViewController.swift
//  CareTogether
//
//  Created by HeinHtet on 06/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit

class AboutVcViewController: UIViewController {

    @IBOutlet weak var lyToolbar: DetailToolbar!
    override func viewDidLoad() {
        super.viewDidLoad()
        lyToolbar.navigationController =  self.navigationController
        lyToolbar.lbTitle.text = Const.instance.about
        lyToolbar.btnShare.isHidden = true
    }

}
