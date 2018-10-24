//
//  ListaLivrosViewController.swift
//  FMDBTut
//
//  Created by MacBook Pro i7 on 29/12/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit

struct LivrosInfo {
    var livroID : String!
    var name : String!
}

extension ListaLivrosViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
}

extension ListaLivrosViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class ListaLivrosViewController: UITableViewController{
    var livros: [LivrosInfo]!
    
    var selectedLivro: Int!
    var queryComplemento: String!
    var query: String!
    
    var resultadoPesquisa: [LivrosInfo] = []
    
    @IBOutlet var searchFooter: SearchFooter!

    lazy var searchController:UISearchController = ({
        let controller = UISearchController(searchResultsController: nil) // 1
        controller.hidesNavigationBarDuringPresentation = false // 2
        controller.dimsBackgroundDuringPresentation = false // 3
        controller.searchBar.searchBarStyle = .minimal // 4
        controller.searchResultsUpdater = self // 5
        controller.searchBar.placeholder = "Pesquisar Livros"
        return controller
    })()
    
    // MARK: IBOutlet Properties
    @IBOutlet weak var tblLivros: UITableView!
    let cellSpacingHeight: CGFloat = 5
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblLivros.delegate = self
        tblLivros.dataSource = self
        
        // Remove the title of the back button
        navigationItem.backBarButtonItem =
            UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain,
                            target: self, action: nil)
        
        //Back ground da tela
        view.self.backgroundColor = UIColor.colorWithHexString("#f4f4ee")
        tblLivros.tintColor = UIColor.colorWithHexString("#f4f4ee")
        
        title = "LIVROS"
        
        livros = DBManager.shared.loadLivros(complSql: query)
        
        tblLivros.reloadData()
        
        self.tabBarController?.tabBar.items![2].isEnabled = false
        
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        
    }
    
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        resultadoPesquisa = livros.filter({( livros : LivrosInfo) -> Bool in
            let doesCategoryMatch = (scope == "All") || (livros.name == scope)
            
            if searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && livros.name.lowercased().contains(searchText.lowercased())
            }
        })
        tblLivros.reloadData()
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }

    
    //Filtro de pesquisa
    func filterContent(for searchText: String) {
        resultadoPesquisa = livros.filter({ (livros) -> Bool in
            if let name = livros.name {
                let isMatch = name.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            
            return false
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tabBarController?.tabBar.items![2].isEnabled = false
        searchController.searchBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.searchBar.isHidden = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if (isFiltering()) {
            searchFooter.setIsFilteringToShow(filteredItemCount: resultadoPesquisa.count, of: livros.count)
            return resultadoPesquisa.count
        }
        searchFooter.setNotFiltering()
        return livros.count
        //return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if (isFiltering()) {
//            searchFooter.setIsFilteringToShow(filteredItemCount: resultadoPesquisa.count, of: livros.count)
//            return resultadoPesquisa.count
//        }
//        searchFooter.setNotFiltering()
//        return livros.count
        return 1
    }
    
    // Set the spacing between sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let livrocorrente: LivrosInfo
        if isFiltering() {
            livrocorrente = resultadoPesquisa[indexPath.section]
        } else {
            livrocorrente = livros[indexPath.section]
        }
        
        //let livrocorrente = livros[indexPath.row]
        
        cell.textLabel?.text = livrocorrente.name
        cell.textLabel?.backgroundColor = UIColor.colorWithHexString("#f4f4ee")
        cell.backgroundColor = UIColor.colorWithHexString("#f4f4ee")
        
        // Rounded corners
        cell.backgroundColor = UIColor.colorWithHexString("#f4f4ee")
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 18
        cell.clipsToBounds = true
        
        cell.textLabel?.font = UIFont(name: "BrandonGrotesque-Bold", size: 16)
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)

        return cell
    }
    
    // Make the background color show through
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLivro = indexPath.section
        queryComplemento = "AND BI.BOOK_ID = " + livros[selectedLivro].livroID
    }

    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let identifier = segue.identifier {

            if identifier == "showCapitulos" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let livro: LivrosInfo
                    if isFiltering() {
                        livro = resultadoPesquisa[indexPath.section]
                    } else {
                        livro = livros[indexPath.section]
                    }
                    print (livro)
                    //let linha = indexPath.row
                    let CapitulosController = segue.destination as! CapitulosCollectionViewController
                    //CapitulosController.queryComplemento =   livros[linha].livroID
                    
                    searchController.searchBar.isHidden = true
                    
                    CapitulosController.queryComplemento = livro.livroID
                    CapitulosController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                    CapitulosController.navigationItem.leftItemsSupplementBackButton = true
                }

            }
        }
    }
    
    //Fecha o controller
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func willMove(toParentViewController parent: UIViewController?) {
        searchController.isActive = false
        super.willMove(toParentViewController: parent)
    }

}
