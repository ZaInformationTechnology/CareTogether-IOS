//
//  StatusWebView.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 22/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit
import WebKit
import JGProgressHUD
class StatusWebView: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    let hud = JGProgressHUD(style: .dark)
    
    @IBOutlet weak var lbError: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        hud.textLabel.text = "လုပ်ဆောင်နေပါသည်"
        hud.show(in: self.view)
        webView.load(URLRequest(url: URL(string: ENV.instance.STATUS_URL)!))
        webView.navigationDelegate = self
    }
}


extension StatusWebView : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.webView.isHidden = true
        self.lbError.isHidden  = false
        NSLog("Erro de navegacao: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hud.dismiss(animated: true)
        self.lbError.isHidden = true
        self.webView.isHidden = false
    }
}
