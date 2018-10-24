//
//  VersiculosCollectionViewController.swift
//  FMDBTut
//
//  Created by MacBook Pro i7 on 03/01/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit


private let reuseIdentifier = "Cell"

class VersiculosCollectionViewController: UICollectionViewController {
    var versiculo: [VersoInfo]!
    var selectedVerso: Int!
    var queryComplementoVersiculo: String!
    var query: String!
    var selectedcapitulo : Int!
    
    //Filtros de livro e capitulo passados pela tela de capitulos
    var livroID : String!
    var capitulo : String!
    
    // MARK: IBOutlet Properties
    @IBOutlet weak var tblVersiculos: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false


        // Do any additional setup after loading the view.
        tblVersiculos.delegate = self
        tblVersiculos.dataSource = self
        
        // Remove the title of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        //Back ground da tela
        tblVersiculos.backgroundColor = UIColor.colorWithHexString("#f4f4ee")
        //
        title = "VERSÍCULO"

        
        // Do any additional setup after loading the view.
        versiculo = DBManager.shared.loadVersiculoPorLivroCapitulo(livro: livroID, capitulo: capitulo)
        
        tblVersiculos.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (versiculo != nil) ? versiculo.count : 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! VersiculosCollectionViewCell
    
        // Configure the cell
        let versiculoCorrente = versiculo[indexPath.row]
        
        // Configure the cell
        cell.OutVersiculo.text = versiculoCorrente.verso
        cell.backgroundView = UIImageView(image: UIImage(named: "photo-frame-76x76.png"))
        cell.backgroundColor = UIColor.white
        cell.OutVersiculo.backgroundColor = UIColor.colorWithHexString("#f4f4ee")
        cell.backgroundColor = UIColor.white
        cell.OutVersiculo.font = UIFont(name: "BrandonGrotesque-Bold", size: 16)
        cell.OutVersiculo.font = UIFont.boldSystemFont(ofSize: 16)
        
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedVerso = indexPath.row
        queryComplementoVersiculo = "AND BI.BOOK_ID = " + livroID
        queryComplementoVersiculo = queryComplementoVersiculo +
            " AND BI.CHAPTER = " + capitulo +
            " AND BI.VERSE >= " + versiculo[indexPath.row].verso
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        query = queryComplementoVersiculo
        versiculo = DBManager.shared.loadVersiculoPorLivroCapitulo(livro: livroID, capitulo: capitulo)
        tblVersiculos.reloadData()
    }
    
    //Passar o book_id, capitulo e verso para filtrar o Versiculo
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showListaVersiculos" {
            if let indexPaths = collectionView?.indexPathsForSelectedItems {
                let ListaController = segue.destination as! ListaVersiculoViewController
                let x = Int(versiculo[indexPaths[0].row].verso)

                ListaController.versiculo1 = Int32(x!)
                
                ListaController.livroID = versiculo[indexPaths[0].row].livroID
                ListaController.capitulo = versiculo[indexPaths[0].row].capitulo
                ListaController.textoCompletoVersiculoDia = ""
                
                collectionView?.deselectItem(at: indexPaths[0], animated: false)
            }
        }
    }
}
