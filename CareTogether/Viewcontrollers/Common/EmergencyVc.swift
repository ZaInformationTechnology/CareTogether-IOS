//
//  EmergencyVc.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 11/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit
import WebKit
import JGProgressHUD
class EmergencyVc: UIViewController {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbRegionTitle: UILabel!
    var url = "https://ct.zacompany.dev/webview/contacts"
    let hud = JGProgressHUD(style: .dark)
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let language = Store.instance.getCurrentLanguage()?.locale ?? "mm"
        url = "https://ct.zacompany.dev/webview/contacts?language=\(language)"
        hud.textLabel.text = "text_loading".localized()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: URL(string: url)!))
        hud.show(in: self.view)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        lbTitle.text = "contact_title".localized()
        lbRegionTitle.text = "contact_region_info".localized()
    }
    
}


extension EmergencyVc : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hud.dismiss(animated: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hud.dismiss(animated: true)
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.request.url?.scheme == "tel" {
            guard let telUrl  = navigationAction.request.url else {return}
            if let range = telUrl.absoluteString.range(of: "tel:") {
                let phone = telUrl.absoluteString[range.upperBound...]
                dialNumber(number: String(phone))
            }
            
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func dialNumber(number : String) {
        
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

