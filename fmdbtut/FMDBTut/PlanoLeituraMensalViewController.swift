//
//  PlanoLeituraMensalViewController.swift
//  BibliaNVT
//
//  Created by MacBook Pro i7 on 06/02/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit

class PlanoLeituraMensalViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    // declare bool
    var unchecked:Bool = true
    
    //Outlet para tratar a table view de dias
    @IBOutlet weak var tblDia: UITableView!
    
    //Variaveis para serem passadas para a proxima tela
    var Livro: String!
    var capitulo1: String!
    var capitulo2: String!
    var versiculo1: String!
    var versiculo2: String!
    
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
    
    //Mes escolhido no controller de meses - Numerico
    var mes: String!
    //Mes escolhido no controller de meses - nome dos meses
    var nomeMes: String!
    //Dia escolhido
    var diaEscolhido: String!
    
    //Outlet para mostrar o mês selecionado no label superior
    @IBOutlet var LblMesSelecionado : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var anoCalendar = 0
        var dias = 31
        
        let date = NSDate()
        
        // *** Cria objeto calendário para trazer o ano do calendário ***
        let calendar = NSCalendar.current
        anoCalendar = calendar.component(.year, from: date as Date)
        
        //Se for bissexto e o mes fevereiro selecionar o mesFev Bissexto
        if (anoCalendar % 4) == 0 && mes == "02"{
            vetorSelecionado = mesAnoFevBissexto
        } else {
            if (mes == "02") {
                vetorSelecionado = mesAnoFev
            }
        }

        switch( mes )
        {
            
        //meses que possuem 30 dias: só subtraímos 1 dia
        case "04":
            dias -= 1
            vetorSelecionado = mesAno30
        case "06":
            dias -= 1
            vetorSelecionado = mesAno30
        case "09":
            dias -= 1
            vetorSelecionado = mesAno30
        case "11":
            dias -= 1
            vetorSelecionado = mesAno30
        case "4":
            dias -= 1
            vetorSelecionado = mesAno30
        case "6":
            dias -= 1
            vetorSelecionado = mesAno30
        case "9":
            dias -= 1
            vetorSelecionado = mesAno30
        default:
            if (mes != "02") {
            vetorSelecionado = mesAno31
            }
        }
        
        
        //Remove o título na seta de volta da navegação
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        //Back ground da tela
        view.self.backgroundColor = UIColor.colorWithHexString("#f4f4ee")
        
        //Posicionar no dia selecionado
        if (diaEscolhido != nil) {
            let indexPath = NSIndexPath(item: Int(diaEscolhido)!, section: 0)
            tblDia.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.middle, animated: true)
        }
        
        title = nomeMes

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vetorSelecionado.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PlanoLeituraTableViewCell
        
        //Configurar a célula
        //cell.textLabel?.text = vetorSelecionado[indexPath.row]
        cell.numDia.text = vetorSelecionado[indexPath.row]
        cell.btnCheckBox.setImage(UIImage(named:"Unchecked_25.png"), for: .normal)
        
        //Este vetor montará os botões de acordo com o mês selecionado
        if (mes.count == 1)
        {
            mes = "0" + mes
        }
        print ("indexPath.row", indexPath.row)
        
        switch( mes )
        {
            
        case "01":
            cell.btnLivro1.setTitle(vetorJanLivro1[indexPath.row], for: .normal)
            cell.btnLivro2.setTitle(vetorJanLivro2[indexPath.row], for: .normal)
        case "02":
            cell.btnLivro1.setTitle(vetorFevLivro1[indexPath.row], for: .normal)
            cell.btnLivro2.setTitle(vetorFevLivro2[indexPath.row], for: .normal)
        case "03":
            cell.btnLivro1.setTitle(vetorMarLivro1[indexPath.row], for: .normal)
            cell.btnLivro2.setTitle(vetorMarLivro2[indexPath.row], for: .normal)
        case "04":
            cell.btnLivro1.setTitle(vetorAbrLivro1[indexPath.row], for: .normal)
            cell.btnLivro2.setTitle(vetorAbrLivro2[indexPath.row], for: .normal)
        case "05":
            cell.btnLivro1.setTitle(vetorMaiLivro1[indexPath.row], for: .normal)
            cell.btnLivro2.setTitle(vetorMaiLivro2[indexPath.row], for: .normal)
        case "06":
            cell.btnLivro1.setTitle(vetorJunLivro1[indexPath.row], for: .normal)
            cell.btnLivro2.setTitle(vetorJunLivro2[indexPath.row], for: .normal)
        case "07":
            cell.btnLivro1.setTitle(vetorJulLivro1[indexPath.row], for: .normal)
            cell.btnLivro2.setTitle(vetorJulLivro2[indexPath.row], for: .normal)
        case "08":
            cell.btnLivro1.setTitle(vetorAgoLivro1[indexPath.row], for: .normal)
            cell.btnLivro2.setTitle(vetorAgoLivro2[indexPath.row], for: .normal)
        case "09":
            cell.btnLivro1.setTitle(vetorSetLivro1[indexPath.row], for: .normal)
            cell.btnLivro2.setTitle(vetorSetLivro2[indexPath.row], for: .normal)
        case "10":
            cell.btnLivro1.setTitle(vetorOutLivro1[indexPath.row], for: .normal)
            cell.btnLivro2.setTitle(vetorOutLivro2[indexPath.row], for: .normal)
        case "11":
            cell.btnLivro1.setTitle(vetorNovLivro1[indexPath.row], for: .normal)
            cell.btnLivro2.setTitle(vetorNovLivro2[indexPath.row], for: .normal)
        case "12":
            cell.btnLivro1.setTitle(vetorDezLivro1[indexPath.row], for: .normal)
            cell.btnLivro2.setTitle(vetorDezLivro2[indexPath.row], for: .normal)
        default:
            cell.btnLivro1.setTitle(vetorJanLivro1[indexPath.row], for: .normal)
            cell.btnLivro2.setTitle(vetorJanLivro2[indexPath.row], for: .normal)
        }
        
        cell.backgroundColor = UIColor.colorWithHexString("#f4f4ee")
        
        return cell
    }

    //Método para separar a abreviaçao do Livro 1 e separar o capítulo e versículo
    @IBAction func separarAbreviacao(_ sender: UIButton) {
        var abreviacao : String!
        abreviacao = sender.currentTitle
        let abreviacaoLivro = abreviacao.components(separatedBy: " ")
        var capitulo12: [String]!

        var versiculo12: [String]!
        
        //1 - Abreviaçãod do Livro
        Livro = abreviacaoLivro[0]
        
        //2 - Verificar se existe capítulo (.) e versículo
        capitulo1 = abreviacaoLivro[1]
        if capitulo1.range(of:".") != nil{
            capitulo12 = capitulo1.components(separatedBy: ".")
            capitulo1 = capitulo12[0]    //Capitulo
            //Obter os versículos
            versiculo12 = capitulo12[1].components(separatedBy: "-")
            versiculo1 = versiculo12[0] //Versiculo 1
            versiculo2 = versiculo12[1] //Versiculo 2
        } else {
        //2.1 - Obter somente os capítulos
            capitulo1 = abreviacaoLivro[1]
        //Verificar se tem somente um capítulo
            if capitulo1.range(of: "-") != nil {
                var capitulo0: [String]!
                capitulo0 = capitulo1.components(separatedBy: "-")
                capitulo1 = capitulo0[0]
                capitulo2 = capitulo0[1]
                versiculo1 = ""
                versiculo2 = ""
            } else {
                capitulo2 = ""
                versiculo1 = ""
                versiculo2 = ""
            }
        
        }
        
        //Criar uma tela (controller) para mostrar o Livro, capitulo e versículo selecionado
        //no primeiro controller colocar um botao para ir para o segundo capitulo escolhido
        performSegue(withIdentifier: "showLeituraMes", sender: nil)
    }
    
    
    //Método para separar a abreviaçao do Livro 1 e separar o capítulo e versículo
    @IBAction func separarAbrev2(_ sender: UIButton) {
        var abreviacao : String!
        abreviacao = sender.currentTitle
        let abreviacaoLivro = abreviacao.components(separatedBy: " ")
        var capitulo12: [String]!
        
        var versiculo12: [String]!
        
        //1 - Abreviaçãod do Livro
        Livro = abreviacaoLivro[0]
        
        //2 - Verificar se existe capítulo (.) e versículo
        capitulo1 = abreviacaoLivro[1]
        if capitulo1.range(of:".") != nil{
            capitulo12 = capitulo1.components(separatedBy: ".")
            capitulo1 = capitulo12[0]    //Capitulo
            capitulo2 = ""
            //Obter os versículos
            versiculo12 = capitulo12[1].components(separatedBy: "-")
            versiculo1 = versiculo12[0] //Versiculo 1
            versiculo2 = versiculo12[1] //Versiculo 2
        } else {
            //2.1 - Obter somente os capítulos
            capitulo1 = abreviacaoLivro[1]
            //Verificar se tem somente um capítulo
            if capitulo1.range(of: "-") != nil {
                var capitulo0: [String]!
                capitulo0 = capitulo1.components(separatedBy: "-")
                capitulo1 = capitulo0[0]
                capitulo2 = capitulo0[1]
                versiculo1 = ""
                versiculo2 = ""
            } else {
                capitulo2 = ""
                versiculo1 = ""
                versiculo2 = ""
            }
            
        }
        
        //Criar uma tela (controller) para mostrar o Livro, capitulo e versículo selecionado
        //no primeiro controller colocar um botao para ir para o segundo capitulo escolhido
        performSegue(withIdentifier: "showLeituraMes", sender: nil)
    }

    
    //Método para marcar o check list
    @IBAction func tick(sender: UIButton) {
        if unchecked {
            sender.setImage(UIImage(named:"checked_25.png"), for: .normal)
            unchecked = false
        }
        else {
            sender.setImage( UIImage(named:"Unchecked_25.png"), for: .normal)
            unchecked = true
        }
    }

    // Criaçao do segue para passar dados para a proxima tela
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLeituraMes" || segue.identifier == "showLeituraMes1" {
            let LeitorViewController = segue.destination as! LeitorPlanoViewController
            LeitorViewController.Livro = Livro
            LeitorViewController.Capitulo1 = capitulo1
            if (capitulo2 != nil) {
                LeitorViewController.Capitulo2 = capitulo2
            }
            if (versiculo1 != nil) {
                LeitorViewController.Versiculo1 = versiculo1
            }
            if (versiculo2 != nil) {
                LeitorViewController.Versiculo2 = versiculo2
            }
        }
        
    }
    
}
