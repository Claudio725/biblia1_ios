//
//  CapitulosCollectionViewController.swift
//  FMDBTut
//
//  Created by MacBook Pro i7 on 02/01/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit

struct CapitulosInfo {
    var Numero : String!
    var LivroID: String!
}

private let reuseIdentifier = "Cell"

class CapitulosCollectionViewController: UICollectionViewController{
    
    var capitulo: [CapitulosInfo]!
    var selectedCapitulos: Int!
    var queryComplemento: String!
    var queryComplementoVersiculo: String!
    var query: String!
    var selectedcapitulo : Int!
    var livroID : String!
    
    // MARK: IBOutlet Properties
    @IBOutlet weak var tblCapitulos: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Do any additional setup after loading the view.
        tblCapitulos.delegate = self
        tblCapitulos.dataSource = self

        
        title = "CAPÍTULO"

        // Do any additional setup after loading the view.
        query = queryComplemento
        capitulo = DBManager.shared.loadCapitulos(complSql: query)
        
        tblCapitulos.reloadData()
        
        // Remove the title of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        //Back ground da tela
        tblCapitulos.backgroundColor = UIColor.colorWithHexString("#f4f4ee")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let sideSize = (traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular) ? 80.0 : 128.0
        return CGSize(width: sideSize, height: sideSize)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (capitulo != nil) ? capitulo.count : 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CapitulosCollectionViewCell
        
        let capituloCorrente = capitulo[indexPath.row]
        
        // Configure the cell
        cell.OutCapitulo.text = capituloCorrente.Numero
        cell.backgroundView = UIImageView(image: UIImage(named: "photo-frame-76x76.png"))
        cell.backgroundColor = UIColor.white
        cell.OutCapitulo.backgroundColor = UIColor.colorWithHexString("#f4f4ee")
        cell.OutCapitulo.font = UIFont(name: "BrandonGrotesque-Bold", size: 16)
        cell.OutCapitulo.font = UIFont.boldSystemFont(ofSize: 16)
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        query = queryComplemento
        capitulo = DBManager.shared.loadCapitulos(complSql: query)
        tblCapitulos.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedcapitulo = indexPath.row
        queryComplementoVersiculo = "AND BI.BOOK_ID = " + queryComplemento +
            " AND BI.CHAPTER = " + capitulo[selectedcapitulo].Numero
    }
    

    //Passar o book_id e o capitulo para filtrar o Versiculo
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "showVersiculoLivro" {
                if let indexPaths = collectionView?.indexPathsForSelectedItems {
                    let VersiculoViewController = segue.destination as! VersiculosCollectionViewController
                    VersiculoViewController.livroID = capitulo[indexPaths[0].row].LivroID
                    VersiculoViewController.capitulo = capitulo[indexPaths[0].row].Numero
                    
                    collectionView?.deselectItem(at: indexPaths[0], animated: false)
                }
            }
        }
    }
    
    
}
