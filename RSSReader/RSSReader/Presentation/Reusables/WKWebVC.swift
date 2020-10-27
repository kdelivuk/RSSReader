//
//  WKWebVC.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 25/10/2020.
//

import WebKit

final class WKWebVC: UIViewController, WKNavigationDelegate {

    // MARK: - Private properties
    
    private let webView = WKWebView()
    private let stringURL: String
    
    // MARK: - Class lifecycle
    
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

        guard let url = URL(string: stringURL) else {
            // TODO: -
            return
        }
        let urlRequest = URLRequest(url: url)

        webView.load(urlRequest)
        webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(webView)
    }

    // MARK: - WKWebView delegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}
