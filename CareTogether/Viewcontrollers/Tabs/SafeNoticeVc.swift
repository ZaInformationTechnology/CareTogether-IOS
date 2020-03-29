//
//  SafeNoticeVc.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 29/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit

class SafeNoticeVc: UIViewController {
    
  

    @IBOutlet weak var lyControlFrame: UIView!
    @IBOutlet weak var lyPagerContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        lyPagerContainer.roundedTop()
        lyControlFrame.roundedBottom()
        let controller = NoticePagerVc()
         addChild(controller)
         self.lyPagerContainer.addSubview(controller.view)
        controller.view.frame = lyPagerContainer.bounds
         controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.didMove(toParent: self)
    }
 
}
