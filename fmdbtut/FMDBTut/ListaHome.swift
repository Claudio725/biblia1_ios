//
//  ListaHome.swift
//  BibliaNVT
//
//  Created by MacBook Pro i7 on 15/11/2017.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import Foundation
class ListaHome {
    var texto = ""
    var tipoLInha = ""
    var linkAgoraNao = ""
    var imagem = ""
    
    init(texto: String,
         tipoLinha: String,
         linkAgoraNao: String,
         imagem: String) {
        self.texto = texto
        self.tipoLInha = tipoLinha
        self.linkAgoraNao = linkAgoraNao
        self.imagem = imagem
    }
}
