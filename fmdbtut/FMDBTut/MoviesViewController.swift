//
//  MoviesViewController.swift
//  FMDBTut
//
//  Created by Gabriel Theodoropoulos on 04/10/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit

struct VersoInfo {
    var name : String!
    var testamento : String!
    var livroID : String!
    var capitulo : String!
    var verso : String!
    var text: String!
}

struct VersoInfo1 {
    var name : String!
    var testamento : String!
    var livroID : String!
    var capitulo : String!
    var verso : Int32!
    var text: String!
}

struct VersiculoDoDia {
    var datadia : Date!
    var livro : String!
    var capitulo : String!
    var versiculo : String!
}

struct PreferenciasSistema {
    var FonteNome: String!
    var FonteTamanho: String!
    var FundoNoturno: String!
}


class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//UISearchResultsUpdating{

    // MARK: IBOutlet Properties
    @IBOutlet weak var tblMovies: UITableView!
    
    // MARK: Custom Properties
    var versos: [VersoInfo]!
    
    var selectedMovieIndex: Int!
    var queryComplemento: String!
    
    //variável para criar a barra de pesquisa
//    var searchController:UISearchController!
//    var searchResults: [VersoInfo]!
    
    
    // MARK: Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tblMovies.delegate = self
        tblMovies.dataSource = self
        
        self.tabBarController?.tabBar.items![2].isEnabled = false
        
        //Remove o título na seta de volta da navegação
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
 
        //Back ground da tela
        tblMovies.backgroundColor = UIColor.colorWithHexString("#f4f4ee")

        //Carrega todos versiculos conforme a palavra-chave
        let sql1 = "AND BI.TEXT LIKE \'%" + queryComplemento + "%'"
        versos = DBManager.shared.loadVersiculo(complSql: sql1)
        tblMovies.reloadData()


    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {


    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Passar os dados pesquisados para a página Detalhada com o versículo selecionado
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            
            if identifier == "showDetalheVersiculo" {
                if let indexPath = tblMovies.indexPathForSelectedRow {
                    let DetalheViewController = segue.destination as! DetalheTableViewController
                    //Testa se a barra de espaço está ativa
                    queryComplemento = "AND BI.BOOK_ID = " + versos[indexPath.row].livroID +
                            " AND BI.CHAPTER = " + versos[indexPath.row].capitulo +
                            " AND BI.VERSE = " + versos[indexPath.row].verso
                    DetalheViewController.sqlVersiculo =   queryComplemento
                }
            }
        }
    }
    
    
    
    // MARK: UITableView Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (versos != nil) ? versos.count : 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        as! MoviewTableViewCell
        
        let currentMovie = versos[indexPath.row]
        
        var campoNome: String;
        campoNome = currentMovie.name! + " "
        campoNome = campoNome + currentMovie.capitulo + ":" +
            currentMovie.verso + " NVT"
        
        cell.nome.text! = campoNome

        cell.nome.font = UIFont(name: "BrandonGrotesque-Bold", size: 16)
        //cell.nome.font = UIFont.boldSystemFont(ofSize: 16)
        cell.livroID.text = currentMovie.livroID
        cell.livroID.font = UIFont(name: "BrandonGrotesque-Bold", size: 16)
        //cell.livroID.font = UIFont.boldSystemFont(ofSize: 16)
        cell.capitulo.text = currentMovie.capitulo
        cell.capitulo.font = UIFont(name: "BrandonGrotesque-Bold", size: 16)
        //cell.capitulo.font = UIFont.boldSystemFont(ofSize: 16)
        cell.verso.text = currentMovie.verso
        cell.verso.font = UIFont(name: "BrandonGrotesque-Bold", size: 16)
        //cell.verso.font = UIFont.boldSystemFont(ofSize: 16)
        cell.texto.text = currentMovie.text
        cell.texto.font = UIFont(name: "BrandonGrotesque-Bold", size: 16)
        //cell.texto.font = UIFont.boldSystemFont(ofSize: 16)
        
        cell.backgroundColor! = UIColor.colorWithHexString("#f4f4ee")

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovieIndex = indexPath.row
        queryComplemento = "AND BI.BOOK_ID = " + versos[selectedMovieIndex].livroID +
            " AND BI.CHAPTER = " + versos[selectedMovieIndex].capitulo +
            " AND BI.VERSE = " + versos[selectedMovieIndex].verso
        
    }

    
    
}
