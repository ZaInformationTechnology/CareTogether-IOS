//
//  DoAndDontVc.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 20/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit

class DoAndDontVc: UIViewController {

    @IBOutlet weak var container : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        self.addSubViewController(url: "https://ct.zacompany.dev/webview/information/do-and-dont/videos", hideToolbar: true, title: "", container: container)

    }

}
