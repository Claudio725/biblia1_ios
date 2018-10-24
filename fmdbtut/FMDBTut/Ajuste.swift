//
//  Ajuste.swift
//  BibliaNVT
//
//  Created by MacBook Pro i7 on 20/01/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import Foundation
import UIKit

struct vetorFonte {
    var Nome : String!
}


class Ajuste {

    func botao (btn: UIButton) {
        //Botão capítulo anterior
        btn.layer.cornerRadius = 0.5 * btn.bounds.size.width
        btn.layer.borderColor = UIColor(red: 255/255, green: 246/255, blue: 211/255, alpha: 1.0) .cgColor as CGColor/* #fff6d3 */
        btn.layer.borderWidth = 2.0
        btn.clipsToBounds = true
    }
    
    func printFonts()->[vetorFonte]{
        var vetors: [vetorFonte]!
        
        for familyName in UIFont.familyNames {
            print("\n-- \(familyName) \n")
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                let vetor = vetorFonte(Nome: fontName)

                if vetors == nil {
                    vetors = [vetorFonte]()
                }
                
               if  fontName.range(of: "Brandon") != nil {
                    print("Brandon" + fontName)
                }
                print("fontName:",fontName)
                
                if (fontName == "Avenir-Light") ||
                    (fontName == "BrandonGrotesque-Black") ||
                    (fontName == "BrandonGrotesque-Medium") ||
                    (fontName == "BrandonGrotesque-Regular") ||
                    (fontName == "BrandonGrotesque-Light") ||
                    (fontName == "BrandonGrotesque-BlackItalic") ||
                    (fontName == "BrandonGrotesque-MediumItalic") ||
                    (fontName == "BrandonGrotesque-Bold") ||
                    (fontName == "BrandonGrotesque-BoldItalic") ||
                    (fontName == "BrandonGrotesque-RegularItalic") ||
                    (fontName == "Cochin") ||
                    (fontName == "CochinLTStd-Bold") ||
                    (fontName == "CochinLTStd") ||
                    (fontName == "Verdana") ||
                    (fontName == "Courier"){
                    vetors.append(vetor) }
            }
        }
        return vetors
    }
    
}
