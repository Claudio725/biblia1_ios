//
//  Mensagem.swift
//  DesafioBRQ
//
//  Created by MacBook Pro i7 on 21/07/2018.
//  Copyright © 2018 CJSM. All rights reserved.
//

import UIKit

protocol Mensagem {}

extension Mensagem where Self: UIViewController {
    func mensagem( message: String) {
        let alertController = UIAlertController(title: "Bíblia NVT!",
                                    message: message,
                                    preferredStyle: .alert)
        
        present(alertController, animated: true, completion: nil)
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alertController.dismiss(animated: true, completion: nil)
        }
    }

}
