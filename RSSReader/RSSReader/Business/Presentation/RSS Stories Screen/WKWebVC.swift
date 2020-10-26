//
//  WKWebVC.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 25/10/2020.
//

import UIKit
import WebKit

final class WKWebVC: UIViewController, WKNavigationDelegate {

    private let webView = WKWebView()
    private let stringURL: String
    
    init(stringURL: String) {
        self.stringURL = stringURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.frame = view.bounds
        webView.navigationDelegate = self

        let url = URL(string: stringURL)!
        let urlRequest = URLRequest(url: url)

        webView.load(urlRequest)
        webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(webView)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}
