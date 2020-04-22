//
//  NewsAndVideosVc.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 20/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit

class NewsAndVideosVc: UIViewController {
    
    @IBOutlet var container: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
// 
        self.addSubViewController(url: "https://ct.zacompany.dev/webview/news/texts", hideToolbar: true, title: "", container: container)
    }
}
