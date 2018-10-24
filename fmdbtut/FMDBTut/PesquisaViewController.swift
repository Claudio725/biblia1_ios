//
//  PesquisaViewController.swift
//  FMDBTut
//
//  Created by MacBook Pro i7 on 27/12/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit
import Social
import MessageUI
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import Branch


// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension String {
    
    func encodeURIComponent() -> String? {
        let characterSet = NSMutableCharacterSet.urlQueryAllowed
        
        return self.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)
    }

}

class PesquisaViewController: UIViewController,UITextFieldDelegate,
    MFMailComposeViewControllerDelegate,FBSDKSharingDelegate,
    UIGestureRecognizerDelegate,
    UITableViewDataSource, UITableViewDelegate, Mensagem{


    var dict : [String : AnyObject]!
    
    @IBOutlet var nomeLivroTextField:UITextField!
    @IBOutlet var numeroCapituloTextField:UITextField!
    @IBOutlet var numeroVersiculoTextField:UITextField!
    @IBOutlet var termoQualquerTextField:UITextField!
    
    @IBOutlet var btnPesquisaChave: UIButton!
    @IBOutlet var btnChave: UIButton!
    
    //variável para entrada da palavra-chave
    @IBOutlet var palavraChave : UITextField!
    
    //variáveis para mostrar o texto e o nome do livro/capitulo/versiculo
    @IBOutlet var tituloVersiculoDoDia : UILabel!
    @IBOutlet var versiculoDoDia: UITextView!
    var livroCapituloVersiculo : String!
    var textoSomente: String!
    let cellSpacingHeight: CGFloat = 5
    
    //Variaveis para montar a classe CalendarCls
    var Calendario : [CalendarCls] = []
    //Montagem da classe Calendário com todos os meses, dias e versículos
    //a serem lidos
    var mesAno31: [String]! = ["01","02","03","04","05","06","07",
                               "08","09","10","11","12","13","14","15","16","17",
                               "18","19","20","21","22","23","24","25","26","27","28","29","30","31"]
    var mesAno30: [String]! = ["01","02","03","04","05","06","07",
                               "08","09","10","11","12","13","14","15","16","17",
                               "18","19","20","21","22","23","24","25","26","27","28","29","30"]
    
    var mesAnoFevBissexto: [String]! = ["01","02","03","04","05","06","07",
                                        "08","09","10","11","12","13","14","15","16","17",
                                        "18","19","20","21","22","23","24","25","26","27","28","29"]
    
    var mesAnoFev: [String]! = ["01","02","03","04","05","06","07",
                                "08","09","10","11","12","13","14","15","16","17",
                                "18","19","20","21","22","23","24","25","26","27","28"]
    
    var vetorSelecionado: [String]! = [""]
    
    //Vetores para alimentar os botões do Livro 1 e Livro 2 dentro da célula prototype (de cada dia)
    var vetorJanLivro1 : [String]! = ["Gn 1-2",
                                      "Gn 3-5",
                                      "Gn 6-8",
                                      "Gn 9-11",
                                      "Gn 12-14",
                                      "Gn 15-17",
                                      "Gn 18-19",
                                      "Gn 20-22",
                                      "Gn 23-24",
                                      "Gn 25-26",
                                      "Gn 27-28",
                                      "Gn 29-30",
                                      "Gn 31-32",
                                      "Gn 33-35",
                                      "Gn 36-37",
                                      "Gn 38-40",
                                      "Gn 41",
                                      "Gn 42-43",
                                      "Gn 44-45",
                                      "Gn 46-48",
                                      "Gn 49-50",
                                      "Êx 1-3",
                                      "Êx 4-6",
                                      "Êx 7-8",
                                      "Êx 9-10",
                                      "Êx 11-12",
                                      "Êx 13-15",
                                      "Êx 16-18",
                                      "Êx 19-21",
                                      "Êx 22-24",
                                      "Êx 25-26"
    ]
    var vetorJanLivro2 : [String]! = ["Mt 1",
                                      "Mt 2",
                                      "Mt 3",
                                      "Mt 4",
                                      "Mt 5.1-26",
                                      "Mt 5.27-48",
                                      "Mt 6",
                                      "Mt 7",
                                      "Mt 8",
                                      "Mt 9.1-17",
                                      "Mt 9.18-38",
                                      "Mt 10.1-23",
                                      "Mt 10.24-42",
                                      "Mt 11",
                                      "Mt 12.1-21",
                                      "Mt 12.22-50",
                                      "Mt 13.1-32",
                                      "Mt 13.33-58",
                                      "Mt 14.1-21",
                                      "Mt 14.22-36",
                                      "Mt 15.1-20",
                                      "Mt 15.21-39",
                                      "Mt 16",
                                      "Mt 17",
                                      "Mt 18.1-20",
                                      "Mt 18.21-35",
                                      "Mt 19.1-15",
                                      "Mt 19.16-30",
                                      "Mt 20.1-16",
                                      "Mt 20.17-34",
                                      "Mt 21.1-22"
    ]
    var vetorFevLivro1 : [String]! = ["Êx 27-28","Êx 29-30", "Êx 31-33", "Êx 34-36", "Êx 37-38",
                                      "Êx 39-40","Lv 1-3","Lv 4-6", "Lv 7-9", "Lv 10-12",
                                      "Lv 13","Lv 14","Lv 15-17","Lv 18-19","Lv 20-21",
                                      "Lv 22-23","Lv 24-25","Lv 26-27","Nm 1-2","Nm 3-4",
                                      "Nm 5-6","Nm 7","Nm 8-10","Nm 11-13","Nm 14-15",
                                      "Nm 16-17","Nm 18-20","Nm 21-24"]
    
    var vetorFevLivro2: [String]! = ["Mt 21.23-46","Mt 22.1-22","Mt 22.23-46","Mt 23.1-22","Mt 23.23-39",
                                     "Mt 24.1-22","Mt 24.23-51","Mt 25.1-30","Mt 25.31-46","Mt 26.1-30",
                                     "Mt 26.31-56","Mt 26.57-75","Mt 27.1-31","Mt 27.32-66","Mt 28",
                                     "Mc 1.1-20","Mc 1.21-45","Mc 2","Mc 3.1-19","Mc 3.20-35",
                                     "Mc 4.1-20","Mc 4.21-41","Mc 5.1-20","Mc 5.21-43","Mc 6.1-29",
                                     "Mc 6.30-56","Mc 7","Mc 8.1-21"
    ]
    
    var vetorMarLivro1 : [String]! = ["Nm 25-27","Nm 28-29","Nm 30-31","Nm 32-33","Nm 34-36",
                                      "Dt 1-2","Dt 3-4","Dt 5-7","Dt 8-10","Dt 11-13",
                                      "Dt 14-16","Dt 17-19","Dt 20-22","Dt 23-25","Dt 26-27",
                                      "Dt 28","Dt 29-30","Dt 31-32","Dt 33-34","Js 1-3",
                                      "Js 4-6","Js 7-8","Js 9-10","Js 11-13","Js 14-15",
                                      "Js 16-18","Js 19-20","Js 21-22","Js 23-24","Jz 1-2","Jz 3-5"
    ]
    
    var vetorMarLivro2 : [String]! = ["Mc 8.22-38","Mc 9.1-29","Mc 9.30-50","Mc 10.1-31","Mc 10.32-52",
                                      "Mc 11.1-19","Mc 11.20-33","Mc 12.1-27","Mc 12.28-44","Mc 13.1-13",
                                      "Mc 13.14-37","Mc 14.1-26","Mc 14.27-52","Mc 14.53-72","Mc 15.1-19",
                                      "Mc 15.20-47","Mc 16","Lc 1.1-25","Lc 1.26-56","Lc 1.57-80",
                                      "Lc 2.1-24","Lc 2.25-52","Lc 3","Lc 4.1-30","Lc 4.31-44",
                                      "Lc 5.1-16","Lc 5.17-39","Lc 6.1-26","Lc 6.27-49","Lc 7.1-35",
                                      "Lc 7.36-50"
    ]
    
    var vetorAbrLivro1 : [String]! = ["Jz 6-7","Jz 8-9","Jz 10-11","Jz 12-14","Jz 15-17",
                                      "Jz 18-19","Jz 20-21","Rt 1-4","1Sam 1-3","1Sam 4-6",
                                      "1Sam 7-9","1Sam 10-12","1Sam 13-14","1Sam 15-16","1Sam 17-18",
                                      "1Sam 19-21","1Sam 22-24","1Sam 25-26","1Sam 27-29","1Sam 30-31",
                                      "2Sm 1-3","2Sm 4-6","2Sm 7-9","2Sm 10-12","2Sm 13-14",
                                      "2Sm 15-16","2Sm 17-18","2Sm 19-20","2Sm 21-22","2Sm 23-24"
    ]
    
    var vetorAbrLivro2 : [String]! = ["Lc 8.1-21","Lc 8.22-56","Lc 9.1-36","Lc 9.37-62","Lc 10.1-24",
                                      "Lc 10.25-42","Lc 11.1-28","Lc 11.29-54","Lc 12.1-34","Lc 12.35-59",
                                      "Lc 13.1-21","Lc 13.22-35","Lc 14.1-24","Lc 14.25-35","Lc 15.1-10",
                                      "Lc 15.11-32","Lc 16.1-18","lc 16.19-31","Lc 17.1-19","Lc 17.20-37",
                                      "Lc 18.1-17","Lc 18.18-43","Lc 19.1-27","Lc 19.28-48","Lc 20.1-26",
                                      "Lc 20.27-47","Lc 21.1-19","Lc 21.20-38","Lc 22.1-30","Lc 22.31-53"
    ]
    
    var vetorMaiLivro1 : [String]! = ["1Rs 1-2","1Rs 3-5","1Rs 6-7","1Rs 8-9","1Rs 10-11",
                                      "1Rs 12-13","1Rs 14-15","1Rs 16-18","1Rs 19-20","1Rs 21-22",
                                      "2Rs 1-3","2Rs 4-5","2Rs 6-8","2Rs 9-11","2Rs 12-14",
                                      "2Rs 15-17","2Rs 18-19","2Rs 20-22","2Rs 23-25","1Cr 1-2",
                                      "1Cr 3-5","1Cr 6-7","1Cr 8-10","1Cr 11-13","1Cr 14-16",
                                      "1Cr 17-19","1Cr 20-22","1Cr 23-25","1Cr 26-27","1Cr 28-29",
                                      "2Cr 1-3"
    ]
    
    var vetorMaiLivro2 : [String]! = ["Lc 22.54-71","Lc 23.1-25","Lc 23.26-43","Lc 23.44-56","Lc 24.1-34",
                                      "Lc 24.35-53","Jo 1.1-28","Jo 1.29-51","Jo 2","Jo 3.1-21",
                                      "Jo 3.22-36","Jo 4.1-38","Jo 4.39-54","Jo 5.1-30","Jo 5.31-47",
                                      "Jo 6.1-21","Jo 6.22-59","Jo 6.60-71","Jo 7.1-36","Jo 7.37-53",
                                      "Jo 8.1-20","Jo 8.21-30","Jo 8.31-59","Jo 9.1-34","Jo 9.35-41",
                                      "Jo 10.1-21","Jo 10.22-42","Jo 11.1-16","Jo 11.17-44","Jo 11.45-57",
                                      "Jo 12.1-19"
    ]
    
    var vetorJunLivro1 : [String]! = ["2Cr 4-6","2Cr 7-9","2Cr 10-12","2Cr 13-16","2Cr 17-19",
                                      "2Cr 20-22","2Cr 23-25","2Cr 26-28","2Cr 29-31","2Cr 32-33",
                                      "2Cr 34-36","Ed 1-2","Ed 3-5","Ed 6-8","Ed 9-10",
                                      "Ne 1-3","Ne 4-6","Ne 7-8","Ne 9-11","Ne 12-13",
                                      "Et 1-3","Et 4-6","Et 7-10","Jó 1-3","Jó 4-6",
                                      "Jó 7-9","Jó 10-12","Jó 13-15","Jó 16-18","Jó 19-20"
    ]
    
    var vetorJunLivro2 : [String]! = ["Jo 12.20-50","Jo 13.1-17","Jo 13.18-38","Jo 14","Jo 15",
                                      "Jo 16.1-15","Jo 16.16-33","Jo 17","Jo 18.1-24","Jo 18.25-40",
                                      "Jo 19.1-27","Jo 19.28-42","Jo 20","Jo 21","At 1",
                                      "At 2.1-13","At 2.14-47","At 3","At 4.1-22","At 4.23-37",
                                      "At 5.1-16","At 5.17-42","At 6","At 7.1-19","At 7.20-43",
                                      "At 7.44-60","At 8.2-25","At 8.26-40","At 9.1-19","At 9.20-43"
    ]
    
    var vetorJulLivro1 : [String]! = ["Jó 21-22","Jó 23-25","Jó 26-28","Jó 29-30","Jó 31-32",
                                      "Jó 33-34","Jó 35-37","Jó 38-39","Jó 40-42","Sl 1-3",
                                      "Sl 4-6","Sl 7-9","Sl 10-12","Sl 13-16","Sl 17-18",
                                      "Sl 19-21","Sl 22-24","Sl 25-27","Sl 28-30","Sl 31-33",
                                      "Sl 34-35","Sl 36-37","Sl 38-40","Sl 41-43","Sl 44-46",
                                      "Sl 47-49","Sl 50-52","Sl 53-55","Sl 56-58","Sl 59-61","Sl 62-64"
    ]
    
    var vetorJulLivro2 : [String]! = ["At 10.1-33","At 10.34-48","At 11","At 12","At 13.1-12",
                                      "At 13.13-52","At 14","At 15.1-21","At 15.22-41","At 16.1-15",
                                      "At 16.16-40","At 17.1-15","At 17.16-34","At 18","At 19.1-22",
                                      "At 19.23-41","At 20.1-12","At 20.13-38","At 21.1-36","At 21.37-40",
                                      "At 22.1-30","At 23.1-11","At 23.12-35","At 24","At 25",
                                      "At 26","At 27.1-25","At 27.26-44","At 28.1-16","At 28.17-31","Rm 1"
    ]
    
    var vetorAgoLivro1: [String]!  = ["Sl 65-67","Sl 68-69","Sl 70-72","Sl 73-74","Sl 75-77",
                                      "Sl 78","Sl 79-81","Sl 82-84","Sl 85-87","Sl 88-89",
                                      "Sl 90-92","Sl 93-95","Sl 96-98","Sl 99-102","Sl 103-104",
                                      "Sl 105-106","Sl 107-108","Sl 109-111","Sl 112-115","Sl 116-118",
                                      "Sl 119.1-48","Sl 119.49-104","Sl 119.105-176","Sl 120-123","Sl 124-127",
                                      "Sl 128-131","Sl 132-135","Sl 136-138","Sl 139-141","Sl 142-144",
                                      "Sl 145-147"
    ]
    
    var vetorAgoLivro2 : [String]! = ["Rm 2","Rm 3","Rm 4","Rm 5","Rm 6",
                                      "Rm 7","Rm 8.1-17","Rm 8.18-39","Rm 9","Rm 10",
                                      "Rm 11.1-24","Rm 11.25-36","Rm 12","Rm 13","Rm 14",
                                      "Rm 15.1-22","Rm 15.23-33","Rm 16","1Co 1","1Co 2",
                                      "1Co 3","1Co 4","1Co 5","1Co 6 ","1Co 7.1-24 ",
                                      "1Co 7.25-40","1Co 8","1Co 9","1Co 10.1-13","1Co 10.14-33","1Co 11.1-16"
    ]
    
    var vetorSetLivro1 : [String]! = ["Sl 148-150","Pv 1-2","Pv 3-4","Pv 5-6","Pv 7-8",
                                      "Pv 9-10","Pv 11-12","Pv 13-14","Pv 15-16","Pv 17-18",
                                      "Pv 19-20","Pv 21-22","Pv 23-24","Pv 25-27","Pv 28-29",
                                      "Pv 30-31","Ec 1-3","Ec 4-6","Ec 7-9","Ec 10-12",
                                      "Ct 1-3","Ct 4-5","Ct 6-8","Is 1-3","Is 4-6",
                                      "Is 7-9","Is 10-12","Is 13-15","Is 16-18","Is 19-21"
    ]
    
    var vetorSetLivro2 : [String]! = ["1Co 11.17-34","1Co 12","1Co 13","1Co 14.1-19","1Co 14.20-40",
                                      "1Co 15.1-34","1Co 15.35-58","1Co 16","2Co 1","2Co 2",
                                      "2Co 3","2Co 4","2Co 5","2Co 6","2Co 7",
                                      "2Co 8","2Co 9","2Co 10","2Co 11.1-15","2Co 11.16-33",
                                      "2Co 12","2Co 13","Gl 1","Gl 2","Gl 3",
                                      "Gl 4","Gl 5","Gl 6","Ef 1","Ef 2"
    ]
    
    var vetorOutLivro1 : [String]! = ["Is 22-23","Is 24-26","Is 27-28","Is 29-30","Is 31-33",
                                      "Is 34-36","Is 37-38","Is 39-40","Is 41-42","Is 43-44",
                                      "Is 45-47","Is 48-49","Is 50-52","Is 53-55","Is 56-58",
                                      "Is 59-61","Is 62-64","Is 65-66","Jr 1-2","Jr 3-4",
                                      "Jr 5-6","Jr 7-8","Jr 9-10","Jr 11-13","Jr 14-16",
                                      "Jr 17-19","Jr 20-22","Jr 23-24","Jr 25-26","Jr 27-28","Jr 29-30"
    ]
    
    var vetorOutLivro2 : [String]! = ["Ef 3","Ef 4","Ef 5","Ef 6","Fp 1",
                                      "Fp 2","Fp 3","Fp 4","Cl 1","Cl 2",
                                      "Cl 3","Cl 4","1Ts 1","1Ts 2","1Ts 3",
                                      "1Ts 4","1Ts 5","2Ts 1","2Ts 2","2Ts 3",
                                      "1Tm 1","1Tm 2","1Tm 3","1Tm 4","1Tm 5",
                                      "1Tm 6","2Tm 1","2Tm 2","2Tm 3","2Tm 4","Tt 1"
    ]
    
    var vetorNovLivro1 : [String]! = ["Jr 31-32","Jr 33-35","Jr 36-37","Jr 38-39","Jr 40-42",
                                      "Jr 43-45","Jr 46-48","Jr 49-50","Jr 51-52","Lm 1-2",
                                      "Lm 3-5","Ez 1-3","Ez 4-6","Ez 7-9","Ez 10-12",
                                      "Ez 13-15","Ez 16","Ez 17-19","Ez 20-21","Ez 22-23",
                                      "Ez 24-26","Ez 27-28","Ez 29-31","Ez 32-33","Ez 34-35",
                                      "Ez 36-37","Ez 38-39","Ez 40","Ez 41-42","Ez 43-44"
    ]
    
    var vetorNovLivro2 : [String]! = ["Tt 2","Tt 3","Fm 1","Hb 1","Hb 2",
                                      "Hb 3","Hb 4","Hb 5","Hb 6","Hb 7",
                                      "Hb 8","Hb 9","Hb 10.1-18","Hb 10.19-39","Hb 11.1-19",
                                      "Hb 11.20-40","Hb 12","Hb 13","Tg 1","Tg 2",
                                      "Tg 3","Tg 4","Tg 5","1Pe 1","1Pe 2",
                                      "1Pe 3","1Pe 4","1Pe 5","2Pe 1","2Pe 2"
    ]
    
    var vetorDezLivro1 : [String]! = ["Ez 45-46","Ez 47-48","Dn 1-2","Dn 3-4","Dn 5-6",
                                      "Dn 7-8","Dn 9-10","Dn 11-12","Os 1-4","Os 5-8",
                                      "Os 9-11","Os 12-14","Jl 1-3","Am 1-3","Am 4-6",
                                      "Am 7-9","Ob 1","Jn 1-4","Mq 1-3","Mq 4-5",
                                      "Mq 6-7","Na 1-3","Hc 1-3","Sf 1-3","Ag 1-2",
                                      "Zc 1-3","Zc 4-6","Zc 7-9","Zc 10-12","Zc 13-14","Ml 1-4"
    ]
    
    var vetorDezLivro2 : [String]! = ["2Pe 3","1Jo 1","1Jo 2","1Jo 3","1Jo 4",
                                      "1Jo 5","2Jo 1","3Jo 2","Jd 1","Ap 1",
                                      "Ap 2","Ap 3","Ap 4","Ap 5","Ap 6",
                                      "Ap 7","Ap 8","Ap 9","Ap 10","Ap 11",
                                      "Ap 12","Ap 13","Ap 14","Ap 15","Ap 16",
                                      "Ap 17","Ap 18","Ap 19","Ap 20","Ap 21","Ap 22"
    ]
    
    
    
    //variavel para armazenar os valores da listaHome
    var linhaSelected: String! = ""
    var listaHome : [ListaHome] = []
    var textoLista: String!
    var tipoLinha: String = ""
    var linkAgoraNaoLista: String = ""
    var link2: String = ""
    var imagemLista: String = ""
    @IBOutlet var tblLista: UITableView!

    var selectedListaItem: Int!
    var marcacao: [VersosMarcados]!
    
    //outlets para os botões Facebook, Instagram e Email
    @IBOutlet var btnFace : UIButton!
    @IBOutlet var btnTwitter: UIButton!
    
    //outlet para o botão de compartilhar o versículo do dia
    @IBOutlet var btnShare : UIButton!
    @IBOutlet var btnMarcar: UIButton!
    
    var versos: [VersoInfo]!
    var sqlparcial : String!
    var versoFinal : [VersoInfo]!
    
    var moviesController:MoviesViewController!
    
    //Montagem do versículo do dia no Face
    var textoFormatadoTitulo : String! = ""
    var textoFormatadoVerso : String! = ""
    var textoFormatadoFinal : String! = ""
    var nome : String! = ""
    var capitulo: String! = ""
    var verso: Int32 = 0
    var livroT: String! = ""
    var livroTM: String! = ""
    var capituloM: String! = ""
    var versoM: Int32 = 0
    var textoP: String! = ""
    var livroP: String! = ""
    var capituloP: String! = ""
    var versoP: Int32 = 0
    
    var dia: String!
    var mes: String!
    var ano: String!
    var mesEscolhido : String! = ""
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Metodo para habilitar a tecla Enter realizar Pesquisa de Versículo - palavra-chave
        
        textField.resignFirstResponder()  //if desired
        pesquisarVersiculo()
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tabBarController?.tabBar.items![2].isEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //signupWithFacebook()

        // Remove the title of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //Se o item da tabbar de marcação estiver desabilitado entao abilita-lo.
        self.tabBarController?.tabBar.items![2].isEnabled = true

        
        //Esconder o teclado quando se tecla em qualquer parte da tela
        self.hideKeyboardWhenTappedAround()
        
        //Habilitar a tecla Enter para realizar a pesquisa
        palavraChave.enablesReturnKeyAutomatically = true
        self.palavraChave.delegate = self
        
        //Processo para verificar o versículo do dia
        //1 - Com o dia atual verificar na base VERSICULODIA se há registro com o campo DATADIA 
        //igual a data atual.
        var versiculo_existente: [VersiculoDoDia]!
        
        var dataDia : String!
        
        let date = NSDate()
        
        // *** Cria objeto calendário para trazer e formatar a data do dia ***
        let calendar = NSCalendar.current
        
        dia = String(calendar.component(.day, from: date as Date))
        mes = String(calendar.component(.month, from: date as Date))
        ano = String(calendar.component(.year, from: date as Date))
        
        //Data atual do sistema
        dataDia = dia + "/" + mes + "/" + ano
        
        versiculo_existente = DBManager.shared.Verificar_versiculo_dia(dataDia: dataDia)
        
        //2 - se não houver versículo cadastrado com esta data, então lê a tabela VERSICULOSDIA
        //com DATADIA = NULL e salva na base a primeira linha gravando a DATADIA com a data atual.
        var verso_aleatorio : [VersiculoDoDia]!
        var titulo : String
        
        if versiculo_existente.count == 0 {
            //Gera um verso aleatorio
            verso_aleatorio = DBManager.shared.Buscar_versiculo_dia_data_nula()

            //Atualiza VERSICULOSDIA
            DBManager.shared.atualizarrVersiculoDoDia(datadia: dataDia, versos: verso_aleatorio)
            let livroW: String! = verso_aleatorio[0].livro
            let capituloW : String! = verso_aleatorio[0].capitulo
            let versiculoW : String! = verso_aleatorio[0].versiculo
            
            //Traz o texto do versiculo
            //var versoFinal : [VersoInfo]!
            versoFinal = DBManager.shared.loadVersiculoDodia(livro: livroW, capitulo: capituloW, versiculo: versiculoW)
            
            //Mostra Titulo do livro, capitulo e versiculo
            livroT! = versoFinal[0].livroID
            titulo = versoFinal[0].name + " " +
                versoFinal[0].capitulo + ":" +
                versoFinal[0].verso
            
            //Guarda o nome,capitulo e verso para compartilhar no Face
            nome = versoFinal[0].name!
            capitulo = versoFinal[0].capitulo
            verso = Int32(String(versoFinal[0].verso!))!
            
            livroCapituloVersiculo = titulo
            textoSomente = versoFinal[0].text
            
            //Mostra o texto do versículo do dia - texto
            versiculoDoDia.text = "VERSÍCULO DO DIA\n\n" +
                versoFinal[0].text + "\n\n" +
                titulo
            
        
        } else {
            //Se houver o versiculo na base VERSICULOSDIA então ler o texto e mostrar
            let livroW: String! = versiculo_existente[0].livro
            let capituloW : String! = versiculo_existente[0].capitulo
            let versiculoW : String! = versiculo_existente[0].versiculo
            
            //var versoFinal : [VersoInfo]!
            versoFinal = DBManager.shared.loadVersiculoDodia(livro: livroW, capitulo: capituloW, versiculo: versiculoW)
            
            //Mostra Titulo do livro, capítulo e versiculo
            titulo = versoFinal[0].name! + " " + String(versoFinal[0].capitulo!) + ":" +
                String(versoFinal[0].verso!)
            
            //Guarda o nome,capitulo e verso para compartilhar no Face
            livroT! = versoFinal[0].livroID
            nome = versoFinal[0].name!
            capitulo = versoFinal[0].capitulo
            verso = Int32(String(versoFinal[0].verso!))!
            
            livroCapituloVersiculo = titulo
            textoSomente = versoFinal[0].text
            
            //Mostra o texto do versículo do dia - texto
            versiculoDoDia.text = "VERSÍCULO DO DIA\n\n" +
                versoFinal[0].text + "\n\n" +
                titulo

        }
        
        
        versiculoDoDia.backgroundColor = UIColor(red: 181/255, green: 167/255, blue: 68/255, alpha: 1.0) /* #b5a744 */
        
        //Back ground da tela
        view.self.backgroundColor = UIColor.colorWithHexString("#f4f4ee")

        versiculoDoDia.text = versiculoDoDia.text
        
        // Add tap gesture recognizer to Text View
//        let tap = UITapGestureRecognizer(target: self, action: #selector(myMethodToHandleTap(_:)))
//        tap.delegate = self
//        versiculoDoDia.addGestureRecognizer(tap)
        
        //Popular a classe Calendario com os links do Plano atual
        PopularClasseCalendario()
        
        //Montar o array da ListaHome com os valores do versiculo do Dia e das notificações
        //geradas pelo sistema
        listaHome = []
        //1 - Alimentar a lista com o versiculo do dia
        textoLista = versiculoDoDia.text
        
        tipoLinha = "VD" //versículo do dia
        linkAgoraNaoLista = "Agora Não"
        imagemLista = "app.png"
        
        listaHome.append( ListaHome(texto: textoLista!,
                                    tipoLinha: tipoLinha,
                                    linkAgoraNao: linkAgoraNaoLista,
                                    imagem: imagemLista))
        
        //2 - Verificar se tem alguma marcação
        //Carrega último versiculo marcado
        marcacao = DBManager.shared.loadMarcacao()
        tipoLinha = "VM" //versículo marcado
        if marcacao != nil {
            if marcacao.count > 0 {
                textoLista! = "VOCÊ TEM UM VERSÍCULO MARCADO!\n\n" +
                    marcacao[0].texto + "\n\n" +
                    marcacao[0].livroNome + " " +
                    marcacao[0].capítulo + ":" +
                    marcacao[0].verse
                
                
                livroTM! = marcacao[0].livroID
                capituloM = marcacao[0].capítulo
                versoM = Int32(String(marcacao[0].verse!))!
                
            listaHome.append( ListaHome(texto: textoLista!,
                    tipoLinha: tipoLinha,
                    linkAgoraNao: linkAgoraNaoLista,
                    imagem: imagemLista))
            }
        }
        
        //3 - Pesquisar na classe Calendario se há versículo para leitura do
        //plano atual de acordo com o ano, mes e dia do calendário atual
        for i in stride(from: 0, to: Calendario.count, by: 1) {
            
            if ( Calendario[i].mes == mes && Calendario[i].dia == dia ){
                textoLista! = "LEITURA DO DIA - PLANO ATUAL\n\n" +
                    Calendario[i].linkLeitura1  + "  " +
                    Calendario[i].linkLeitura2
                tipoLinha = "VP"
                linkAgoraNaoLista = Calendario[i].linkLeitura1
                link2 = Calendario[i].linkLeitura2
             
                
                listaHome.append( ListaHome(texto: textoLista!,
                                            tipoLinha: tipoLinha,
                                            linkAgoraNao: linkAgoraNaoLista +
                                            " " + link2,
                                            imagem: imagemLista))
                
            }
        }
        
        //4 - Link de notícias da Mundo Cristão
//        listaHome.append(ListaHome(texto:
//            "Notícias da Mundo Cristão",
//                         tipoLinha: "NEWS",
//                         linkAgoraNao: linkAgoraNaoLista,
//                         imagem: imagemLista))

        
        // Enable Self Sizing Cells
        tblLista.estimatedRowHeight = 120.0
        tblLista.rowHeight = UITableViewAutomaticDimension
        
        self.tblLista.delegate = self
        self.tblLista.dataSource = self
        self.tblLista.allowsSelectionDuringEditing = true;
        
        tblLista.backgroundColor = UIColor.colorWithHexString("#f4f4ee")

    }
    
    @IBAction func Compartilhar(sender: UIButton) {
        var versiculo_marcado : String = ""
        if let cell = sender.superview?.superview as? ListaHomeTableViewCell {
            let indexPath = tblLista.indexPath(for: cell)
            
            versiculo_marcado = listaHome[(indexPath?.row)!].texto +
                "\n\nBíblia Sagrada, Nova Versão Transformadora\n" +
                "Copyright © 2016 por Editora Mundo Cristão.\n" +
            "Todos os direitos reservados.\n"
            let vc = UIActivityViewController(activityItems: [versiculo_marcado],
                                              applicationActivities: nil)
            vc.popoverPresentationController?.sourceView = self.view
            vc.excludedActivityTypes = [ UIActivityType.airDrop]
            self.present(vc, animated: true, completion: nil)
            
        }
    }
    
    @objc func myMethodToHandleTap(_ sender: UITapGestureRecognizer) {
        MostraLeitura()
        
    }
    
    //Fazer o botao circular
    func configureButton()
    {
        
        versiculoDoDia.layer.cornerRadius = 0.05 * versiculoDoDia.bounds.size.width
        versiculoDoDia.layer.borderColor = UIColor(red: 255/255, green: 246/255, blue: 211/255, alpha: 1.0) .cgColor as CGColor/* #fff6d3 */
        versiculoDoDia.layer.borderWidth = 2.0
        versiculoDoDia.clipsToBounds = true
    }
    
    //Método para posicionar o textView de acordo com o Versículo selecionado
    override func viewDidLayoutSubviews() {
        //Configurar os labels titulo versiculo e livro capitulo
        configureButton()
        let contentSize = self.versiculoDoDia.sizeThatFits(self.versiculoDoDia.bounds.size)
        var frame = self.versiculoDoDia.frame
        frame.size.height = contentSize.height
        self.versiculoDoDia.frame = frame
        
        let aspectRatioTextViewConstraint = NSLayoutConstraint(item: self.versiculoDoDia, attribute: .height, relatedBy: .equal, toItem: self.versiculoDoDia, attribute: .width, multiplier: versiculoDoDia.bounds.height/versiculoDoDia.bounds.width, constant: 1)
        self.versiculoDoDia.addConstraint(aspectRatioTextViewConstraint)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Action para pesquisar os versiculos de uma determinada palavra-chave no botão da lupa
    @IBAction func pesquisarVersiculo() {
        //Validaçao da tela e montagem da cláusula do sql
        if palavraChave.text != nil && palavraChave.text != " " && palavraChave.text != "" {
            sqlparcial = "AND BI.TEXT LIKE \'%" + palavraChave.text! + "%\'"
            performSegue(withIdentifier: "showVersiculo", sender: self)
        } else {
            let alert = UIAlertController(title: "Bíblia NVT!", message: "Digite a palavra desejada.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (_)in
            })
            
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func MostraLeitura() {
        self.performSegue(withIdentifier: "listaHome", sender: self)
    }
    
    
    //Action para passar o sql de pesquisa de livros
    @IBAction func MostrarLivros() {
        sqlparcial = "select BOOK_NAME as name from books;"
    }

    // Criaçao do segue para passar dados para a proxima tela
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVersiculo" {
            if palavraChave.text != nil && palavraChave.text != " " && palavraChave.text != "" {
                let moviesViewController = segue.destination as! MoviesViewController
                moviesViewController.queryComplemento = palavraChave.text!
            }
        }
        if segue.identifier == "showLivros" {
            MostrarLivros()
            let livrosViewController = segue.destination as! ListaLivrosViewController
            livrosViewController.query = ""
        }
        if segue.identifier == "mcnoticias" {
            linhaSelected = "news"
        }

        print(segue.identifier as Any)
        
        if linhaSelected != "VP" {
            if (segue.identifier == "listaV") {
                if linhaSelected == "VM" {
                    let leituraViewController = segue.destination as! ListaVersiculoViewController
                    leituraViewController.livroID = livroTM!
                    leituraViewController.versiculo1 = versoM
                    leituraViewController.capitulo = capituloM
                    leituraViewController.textoCompletoVersiculoDia = marcacao[0].texto
                }
                if linhaSelected == "VD" {
                    let leituraViewController = segue.destination as! ListaVersiculoViewController
                    leituraViewController.livroID = livroT!
                    leituraViewController.versiculo1 = verso
                    leituraViewController.capitulo = capitulo
                    leituraViewController.textoCompletoVersiculoDia = textoSomente
                }
            }
        }
        if (linhaSelected == "VP") {
            if (segue.identifier == "listaPA2") {
                var mesPP1 : String = ""
                let MesViewController =
                    segue.destination as! PlanoLeituraMensalViewController
                guard let mesPP = sender as? String else { return }
                MesViewController.mes = mesPP
                print (mesPP)
                MesViewController.diaEscolhido = dia
                if (mesPP.count == 1) {
                    mesPP1 = "0" + mesPP
                    MesViewController.nomeMes = obtemMesExtenso(mes_param: mesPP1)
                }
                else {
                MesViewController.nomeMes = obtemMesExtenso(mes_param: mesPP)
                }
            }
        }
        
    }
    
    //Action para mostrar o campo para entrar a palavra-chave
    @IBAction func mostrarCampoChave() {
        if  palavraChave.isHidden == false {
            btnPesquisaChave.isHidden = true
            palavraChave.isHidden = true
        } else {
            btnPesquisaChave.isHidden = false
            palavraChave.isHidden = false
        }
    }
    
    
    //Este método serve para compartilhar o versículo do dia para o Twitter
    @IBAction func Twitter () {
        
        //Tratamento do Texto do Twitter para mostrar somente 140 caracteres
        var textoFormatadoFinal : String! = ""
        var totcaracteres : Int!
        
        var textoTratado: String! = //self.livroCapituloVersiculo + " - NVT \n"
                textoSomente
        totcaracteres = textoTratado.count
        if totcaracteres >= 137 {
            totcaracteres = 112
        }
        
        textoTratado = textoTratado.substring(to: totcaracteres) + "..."
        
        textoFormatadoFinal! =   textoTratado!
        
        let qString: String! = "?a=" + livroT! + "&b=" + capitulo! + ":" +
            String(verso)
        
        let branchUniversalObject = BranchUniversalObject(canonicalIdentifier: UUID().uuidString)
        branchUniversalObject.title = self.livroCapituloVersiculo! + " - NVT"
        branchUniversalObject.contentDescription = textoFormatadoFinal!
        branchUniversalObject.addMetadataKey("qstring", value: qString!)
        
        let linkProperties: BranchLinkProperties = BranchLinkProperties()
        linkProperties.feature = "share"
        linkProperties.channel = "twitter"
        //linkProperties.addControlParam("$desktop_url", withValue: "biblianvt://"+qString)
        linkProperties.addControlParam("$deeplink_path", withValue: qString)
        linkProperties.addControlParam("$always_deeplink", withValue: "false")
        linkProperties.addControlParam("$ios_deepview", withValue: "default_template")
        linkProperties.addControlParam("$android_deepview", withValue: "default_template")
        
        branchUniversalObject.showShareSheet(with: linkProperties,
                                                     andShareText: textoFormatadoFinal!,
                                                     from: self) { (activityType, completed) in
                                                    NSLog("compartilhado!")
            if (completed) {
                print(String(format: "Completed sharing to %@", activityType!))
            } else {
                print("Link sharing cancelled")
            }
        }
    }
    
    func montarTextoCompartilhamento() {
        
    }

    @IBAction func sharedSDK() {
        //Montagem do versículo do dia no Face
        var textoFormatadoVerso : String! = ""
        var textoFormatadoFinal : String! = ""
        
        textoFormatadoVerso! = textoSomente  + " " +
        "Bíblia Sagrada, Nova Versão Transformadora\n"
        textoFormatadoVerso! +=
            "Copyright © 2016 por Editora Mundo Cristão.\n" +
        "Todos os direitos reservados."
        
        textoFormatadoFinal! = textoFormatadoVerso!

        let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
        
        let qString: String! = "?a=" + livroT! + "&b=" + capitulo! + ":" +
            String(verso)
        let urlString : String! = "https://fb.me/682225125281613" + qString
        
        content.contentURL = NSURL(string: urlString) as URL?
        
        let branchUniversalObject: BranchUniversalObject = BranchUniversalObject(canonicalIdentifier: urlString)
        branchUniversalObject.title = self.livroCapituloVersiculo! + " - NVT"
        branchUniversalObject.contentDescription = textoFormatadoFinal!
         branchUniversalObject.addMetadataKey("qstring", value: qString!)
        
        let linkProperties: BranchLinkProperties = BranchLinkProperties()
        linkProperties.feature = "share"
        linkProperties.channel = "twitter"
        linkProperties.addControlParam("$deeplink_path", withValue: qString)
        branchUniversalObject.getShortUrl(with: linkProperties) { (url, error) in
            if error == nil {
                print("got my Branch link to share: %@", url!)
                content.contentURL = NSURL(string: url!) as URL? //NSURL(string: urlString) as URL!
            }
        }


        content.contentTitle = self.livroCapituloVersiculo!
        content.contentDescription = textoFormatadoFinal!
        
        let dialog : FBSDKShareDialog = FBSDKShareDialog()
        dialog.fromViewController = self
        dialog.shareContent = content
        let facebookURL = NSURL(string: "fbauth2://app")
        if(UIApplication.shared.canOpenURL(facebookURL! as URL)){
            dialog.mode = FBSDKShareDialogMode.feedWeb
        }else{
            dialog.mode = FBSDKShareDialogMode.native
        }
        dialog.delegate = self
        dialog.show()
        
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        print(error)
    }
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print(results.debugDescription)
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print(sharer.debugDescription as Any)
    }
    
    //
    //MARK: sign in with facebook
    
    //Compartilha o link gerado pelo Branch no Facebook
    @IBAction func shareFace () {
        //Montagem do versículo do dia no Face
        var textoFormatadoFinal : String! = ""

        var totcaracteres : Int! = 0
        
        var textoTratado: String! = //self.livroCapituloVersiculo + "\n" +
                textoSomente
        //Tramento para Twitter
        totcaracteres = textoTratado.count
        if totcaracteres >= 137 {
            totcaracteres = 112
        }
        
        textoTratado = textoTratado.substring(to: totcaracteres) + "..."
        
        textoFormatadoFinal =   textoTratado!
        
        let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
        
        let qString: String! = "?a=" + livroT! + "&b=" + capitulo! + ":" +
            String(verso)
        
        content.contentTitle = self.livroCapituloVersiculo + " - NVT"
        content.contentDescription = textoFormatadoFinal!
        
        let branchUniversalObject = BranchUniversalObject(canonicalIdentifier: UUID().uuidString)
        branchUniversalObject.title = self.livroCapituloVersiculo! + " - NVT"
        branchUniversalObject.contentDescription = textoFormatadoFinal!
        branchUniversalObject.addMetadataKey("qstring", value: qString!)
        branchUniversalObject.listOnSpotlight()
        

        let linkProperties: BranchLinkProperties = BranchLinkProperties()
        linkProperties.feature = "sharing"
        linkProperties.channel = "facebook"
        //linkProperties.addControlParam("$desktop_url", withValue: "biblianvt://"+qString)
        linkProperties.addControlParam("$deeplink_path", withValue:  qString)
        linkProperties.addControlParam("$always_deeplink", withValue: "false")
        linkProperties.addControlParam("$ios_deepview", withValue: "default_template")
        linkProperties.addControlParam("$android_deepview", withValue: "default_template")
        
        branchUniversalObject.showShareSheet(with: linkProperties,
                                             andShareText: textoFormatadoFinal!,
                                             from: self) { (activityType, completed) in
                                            NSLog("compartilhado!")
        if (completed) {
            print(String(format: "Completed sharing to %@", activityType!))
        } else {
            print("Link sharing cancelled")
                                                }
        }
        
    }

    //Métodos para preencher a tblHome
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! ListaHomeTableViewCell
        
        //Configurar a cell
        cell.imagemLista.image? = UIImage(named: listaHome[indexPath.section].imagem)!
        cell.textoLista.text = listaHome[indexPath.section].texto
        cell.textoLista.font = UIFont(name: "BrandonGrotesque-Bold", size: 16)
        cell.textoLista.font = UIFont.boldSystemFont(ofSize: 16)
        cell.textoLista.backgroundColor = UIColor.colorWithHexString("#f4f4ee")
        cell.tipoLinha.text = listaHome[indexPath.section].tipoLInha
        
        // Rounded corners
        cell.backgroundColor = UIColor.colorWithHexString("#f4f4ee")
//        cell.layer.borderColor = UIColor.black.cgColor
//        cell.layer.borderWidth = 1
//        cell.layer.cornerRadius = 18
//        cell.clipsToBounds = true
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return self.listaHome.count
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        linhaSelected = listaHome[indexPath.section].tipoLInha
        if (linhaSelected == "VP") {
            self.performSegue(withIdentifier: "listaPA2", sender: self.mes)
        }
        if (linhaSelected == "VM") {
            self.performSegue(withIdentifier: "listaV", sender: self.mes)
        }
        if (linhaSelected == "VD") {
            self.performSegue(withIdentifier: "listaV", sender: self.mes)
        }
        if (linhaSelected == "NEWS") {
            self.performSegue(withIdentifier: "mcnoticias", sender: nil)
            
        }
        print(linhaSelected)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        linhaSelected = listaHome[indexPath.section].tipoLInha

        return indexPath
    }

    func PopularClasseCalendario() {
        var anoCalendar = 0
        let date = NSDate()
        var linkLeitura = ""
        var linkLeitura2 = ""

        // *** Cria objeto calendário para trazer o ano do calendário ***
        let calendar = NSCalendar.current

        anoCalendar = calendar.component(.year, from: date as Date)-1
        
        //1 - Percorre o contador de meses.
        for mesP in stride(from: 1, to: 12+1, by: 1) {
            var diasP = 31
            
            switch( String(mesP) )
            {
            //meses que possuem 30 dias: só subtraímos 1 dia
            case "4":
                diasP -= 1
                vetorSelecionado = mesAno30
            case "6":
                diasP -= 1
                vetorSelecionado = mesAno30
            case "9":
                diasP -= 1
                vetorSelecionado = mesAno30
            case "11":
                diasP -= 1
                vetorSelecionado = mesAno30
            default:
                if (mesP != 2) {
                    vetorSelecionado = mesAno31
                }
            }
            
            //Se for bissexto e o mes fevereiro selecionar o mesFev Bissexto
            if (anoCalendar % 4) == 0 && mesP == 2 {
                vetorSelecionado = mesAnoFevBissexto
                diasP -= 2
            } else {
                if (mesP == 2) {
                    diasP -= 3
                    vetorSelecionado = mesAnoFev
                }
            }
            
            //2- Percorre todos dias do mes
            for diaP  in stride(from: 1, to: diasP+1, by: 1) {
                //Este vetor servirá para pesquisar qual versículo do plano atual será exibido
                //na tela home.
                switch( String(mesP) )
                {
                case "1":
                    linkLeitura = vetorJanLivro1[diaP-1]
                    linkLeitura2 = vetorJanLivro2[diaP-1]
                    
                case "2":
                    linkLeitura =  vetorFevLivro1[diaP-1]
                    linkLeitura2 = vetorFevLivro2[diaP-1]
                    
                case "3":
                    linkLeitura = vetorMarLivro1[diaP-1]
                    linkLeitura2 = vetorMarLivro2[diaP-1]
                    
                case "4":
                    linkLeitura = vetorAbrLivro1[diaP-1]
                    linkLeitura2 = vetorAbrLivro2[diaP-1]
                    
                case "5":
                    linkLeitura = vetorMaiLivro1[diaP-1]
                    linkLeitura2 = vetorMaiLivro2[diaP-1]
                    
                case "6":
                    linkLeitura = vetorJunLivro1[diaP-1]
                    linkLeitura2 = vetorJunLivro2[diaP-1]
                    
                case "7":
                    linkLeitura = vetorJulLivro1[diaP-1]
                    linkLeitura2 = vetorJulLivro2[diaP-1]
                    
                case "8":
                    linkLeitura = vetorAgoLivro1[diaP-1]
                    linkLeitura2 = vetorAgoLivro2[diaP-1]
                    
                case "9":
                    linkLeitura = vetorSetLivro1[diaP-1]
                    linkLeitura = vetorSetLivro2[diaP-1]
                    
                case "10":
                    linkLeitura = vetorOutLivro1[diaP-1]
                    linkLeitura2 = vetorOutLivro2[diaP-1]
                    
                case "11":
                    linkLeitura = vetorNovLivro1[diaP-1]
                    linkLeitura2 = vetorNovLivro2[diaP-1]
                    
                case "12":
                    linkLeitura = vetorDezLivro1[diaP-1]
                    linkLeitura2 = vetorDezLivro2[diaP-1]
                    
                default:
                    linkLeitura = vetorJanLivro1[diaP-1]
                    linkLeitura2 = vetorJanLivro2[diaP-1]
                }
                
                //Guarda na classe o mes, dia, versículos para link
                Calendario.append(CalendarCls( mes:  String(mesP),
                                             dia:  String(diaP),
                                             linkLeitura1:  linkLeitura,
                                             linkLeitura2:  linkLeitura2
                                        )
                                    )
            }
        }

    }

    func obtemMesExtenso(mes_param: String)->String {
        switch mes_param {
            case "01":
                mesEscolhido = "JANEIRO"
            case "02":
                mesEscolhido = "FEVEREIRO"
            case "03":
                mesEscolhido = "MARÇO"
            case "04":
                mesEscolhido = "ABRIL"
            case "05":
                mesEscolhido = "MAIO"
            case "06":
                mesEscolhido = "JUNHO"
            case "07":
                mesEscolhido = "JULHO"
            case "08":
                mesEscolhido = "AGOSTO"
            case "09":
                mesEscolhido = "SETEMBRO"
            case "10":
                mesEscolhido = "OUTUBRO"
            case "11":
                mesEscolhido = "NOVEMBRO"
            case "12":
                mesEscolhido = "DEZEMBRO"
            default:
                mesEscolhido = "JANEIRO"
        }
        return mesEscolhido
    }
    
    @IBAction func CopiarVesiculo(sender: UIButton) {
        var versiculo_marcado : String = ""
        if let cell = sender.superview?.superview as? ListaHomeTableViewCell {
            let indexPath = tblLista.indexPath(for: cell)
            
            versiculo_marcado = listaHome[(indexPath?.row)!].texto +
                "\n\nBíblia Sagrada, Nova Versão Transformadora\n" +
                "Copyright © 2016 por Editora Mundo Cristão.\n" +
            "Todos os direitos reservados.\n"

            UIPasteboard.general.string  = versiculo_marcado
            versiculo_marcado = ""
            mensagem(message: "Versículo copiado(s)!")
        
            
        }
    }
    
}
