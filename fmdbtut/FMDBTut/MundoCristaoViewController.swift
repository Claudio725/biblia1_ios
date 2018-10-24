//
//  MundoCristaoViewController.swift
//  BibliaNVT
//
//  Created by MacBook Pro i7 on 11/01/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit
import WebKit

class MundoCristaoViewController: UIViewController,WKNavigationDelegate, WKUIDelegate{
    
    var ww: WKWebView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        ww.frame = UIScreen.main.bounds
        ww.center = self.view.center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ww.load(URLRequest(url: URL(string: "http://mundocristao.com.br/quemsomos")!))
        
//        let url = NSURL (string: "http://mundocristao.com.br/quemsomos")
//        let request = NSURLRequest(url: url! as URL)
//        ww.loadRequest(request as URLRequest)
//        
//        ww.delegate = self
//        
//        //Inicia animaçao da ampulheta
//        ampulheta.startAnimating()
//        
//        // Remove the title of the back button
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        view.backgroundColor = UIColor(red: 114/255, green: 0/255, blue: 45/255, alpha: 1.0) /* #72002d */
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        super.loadView()
        ww = WKWebView()
        self.ww.navigationDelegate = self
        view = ww
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
