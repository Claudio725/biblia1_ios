//
//  MarcadorTableViewController.swift
//  BibliaNVT
//
//  Created by MacBook Pro i7 on 26/10/2017.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit

class MarcadorTableViewController: UITableViewController, Mensagem{
    // MARK: IBOutlet Properties
    @IBOutlet weak var tblMarcados: UITableView!

    
    // MARK: Custom Properties
    var marcacao: [VersosMarcados]!
    
    var selectedMarcacaoIndex: Int!
    var queryComplemento: String!
    var versiculo_marcado: String!
    var linhaDeletar: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblMarcados.delegate = self
        tblMarcados.dataSource = self
        
        // Remove the title of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //Back ground da tela
        tblMarcados.backgroundColor = UIColor.colorWithHexString("#f4f4ee")
        
        //Carrega todos versiculos marcados
        marcacao = DBManager.shared.loadMarcacao()
        tblMarcados.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Passar os dados pesquisados para a página Detalhada com o versículo selecionado
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            
            if identifier == "listamarcacao" {
                if let indexPath = tblMarcados.indexPathForSelectedRow {
                    let leituraViewController = segue.destination as! ListaVersiculoViewController
                    //Testa se a barra de espaço está ativa
                    leituraViewController.livroID = marcacao[indexPath.row].livroID
                    leituraViewController.capitulo = marcacao[indexPath.row].capítulo
                    leituraViewController.textoCompletoVersiculoDia = marcacao[indexPath.row].texto
                    let x = Int(marcacao[indexPath.row].verse)
                    leituraViewController.versiculo1 = Int32(x!)
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (marcacao != nil) ? marcacao.count : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
     as! MarcadorTableViewCell
     
     let currentMarcado = marcacao[indexPath.row]
     
     cell.nome.text! = currentMarcado.livroNome! + " "
     cell.nome.text! = cell.nome.text! + currentMarcado.capítulo + ":" + currentMarcado.verse + " NVT"
     cell.nome.font = UIFont(name: "BrandonGrotesque-Bold", size: 16)
     cell.nome.font = UIFont.boldSystemFont(ofSize: 16)
     cell.titulo.text! = currentMarcado.titulo
     cell.titulo.font = UIFont(name: "BrandonGrotesque-Bold", size: 16)
     cell.titulo.font = UIFont.boldSystemFont(ofSize: 16)
     cell.livroID.text! = currentMarcado.livroID
     cell.livroID.font = UIFont(name: "BrandonGrotesque-Bold", size: 16)
     cell.livroID.font = UIFont.boldSystemFont(ofSize: 16)
     cell.capitulo.text! = currentMarcado.capítulo
     cell.verso.text! = currentMarcado.verse
     cell.texto.text! = currentMarcado.texto
     cell.texto.font = UIFont(name: "BrandonGrotesque-Bold", size: 16)
     cell.texto.font = UIFont.boldSystemFont(ofSize: 16)
        
     cell.backgroundColor! = UIColor.colorWithHexString("#f4f4ee")
     
     return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 193.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMarcacaoIndex = indexPath.row
        linhaDeletar = indexPath
        self.performSegue(withIdentifier: "listamarcacao", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        marcacao = DBManager.shared.loadMarcacao()
        tblMarcados.reloadData()
    }
    
    @IBAction func Compartilhar(sender: UIButton) {
        if let cell = sender.superview?.superview as? MarcadorTableViewCell {
            let indexPath = tblMarcados.indexPath(for: cell)
    
            versiculo_marcado = marcacao[(indexPath?.row)!].livroNome + " " +
                marcacao[(indexPath?.row)!].capítulo + ":" +
                marcacao[(indexPath?.row)!].verse + "\n\n" +
                marcacao[(indexPath?.row)!].texto + "\n\n" +
                "Bíblia Sagrada, Nova Versão Transformadora\n" +
                "Copyright © 2016 por Editora Mundo Cristão.\n" +
                "Todos os direitos reservados.\n"
            let vc = UIActivityViewController(activityItems: [versiculo_marcado as Any],
                                              applicationActivities: nil)
                vc.popoverPresentationController?.sourceView = self.view
                vc.excludedActivityTypes = [ UIActivity.ActivityType.airDrop]
                self.present(vc, animated: true, completion: nil)

        }
    }
    
    @IBAction func CopiarMarcacao(sender: UIButton) {
        if let cell = sender.superview?.superview as? MarcadorTableViewCell {
            let indexPath = tblMarcados.indexPath(for: cell)
            
            versiculo_marcado = marcacao[(indexPath?.row)!].livroNome + " " +
                marcacao[(indexPath?.row)!].capítulo + ":" +
                marcacao[(indexPath?.row)!].verse + "\n\n" +
                marcacao[(indexPath?.row)!].texto + "\n\n" +
                "Bíblia Sagrada, Nova Versão Transformadora\n" +
                "Copyright © 2016 por Editora Mundo Cristão.\n" +
            "Todos os direitos reservados.\n"

            UIPasteboard.general.string  = versiculo_marcado
            versiculo_marcado = ""
            mensagem(message: "Versículo(s) copiado(s)!")
            
        }
    }
    
    @IBAction func ExcluirMarcacao(sender: UIButton) {
        if let cell = sender.superview?.superview as? MarcadorTableViewCell {
            let indexPath = tblMarcados.indexPath(for: cell)
            
            let livro = marcacao[(indexPath?.row)!].livroID
            let capitultoID = marcacao[(indexPath?.row)!].capítulo
            let versiculoID: String = marcacao[(indexPath?.row)!].verse
            
            
            DBManager.shared.excluirMarcacao(livroID: livro!,
                                             capituloID: capitultoID!,
                                             versiculoID: versiculoID)
            
            marcacao = DBManager.shared.loadMarcacao()
            self.tableView!.reloadData()
            
            mensagem(message: "Marcação retirada!")
            
        }
    }
    

}
