//
//  RealNewVc.swift
//  CareTogether
//
//  Created by HeinHtet on 31/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit

class RealNewVc: UIViewController {
    
    @IBOutlet weak var lbFb1: UILabel!
    @IBOutlet weak var lyDetailToolbar : DetailToolbar!
    @IBOutlet weak var lbFb2: UILabel!

    @IBOutlet weak var lbWeb2: UILabel!
    @IBOutlet weak var lbWeb1: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lyDetailToolbar.navigationController = self.navigationController
        lyDetailToolbar.btnShare.isHidden = true
        lyDetailToolbar.lbTitle.text = "သတင်းအမှန်စောင့်ကြည့်ရန်"
        lbFb1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fb1Presed)))
        lbFb2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fb2Presed)))
        lbWeb1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(web1Pressed)))
        lbWeb2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(web2Pressed)))

    }
    
    
    @objc func fb1Presed(){
        print("fb 1")
        UIApplication.tryURL(urls: [
        "fb://ministryofhealthandsportsmyanmar", // App
        "https://www.facebook.com/ministryofhealthandsportsmyanmar" // Website if app fails
        ])
    }
    
    
    @objc func fb2Presed(){
           print("fb 1")
           UIApplication.tryURL(urls: [
           "fb://myanmarcdc", // App
           "https://www.facebook.com/myanmarcdc" // Website if app fails
           ])
       }
    
    @objc func web1Pressed(){
           print("fb 1")
           UIApplication.tryURL(urls: [
           "http://mohs.gov.mm/", // App
           "http://mohs.gov.mm  /" // Website if app fails
           ])
       }
       @objc func web2Pressed(){
           print("fb 1")
           UIApplication.tryURL(urls: [
           "https://who.int/", // App
           "https://who.int/" // Website if app fails
           ])
       }
    

}
extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(URL(string: url)!) {
                application.openURL(URL(string: url)!)
                return
            }
        }
    }
}
