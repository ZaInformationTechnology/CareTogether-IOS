//
//  StatusWebViewVc.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 11/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit
import WebKit
import JGProgressHUD

class StatusWebViewVc: UIViewController {
    let url = "https://ct.zacompany.dev/webview/myanmar"
    let hud = JGProgressHUD(style: .dark)
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        hud.textLabel.text = "လုပ်ဆောင်နေပါသည်"
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: URL(string: url)!))
        hud.show(in: self.view)

    }

}


extension StatusWebViewVc : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hud.dismiss(animated: true)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hud.dismiss(animated: true)
        
    }
    
}
