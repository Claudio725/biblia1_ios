//
//  PlanoLeituraViewController.swift
//  BibliaNVT
//
//  Created by MacBook Pro i7 on 06/02/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//  Módulo para a leitura anual da Bíblia

import UIKit

class PlanoLeituraViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    var mesAno: [String]! = ["JANEIRO","FEVEREIRO","MARÇO","ABRIL","MAIO","JUNHO","JULHO",
                  "AGOSTO","SETEMBRO","OUTUBRO","NOVEMBRO","DEZEMBRO"]
    
    var mesEscolhido : String! = ""
    var nomeMesEscolhido : String! = ""
    
    //Outlet para tratar a table view
    @IBOutlet weak var tblMes: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblMes.delegate = self
        tblMes.dataSource = self
        tblMes.reloadData()
        
        //Remove o título na seta de volta da navegação
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        //Back ground da tela
        view.self.backgroundColor = UIColor.colorWithHexString("#f4f4ee")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mesAno.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        //Configurar a célula
        cell.textLabel?.text = mesAno[indexPath.row]
        cell.textLabel?.font = UIFont(name: "BrandonGrotesque-Bold", size: 15)
        cell.backgroundColor = UIColor.colorWithHexString("#f4f4ee")
        
        return cell
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func obtemMes()->String {
        if let indexPath = tblMes.indexPathForSelectedRow {
            nomeMesEscolhido = mesAno[indexPath.row]
            switch mesAno[indexPath.row] {
            case "JANEIRO":
                mesEscolhido = "01"
            case "FEVEREIRO":
                mesEscolhido = "02"
            case "MARÇO":
                mesEscolhido = "03"
            case "ABRIL":
                mesEscolhido = "04"
            case "MAIO":
                mesEscolhido = "05"
            case "JUNHO":
                mesEscolhido = "06"
            case "JULHO":
                mesEscolhido = "07"
            case "AGOSTO":
                mesEscolhido = "08"
            case "SETEMBRO":
                mesEscolhido = "09"
            case "OUTUBRO":
                mesEscolhido = "10"
            case "NOVEMBRO":
                mesEscolhido = "11"
            case "DEZEMBRO":
                mesEscolhido = "12"
            default:
                mesEscolhido = "01"
            }
        }
        return mesEscolhido
    }
    
    // Criaçao do segue para passar dados para a proxima tela
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLeituraMes" {
            let MesViewController = segue.destination as! PlanoLeituraMensalViewController
            MesViewController.mes = obtemMes()
            MesViewController.nomeMes = nomeMesEscolhido
        }
        
    }

}
