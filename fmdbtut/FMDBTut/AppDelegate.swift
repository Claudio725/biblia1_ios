//
//  AppDelegate.swift
//  FMDBTut
//
//  Created by Gabriel Theodoropoulos on 04/10/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit
import Branch
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import FBSDKCoreKit.FBSDKSettings
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,FBSDKAppInviteDialogDelegate  {

    var window: UIWindow?
    var livroID: String! = nil
    var capitulo: String! = ""
    var versiculo1: Int32! = 0
    let defaults = UserDefaults.standard
    var urlLida: NSURL!

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Configurações de Notificações: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async(execute: {
                UIApplication.shared.registerForRemoteNotifications()
            })
        }
    }

    //Cor laranja no uinavigation
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Pedir permissão para fazer Notificações
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            
            print("Permissão concedida: \(granted)")
            self.getNotificationSettings()
            
        }
        
        //Cor da barra de navegaçao superior
        UINavigationBar.appearance().barTintColor = UIColor.colorWithHexString("#f4f4ee")
        let image = UIImage(named: "aberturanova.png") as UIImage?
        UINavigationBar.appearance().setBackgroundImage(image,
                                                        for: .default)
        
        //Cores de todos itens na navigation bar
        UINavigationBar.appearance().tintColor = UIColor.white
        
        //Alterar a aparencia da Status bar
        UINavigationBar.appearance().barStyle = .blackOpaque
        //UIApplication.shared.statusBarStyle = .lightContent
    
        //Cores da barra inferior e seus itens
        UITabBar.appearance().isTranslucent = false
        //UITabBar.appearance().barTintColor = UIColor.colorWithHexString("#9c9c9c") //background cinza
        UITabBar.appearance().tintColor = UIColor.white //cor dos itens em branco
        let recentsItemImage = UIImage(named:"aberturanova.png")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        UITabBar.appearance().backgroundImage = recentsItemImage
        UITabBar.appearance().clipsToBounds = true


        //Fonte negrito do titulo da barra de navegaçao
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17)
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs
        
        //Copia o banco para a área que pode ser gravavel
        DBManager.shared.copyFile(fileName: "BIBLIA_NVT_AJUSTADO.sqlite")
        
 
        // Override point for customization after application launch.

        //if (launchOptions?[.url] as? NSURL) != nil  {
        if (launchOptions != nil) {
            var nUrl : String!
            var url : NSURL!
            var flag: Bool = false
            
            nUrl  = "biblianvt://"
            
//            let sourceApp: String! = launchOptions?[UIApplicationLaunchOptionsKey.sourceApplication] as? String
//            let annotation: AnyObject! = launchOptions?[UIApplicationLaunchOptionsKey.annotation] as? AnyObject
            
            let branch: Branch = Branch.getInstance()
            
            branch.initSession(launchOptions: ((launchOptions! as NSDictionary) as! [AnyHashable : Any]), automaticallyDisplayDeepLinkController: true, deepLinkHandler: { params, error in
                branch.setIdentity("111111")
                
                if error == nil {                    
                    if (flag == false) && (params!["$deeplink_path"] != nil) {
                        nUrl  = nUrl +  String(describing: params!["$deeplink_path"]) as String
                        nUrl = nUrl.replacingOccurrences(of: "Optional(", with: "", options: NSString.CompareOptions.literal, range:nil)
                        nUrl = nUrl.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range:nil)
                        url = NSURL(string: nUrl)
                        flag = true
                        
                        //Tratamento da url para passar o livroId, o capítulo e o versiculo para o controller desejado.
                        if (url.query != nil) {
                            let queryKeyValue = url!.query!.components(separatedBy: "&")
                            
                            for (index,element) in queryKeyValue.enumerated() {
                                var kv = element.components(separatedBy: "=")
                                if(kv.count > 1) {
                                    if index == 0 {
                                        let livro = kv[1].components(separatedBy: "=")
                                        self.livroID = livro[0]
                                    }
                                    if index == 1 {
                                        let capituloOriginal = kv[1].components(separatedBy: ":")
                                        self.capitulo = capituloOriginal[0]
                                        self.versiculo1 = Int32(capituloOriginal[1])
                                    }
                                }
                            }
                            //Procura o ID do livro - parametro nome
                            //var livroInf: [LivrosInfo]!
                            //let complSql : String = "where BOOK_NAME = '" + livroID + "';"
                            //livroInf = DBManager.shared.loadLivros(complSql: complSql)
                            
                            if (self.livroID != nil) && (self.capitulo != nil) && (self.versiculo1 != nil) {
                                
                                let rootTabBarController = self.window?.rootViewController as! UITabBarController
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                
                                let firstNavigationController:UINavigationController! = storyboard.instantiateViewController(withIdentifier:"navigate") as? UINavigationController
                                
                                rootTabBarController.viewControllers![0] = firstNavigationController
                                
                                //the viewController to present
                                let viewController:ListaVersiculoViewController! = storyboard.instantiateViewController(withIdentifier:"ListaVersos") as? ListaVersiculoViewController
                                
                                //set variables in viewController
                                firstNavigationController.pushViewController(viewController, animated: true)

                                viewController.livroID = self.livroID!  //livroInf[0].livroID
                                viewController.capitulo = self.capitulo
                                viewController.versiculo1 = self.versiculo1
                                
                                // Highlight
                                //                        let conteudoControle : String = (viewController.textView?.text)!
                                //                        viewController.textView?.text = String(describing: self.generateAttributedString(with: params!["$og_description"] as! String,
                                //                            targetString: conteudoControle) )
                            }
                        }
                    }
                }
            })

            FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        return true
    }
    

    //func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    //}

    //func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //}

    //func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    //}

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if DBManager.shared.createDatabase() {
            //DBManager.shared.insertMovieData()
        }
        
    }
    
    
    func alerta(campo: String) {
        let alert:UIAlertController! = UIAlertController(title: "Biblia NVT", message: campo, preferredStyle: .alert)
        let ok:UIAlertAction! = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(ok)
        
        window?.rootViewController?.present(alert, animated: true, completion:nil)
    }
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        // pass the url to the handle deep link call
        Branch.getInstance().continue(userActivity);
        return true
    }


    //private func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData!) {
    //}
    
    
    //func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    //    return true
    //}
    
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
    }
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
    }
    
    func generateAttributedString(with searchTerm: String, targetString: String) -> NSAttributedString? {
        let attributedString = NSMutableAttributedString(string: targetString)
        do {
            let regex = try NSRegularExpression(pattern: searchTerm, options: .caseInsensitive)
            let range = NSRange(location: 0, length: targetString.utf16.count)
            for match in regex.matches(in: targetString, options: .withTransparentBounds, range: range) {
                attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold), range: match.range)
            }
            return attributedString
        } catch _ {
            NSLog("Error creating regular expresion")
            return nil
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }


}
