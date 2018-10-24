//
//  LojaVirtualViewController.swift
//  BibliaNVT
//
//  Created by MacBook Pro i7 on 11/01/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit
import WebKit


class LojaVirtualViewController: UIViewController,WKNavigationDelegate,WKUIDelegate {
    //SFSafariViewControllerDelegate {
    
    var ww: WKWebView!
    
    override func viewDidAppear(_ animated: Bool) {
        ww.frame = UIScreen.main.bounds
        ww.center = self.view.center
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ww.load(URLRequest(url: URL(string: "http://www.saraiva.com.br/biblias-mundo-cristao/")!))
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
