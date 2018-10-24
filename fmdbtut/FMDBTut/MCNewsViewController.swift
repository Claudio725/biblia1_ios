//
//  ViewController.swift
//  BibliaNVT
//
//  Created by MacBook Pro i7 on 30/04/2018.
//  Copyright © 2018 Appcoda. All rights reserved.
//

import UIKit
import WebKit

class MCNewsViewController: UIViewController,WKNavigationDelegate, WKUIDelegate {
    
    var ww: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view
        
        ww.load(URLRequest(url: URL(string: "http://mundocristao.com.br/Vitrine/UserInterface/Busca.aspx?tipoBusca=CategoriaConteudo&pesquisa=Not%C3%ADcias&idBusca=1")!))
        
    }
    
    
    override func loadView() {
        super.loadView()
        ww = WKWebView()
        self.ww.navigationDelegate = self
        view = ww
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}
