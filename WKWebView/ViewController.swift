//
//  ViewController.swift
//  WKWebView
//
//  Created by roycms on 2017/4/21.
//  Copyright © 2017年 杜耀辉. All rights reserved.
//
//
//
// html页面js调用swift方法 -->> window.webkit.messageHandlers.jsMethodName1.postMessage("传的值");
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate,WKScriptMessageHandler {


    var webView = WKWebView()
    //需要注册的方法
    let nativeMethodName = ["jsMethodName1","jsMethodName2","jsMethodName3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareUI()
    }
    
    func prepareUI() {
        
        let config = WKWebViewConfiguration()
        let userContent = WKUserContentController()
        
        for value in nativeMethodName {
            userContent.add(self, name: value)
        }
        config.userContentController = userContent
        let webView = WKWebView(frame: UIScreen.main.bounds, configuration: config)
        let url = URL.init(string: "http://www.baidu.com")
        let request = URLRequest.init(url: url!)
        webView.navigationDelegate = self
        webView.load(request)
        view.addSubview(webView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
        for value in nativeMethodName {
            webView.configuration.userContentController.removeScriptMessageHandler(forName: value)
        }
    }
}

extension ViewController {

    //swift 调用 js方法
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webView.evaluateJavaScript("showAlert('是一个弹框')") { (item, error) in
            // 闭包中处理是否通过了或者执行JS错误的代码
        }
        webView.evaluateJavaScript("jsMethod('参数')") { (item, error) in
            // 闭包中处理是否通过了或者执行JS错误的代码
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        for value in nativeMethodName {
            if value == message.name {
                print("html页面的js调用了“" + value + "”方法，传的值是：" + String(describing: message.body))
                
            }
        }
    }
}

