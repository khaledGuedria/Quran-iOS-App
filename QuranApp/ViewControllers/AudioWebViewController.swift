//
//  AudioWebViewController.swift
//  QuranApp
//
//  Created by Khaled Guedria on 5/12/21.
//  Copyright © 2021 Khaled Guedria. All rights reserved.
//

import UIKit
import WebKit

class AudioWebViewController: UIViewController, WKNavigationDelegate {
    
    //var
    var webURL:String?
    
    
    //widgets
    let webView = WKWebView()
    let activityIndicator = UIActivityIndicatorView()
    
    
    //LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        //ActivityIndicator setup
        self.activityIndicator.frame = CGRect(x: view.frame.width/2, y: view.frame.height/2, width: 40, height: 40)
        self.activityIndicator.style = .large
        self.activityIndicator.startAnimating()
        
        //web view setup
        webView.frame = view.bounds
        webView.navigationDelegate = self

        let url = URL(string: webURL!)!
        let urlRequest = URLRequest(url: url)

        webView.load(urlRequest)
        webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(webView)
        view.addSubview(activityIndicator)
    }
    
    //FUNCTIONS
    
    //didFinishLoad
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        // hide indicator
        
    }

    
    
    //ERROR HAnDLE
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
                let host = url.host, !host.hasPrefix(self.webURL!),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print(url)
                print("Redirected to browser. No need to open it locally")
                decisionHandler(.cancel)
            } else {
                print("Open it locally")
                decisionHandler(.allow)
            }
        } else {
            print("not a user click")
            decisionHandler(.allow)
        }
    }
}
