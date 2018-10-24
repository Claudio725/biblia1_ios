//
//  CalendarCls.swift
//  BibliaNVT
//
//  Created by MacBook Pro i7 on 20/11/2017.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import Foundation

class CalendarCls {
    
    var mes  = ""
    var dia = ""
    var linkLeitura1  = ""
    var linkLeitura2  = ""
    
    
    init(mes: String,
    dia: String,
    linkLeitura1: String,
    linkLeitura2: String)
        
    {
        self.mes = mes
        self.dia = dia
        self.linkLeitura1 = linkLeitura1
        self.linkLeitura2 =  linkLeitura2
    }
    
    
}
