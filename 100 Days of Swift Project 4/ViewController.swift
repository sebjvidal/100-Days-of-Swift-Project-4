//
//  ViewController.swift
//  100 Days of Swift Project 4
//
//  Created by Seb Vidal on 16/11/2021.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var backButton: UIBarButtonItem!
    var forwardButton: UIBarButtonItem!
    var websites = ["apple.com", "hackingwithswift.com"]
    var websiteURL: URL = URL(string: "about:blank")!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadHomeURL()
        setupNavigationBarAppearance()
        setupNavigationItems()
        setupToolBarItems()
        addWebViewObserver()
    }
    
    func loadHomeURL() {
        //let url = URL(string: "https://\(websites[0])")!
        //webView.load(URLRequest(url: url))
        webView.load(URLRequest(url: websiteURL))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func setupNavigationBarAppearance() {
        navigationItem.largeTitleDisplayMode = .never
        //if #available(iOS 15, *) {
        //  let appearance = UINavigationBarAppearance()
        //  appearance.configureWithDefaultBackground()
        //  navigationController?.navigationBar.standardAppearance = appearance
        //  navigationController?.navigationBar.compactAppearance = appearance
        //  navigationController?.navigationBar.scrollEdgeAppearance = appearance
        //}
    }
    
    func setupNavigationItems() {
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
    }
    
    func setupToolBarItems() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progress = UIBarButtonItem(customView: progressView)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let config = UIImage.SymbolConfiguration(scale: .large)
        let back = UIImage(systemName: "chevron.left", withConfiguration: config)
        backButton = UIBarButtonItem(image: back, style: .plain, target: webView, action: #selector(webView.goBack))
        backButton.isEnabled = false

        let forward = UIImage(systemName: "chevron.right", withConfiguration: config)
        forwardButton = UIBarButtonItem(image: forward, style: .plain, target: webView, action: #selector(webView.goForward))
        forwardButton.isEnabled = false
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        toolbarItems = [progress, spacer, backButton, spacer, forwardButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
    }
    
    func addWebViewObserver() {
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    @objc func openTapped() {
        let alertController = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            alertController.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        present(alertController, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://\(action.title!)")!
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
        
        webView.scrollView.contentInset = UIEdgeInsets(top: view.safeAreaInsets.top, left: 0, bottom: 0, right: 0)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        showBlockedAlert(for: url!)
        decisionHandler(.cancel)
    }
    
    func showBlockedAlert(for url: URL) {
        if url.absoluteString == "about:blank" {
            return
        }
        
        let title = "URL Blocked!"
        let message = "The URL \"\(url.absoluteString)\" is not allowed."
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
}
