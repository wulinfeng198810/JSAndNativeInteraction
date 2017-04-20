//
//  ViewController.swift
//  JSAndNativeInteraction
//
//  Created by Leo on 19/04/2017.
//  Copyright © 2017 Leo. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    var webView: WKWebView!

    @IBOutlet weak var nameTextfiled: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let config = WKWebViewConfiguration()
        config.preferences.minimumFontSize = 20
        
        webView = WKWebView(frame: CGRect(x: 0, y: 64, width: view.bounds.width, height: 150), configuration: config)
        view.addSubview(webView)
        
        
        guard let filePath = Bundle.main.path(forResource: "index.html", ofType: nil),
        let html = try? String.init(contentsOfFile: filePath, encoding: .utf8)
        else {
                return
        }
        
        let baseUrl = Bundle.main.bundleURL
        
        webView.loadHTMLString(html, baseURL: baseUrl)
        
        //JS调用OC 添加处理脚本
        let userCon = config.userContentController
        userCon.add(self, name: "nativeCamera")
    }
    
    // MARK - Action
    @IBAction func callJSAction(_ sender: Any) {
        
        
        guard let name = nameTextfiled.text else {
            return
        }
        
        if let name = nameTextfiled.text, (name as NSString).length == 0 {
            
            let alert = UIAlertController(title: "input friend name!", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        } else {
            
            webView.evaluateJavaScript("alertName('\(name)')", completionHandler: nil)
        }
    }
    
}

extension UIViewController {

}

// MARK - WKScriptMessageHandler
extension UIViewController: WKScriptMessageHandler {
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message)
        if message.name == "nativeCamera" {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.white
            vc.title = "navtive View"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

