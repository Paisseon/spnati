//
//  ViewController.swift
//  Strip Poker Night at the Inventory
//
//  Created by Paisseon on 26/09/2020.
//  Copyleft © 2020 Paisseon. All wrongs reversed.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var offlineView: UIView!
    @IBOutlet weak var offlineIcon: UIImageView!
    @IBOutlet weak var offlineButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Globals
    var webView: WKWebView!
    var tempView: WKWebView!
    var progressBar : UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = appTitle
        setupApp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onOfflineButtonClick(_ sender: Any) {
        offlineView.isHidden = true
        webViewContainer.isHidden = false
        loadAppUrl()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == #keyPath(WKWebView.isLoading)) {
        }
        if (keyPath == #keyPath(WKWebView.estimatedProgress)) {
            progressBar.progress = Float(webView.estimatedProgress)
        }
    }
    
    func setupWebView() {
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: webViewContainer.frame.width, height: webViewContainer.frame.height))
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webViewContainer.addSubview(webView)
        webView.allowsBackForwardNavigationGestures = true
        webView.configuration.preferences.javaScriptEnabled = true
        
        webView.scrollView.bounces = bouncyAndJiggly
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: NSKeyValueObservingOptions.new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    func setupUI() {

        progressBar = UIProgressView(frame: CGRect(x: 0, y: 0, width: webViewContainer.frame.width, height: 40))
        progressBar.autoresizingMask = [.flexibleWidth]
        progressBar.progress = 0.0
        progressBar.tintColor = progressBarColor
        webView.addSubview(progressBar)
        
        activityIndicator.color = activityIndicatorColor
        activityIndicator.startAnimating()
        
        offlineView.isHidden = true
    }

    func loadAppUrl() {
        let urlRequest = URLRequest(url: spnatiServer!)
        webView.load(urlRequest)
    }
    
    func setupApp() {
        setupWebView()
        setupUI()
        loadAppUrl()
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.isLoading))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        NotificationCenter.default.removeObserver(self, name: .UIDeviceOrientationDidChange, object: nil)
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if (changeAppTitleToPageTitle) {
            navigationItem.title = webView.title
        }
        progressBar.isHidden = true
        activityIndicatorView.isHidden = true
        activityIndicator.stopAnimating()
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        offlineView.isHidden = false
        webViewContainer.isHidden = true
    }
}

extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if (navigationAction.targetFrame == nil) {
            webView.load(navigationAction.request)
        }
        return nil
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let requestUrl = navigationAction.request.url {
            if let requestHost = requestUrl.host {
                if (requestHost.range(of: allowedOrigin) != nil ) {
                    decisionHandler(.allow)
                } else {
                    decisionHandler(.cancel)
                    if (UIApplication.shared.canOpenURL(requestUrl)) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(requestUrl)
                        } else {
                            UIApplication.shared.openURL(requestUrl)
                        }
                    }
                }
            } else {
                decisionHandler(.cancel)
            }
        }
    }
}
