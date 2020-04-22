//
//  ToolbarWebVc.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 20/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit
import WebKit
import JGProgressHUD
class ToolbarWebVc: UIViewController {
    
    @IBOutlet weak var constHeightOfToolbar: NSLayoutConstraint!
    @IBOutlet weak var lyToolbar: DetailToolbar!
    @IBOutlet weak var lbError: UILabel!
    @IBOutlet weak var lyErrorView: UIView!
    @IBOutlet weak var webView: WKWebView!
    let hud = JGProgressHUD(style: .dark)
    
    
    var url = ""
    var toolbarTitle = ""
    var hideToolbar = true

    override func viewDidLoad() {
        super.viewDidLoad()
        lyToolbar.isHidden = hideToolbar
        lyToolbar.btnShare.isHidden = true
        if(hideToolbar){
            constHeightOfToolbar.constant  = 0
            updateViewConstraints()
            updateFocusIfNeeded()
        }
        lyToolbar.navigationController = self.navigationController
        lyToolbar.lbTitle.text = toolbarTitle
        hud.textLabel.text  = "text_loading".localized()
        hud.show(in: self.view)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        lyErrorView.isHidden = true
        webView.load(URLRequest(url: URL(string: url)!))
    }
}

extension ToolbarWebVc : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.isHidden = false
        lyErrorView.isHidden = true
        hud.dismiss(animated: true)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webView.isHidden = true
        lyErrorView.isHidden = false
        hud.dismiss(animated: true)
    }
    
}
