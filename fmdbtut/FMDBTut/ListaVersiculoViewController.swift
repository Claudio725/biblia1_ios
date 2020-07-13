//
//  ListaVersiculoViewController.swift
//  FMDBTut
//
//  Created by MacBook Pro i7 on 04/01/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit
import Branch


enum IntToString: Error {
    case NotANumber
    }


extension UITextView {
    func setLineSpacing(lineSpacing: CGFloat) {

       // self.textView.attributedText = attrString
    }
}

extension UIStackView {
    
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
    
}


class ListaVersiculoViewController: UIViewController,UITextViewDelegate,UIPopoverPresentationControllerDelegate,
    UINavigationControllerDelegate,BranchDeepLinkingController,
    UITableViewDataSource,UITableViewDelegate, Mensagem  {
    
    //Outlet para mostrar o texto do versículo selecionado
    @IBOutlet var textView: CustomTextView?
    @IBOutlet var stackView_c : UIStackView!
    
    //Variavel para controlar o scrow para o topo do capitulo
    var versiculoScrow: Int = 0
    var capituloInt: Int = 0
    
    var versiculo_marcado:String!
    var versiculo_marcacao: Int32!
    
    //guardar a primeira cor da celula
    var corAtual : UIColor!
    
    //Range anterior para comparar no long press
    var textoAnterior:String!
    var flag:Bool! = false
    var rangeAnterior:NSRange!
    var CliqueDuplo: Bool! = false
    
    //Outlet para ligar o botao ProximoCapitulo e botao AnteriorCapitulo
    @IBOutlet var btnProximoLivro: UIButton!
    @IBOutlet var btnProximoCapitulo: UIButton!
    @IBOutlet var btnAnteriorCapitulo: UIButton!
    @IBOutlet var btnCompartilhar: UIButton!
    @IBOutlet var btnMarcar: UIButton!
    @IBOutlet var btnCopiar: UIButton!
    
    @IBOutlet var nomeCapituloVersiculo: UILabel!
    @IBOutlet var tblNova: UITableView!
    
    var deepLinkingCompletionDelegate: BranchDeepLinkingControllerCompletionDelegate?
    
    //Variáveis para receber o filtro passado pela tela anterior

    var livroID : String!
    var capitulo : String!
    var versiculo1 : Int32!
    var textoCompletoVersiculoDia: String!
    
    //Variavel para receber as linhas selecionadas na tblNova
    var selectedCells:[Int] = []
    
    //Array para receber todos os versiculos selecionados na tblNova
    var versiculos_selecionados_tblnova:[Int32] = []
    
    //variavel para saber se o botao Ir para proximo livro foi clicado
    var botaoProximo : Bool! = false
    
    var proximoLivro:String! =  ""

    var versiculoSel: [VersoInfo1]!
    
    var nomeCapitulo: String! = ""
    
    var versiculoInt : Int!
    
    var sqlparcial: String! = ""
    
    var segment: UISegmentedControl!
    
    private var longPressGestureRecognizer:UILongPressGestureRecognizer!
    
    var versiculo_marcado_segue: String! = ""
    var somente_versiculo_selecionado : String! = ""
    
    var fundo_noturno: String! = "#030000"
    var fundo_default: String! = "#f4f4ee"
    var letras_brancas: String! = "#ffffff"
    var numero_versiculo_azul: String! = "#2d4ae9"
    var letras_pretas: String! = "#030000"
    var fundo_noturno_preferencia: String! = ""
    var fundo_bg : String! = ""
    var fundo_bg_selecionador : String! = ""
    var fundo_orange : String! = "#ffa500"
    var fundo_amarelo: String! = "#ffff00"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Desabilitar a barra de marcaçao aqui e no evento didappear
        self.tabBarController?.tabBar.items![2].isEnabled = false
        
        tblNova.dataSource = self
        tblNova.delegate = self
        tblNova.rowHeight = UITableView.automaticDimension
        tblNova.estimatedRowHeight = 25
        
        //Rotina para fazer a rolagem do texto até o versículo escolhido
        if (versiculo1 != nil ) {
            versiculoInt = Int(versiculo1)
        } else {
            versiculoInt = 0
        }
        
        //Back ground da tela
        view.self.backgroundColor = UIColor.colorWithHexString(fundo_bg)
        
        // Do any additional setup after loading the view.
        versiculoSel = DBManager.shared.loadVersiculoPorLivroCapituloVerso(
            livro: livroID,
            capitulo: capitulo,
            verso: versiculo1)
        
        //Mostrar no topo o Livro, Capítulo e Versículo - Negrito
        let attributedString : NSMutableAttributedString! = NSMutableAttributedString(string:String(describing: nomeCapituloVersiculo))
        
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)]
        let boldString = NSMutableAttributedString(string:String(describing: nomeCapituloVersiculo), attributes:attrs)
        
        attributedString.append(boldString)
        nomeCapituloVersiculo.attributedText = attributedString
        nomeCapitulo = versiculoSel[0].name + " " + capitulo
        nomeCapituloVersiculo.text =
            versiculoSel[0].name + " " + capitulo! + ":" + String(versiculo1)
        nomeCapituloVersiculo.backgroundColor = UIColor(red: 114/255, green: 0/255, blue: 45/255, alpha: 1.0) /* #72002d */
        
        //title = nomeCapituloVersiculo.text!
        
        textView?.delegate = self
        
        
        //segmented control
        segment = UISegmentedControl(items: [nomeCapituloVersiculo.text!
                                                                ])
        segment.sizeToFit()
        segment.selectedSegmentIndex = -1;
        segment.addTarget(self, action: #selector(vaiParaLivros(sender:)), for: .valueChanged)

        self.navigationItem.titleView = segment
        
        //Formata o texto
        formatarTexto()
        
        // Remove the title of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //Back ground da tela
        view.self.backgroundColor = UIColor.colorWithHexString(fundo_bg)

        //Limite de livro e capítulo da Bíblia - Início
        if (livroID == "1") && (capitulo == "1") {
            btnAnteriorCapitulo.isHidden = true
        } else {
            btnAnteriorCapitulo.isHidden = false
        }
        
        //Limite de livro e capítulo da Bíblia - Final da Bíblia
        if (livroID == "66") && (capitulo == "22") {
            btnProximoCapitulo.isHidden = true
            //btnProximoLivro.isHidden = true
        } else {
            btnProximoCapitulo.isHidden = false
            if (livroID == "66") {
                //btnProximoLivro.isHidden = true
            } else {
                //btnProximoLivro.isHidden = false
            }
        }
        
        btnProximoLivro.isHidden = true
        
        //Colocar a figura Ajustes para permitir alteração dos fontes
        //na barra superior
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "engrenagemWhite.png"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(addCard(sender:)), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        
        
        self.navigationItem.setRightBarButtonItems([item1], animated: true)
        
        //tratar o Tap pressure no textview para o duplo clique
        let tapGesture = UITapGestureRecognizer(target: self,
                                action: #selector(tapOnTextViewDuploClique(_:)))
        tapGesture.numberOfTapsRequired=2
        textView!.addGestureRecognizer(tapGesture)
        
        //tratar o Tap pressure no textview para o clique simples - o highlight
        //será feito aqui
        let tapGestureSimples = UITapGestureRecognizer(target: self,
                                 action:  #selector(tapOnTextView(_:)))
        
        tapGestureSimples.numberOfTapsRequired = 1
        textView!.addGestureRecognizer(tapGestureSimples)
        
        view.bringSubviewToFront(btnProximoCapitulo)
        view.bringSubviewToFront(btnAnteriorCapitulo)
        view.bringSubviewToFront(btnMarcar)
        view.bringSubviewToFront(btnCompartilhar)
        stackView_c.sizeToFit()
        stackView_c.addBackground(color: UIColor.colorWithHexString("#E9FFE9"))
        tblNova.backgroundColor = UIColor.colorWithHexString("#f4f4ee")
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return versiculoSel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
    
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableNovaViewCellTableViewCell
    
        // Configure the cell...
        
        cell.lblTextoVerso?.attributedText = makeAttributedString(
            title: String(versiculoSel[indexPath.row].text),
              cor: UIColor.colorWithHexString(fundo_default),
              maior: true,
              verso: String(versiculoSel[indexPath.row].verso)  )
        
        cell.backgroundColor = UIColor.colorWithHexString(fundo_bg)

        return cell
    }

    // UITableViewAutomaticDimension calculates height of label contents/text
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.isSelected {
                cell.backgroundColor = UIColor.colorWithHexString(fundo_bg_selecionador)
                //self.stackView_c.isHidden = false
            }
        }
        
        versiculo_marcacao = Int32(versiculoSel[(indexPath.row)].verso)
        if (versiculo_marcacao != nil) {
            versiculos_selecionados_tblnova.append(versiculo_marcacao)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.backgroundColor = UIColor.colorWithHexString(fundo_bg)            
            versiculo_marcacao = Int32(versiculoSel[(indexPath.row)].verso)

            if (versiculo_marcacao != nil) {
                //Remove o elemento do array
                if let index = versiculos_selecionados_tblnova.firstIndex(
                    of: Int32(versiculoSel[(indexPath.row)].verso)) {
                    versiculos_selecionados_tblnova.remove(at: index)
                    //self.stackView_c.isHidden = true
                }
            }
        }
    }
    

    @IBAction func Compartilhar_versiculos() {
        var Temp1: String!=""
        versiculo_marcado = ""
        
        if let indexPaths = tblNova.indexPathsForSelectedRows?.sorted() {
            let contador = indexPaths.count
            for i in 0...contador-1 {
                let thisPath = indexPaths[i] as IndexPath
                let cell = tblNova.cellForRow(at: thisPath as IndexPath) as! TableNovaViewCellTableViewCell?
                Temp1 = cell!.lblTextoVerso.text!
                versiculo_marcado =  versiculo_marcado! +  Temp1
            }
            versiculo_marcado! = nomeCapitulo + "\n\n" + versiculo_marcado!   + "\n\n"
            versiculo_marcado! = versiculo_marcado! +
                "Bíblia Sagrada, Nova Versão Transformadora\n" +
                "Copyright © 2016 por Editora Mundo Cristão.\n" +
            "Todos os direitos reservados.\n"
            
            versiculo_marcado_segue = versiculo_marcado
            //stackView_c.isHidden = true
            
            let vc = UIActivityViewController(activityItems: [self.versiculo_marcado as Any],
                                              applicationActivities: nil)
            
            vc.popoverPresentationController?.sourceView = self.view
            vc.excludedActivityTypes = [ UIActivity.ActivityType.airDrop]
            
            self.present(vc, animated: true, completion: nil)
        }
        else {
            versiculo_marcado! = ""
            mensagem(message: "Selecione o(s) versículo(s)!")
        }
    }

    @IBAction func Marcar_versiculos() {
        var Temp1: String!=""
        versiculo_marcado = ""
        
        if let indexPaths = tblNova.indexPathsForSelectedRows?.sorted() {
            let contador = indexPaths.count

            for i in 0...contador-1 {
                let thisPath = indexPaths[i] as IndexPath
                
                if (tblNova.cellForRow(at: thisPath as IndexPath) as! TableNovaViewCellTableViewCell? != nil) {
                    let cell = tblNova.cellForRow(at: thisPath as IndexPath) as! TableNovaViewCellTableViewCell?
                    Temp1 = cell!.lblTextoVerso.text!
                    versiculo_marcado =  versiculo_marcado! +  Temp1
                    }
            }
            //Mostrar o nome do Livro e Capítulo e os versículos
            
            versiculo_marcado! = nomeCapitulo + "\n\n" + versiculo_marcado!   + "\n\n"
            versiculo_marcado! = versiculo_marcado! +
                "Bíblia Sagrada, Nova Versão Transformadora\n" +
                "Copyright © 2016 por Editora Mundo Cristão.\n" +
            "Todos os direitos reservados.\n"
            
            versiculo_marcado_segue = versiculo_marcado
            //stackView_c.isHidden = true
            
            self.performSegue(withIdentifier: "marcacao", sender: self)
        }
        else {
            versiculo_marcado! = ""
            mensagem(message: "Selecione o(s) versículo(s)!")
        }
    }
    
    @IBAction func Copiar_versiculos() {
        var Temp1: String!=""
        versiculo_marcado = ""
        
        if let indexPaths = tblNova.indexPathsForSelectedRows?.sorted() {
            let contador = indexPaths.count
            
            for i in 0...contador-1 {
                let thisPath = indexPaths[i] as IndexPath
                if (tblNova.cellForRow(at: thisPath as IndexPath) as! TableNovaViewCellTableViewCell? != nil) {
                    let cell = tblNova.cellForRow(at: thisPath as IndexPath) as! TableNovaViewCellTableViewCell?
                    Temp1 = cell!.lblTextoVerso.text!
                    versiculo_marcado =  versiculo_marcado! +  Temp1
                }
            }
            //Mostrar o nome do Livro e Capítulo e os versículos
            
            versiculo_marcado! = nomeCapitulo + "\n\n" + versiculo_marcado!   + "\n\n"
            versiculo_marcado! = versiculo_marcado! +
                "Bíblia Sagrada, Nova Versão Transformadora\n" +
                "Copyright © 2016 por Editora Mundo Cristão.\n" +
            "Todos os direitos reservados.\n"
            
            //stackView_c.isHidden = true
            
            UIPasteboard.general.string  = versiculo_marcado!
            versiculo_marcado! = ""
            mensagem(message: "Versículo(s) copiado(s)!")
            
        }
        else {
            versiculo_marcado! = ""
            mensagem(message: "Selecione o(s) versículo(s)!")
        }
    }
    
    func makeAttributedString(title: String, cor: UIColor, maior: Bool, verso: String) -> NSAttributedString {
        //Ler as preferencias do sistema e aplicar os fontes com os tamanhos da configuraçào
        let vetorPreferencias: [PreferenciasSistema]! = DBManager.shared.preferenciasSistema()!
        let fonteGenerica: String! = vetorPreferencias[0].FonteNome!
        let tamanhoGenerico: String! = vetorPreferencias[0].FonteTamanho!
        let fundo_noturno_preferencia = vetorPreferencias[0].FundoNoturno
        
        let combination : NSMutableAttributedString! = NSMutableAttributedString()
        let tamanhoMenor: CGFloat! = CGFloat(Double(tamanhoGenerico)!-4)
        let tamanhoMaior: CGFloat! = CGFloat(Double(tamanhoGenerico)!)
        
        let corNumero: String!
        let corLetras: String!
        
        //Verifica se uso o fundo noturno
        if (fundo_noturno_preferencia == "SIM") {
            corNumero = letras_brancas
            corLetras = letras_brancas
            fundo_bg = fundo_noturno
        } else {
            corNumero = numero_versiculo_azul
            corLetras = letras_pretas
            fundo_bg = fundo_default
        }

        let yourAttributes = [NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString(corNumero),
                          NSAttributedString.Key.font: UIFont(name: fonteGenerica, size: tamanhoMenor)]
    
        let yourOtherAttributes  =
        [NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString(corLetras),
         NSAttributedString.Key.font: UIFont(name: fonteGenerica, size: tamanhoMaior)! ]

        
        //for v in versiculoSel {
        let partOne = NSMutableAttributedString(string: String(verso) + " "
            , attributes: (yourAttributes as Any as! [NSAttributedString.Key : Any]))
            
        let partTwo = NSMutableAttributedString(string: title,
                                                attributes: (yourOtherAttributes as Any as! [NSAttributedString.Key : Any]))
        
        let partTres = NSMutableAttributedString(string: "\n", attributes: nil)
        
        combination.append(partOne)
        
        combination.append(partTwo)
        
        combination.append(partTres)


        //Ajustar o espaço entre as linhas
        let paragraphStyle : NSMutableParagraphStyle! = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.5
        paragraphStyle.lineHeightMultiple = 1
        
        let attString: NSMutableAttributedString! = combination
        attString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle as Any, range:NSMakeRange(0, attString.length))
        
        return attString
    }

    
    @IBAction func close(segue:UIStoryboardSegue) {
        
    }
    
    
    //Tratamento do duplo clique para fazer o compartilhamento ou a marcaçao
    @objc private func tapOnTextViewDuploClique(_ tapGestureDC: UITapGestureRecognizer) {
        let point = tapGestureDC.location(in: textView)
        //Determinar se foi clicado um clique simples
        CliqueDuplo = true
        
        if let detectedWord = getWordAtPosition(point)
        {
            print( detectedWord )
            
        }
    }
    
    //Tratar o duplo tap no textview para marcar o parágrafo (versículo)
    @objc private final func tapOnTextView(_ tapGesture: UITapGestureRecognizer){
        
        let point = tapGesture.location(in: textView)

        if let detectedWord = getWordAtPosition(point)
        {
           print( detectedWord )
            
        }
    }
    
    //Busca o parágrafo com a posicao clicada durante o duplo clique
    private final func getWordAtPosition(_ point: CGPoint) -> String?{
        if let textPosition = textView!.closestPosition(to: point)
        {
            if let range1: UITextRange = textView!.tokenizer.rangeEnclosingPosition(textPosition,
                                                      with: UITextGranularity.paragraph,
                                                      inDirection: convertToUITextDirection(1))
            {
                //Mudar a cor do background do parágrafo selecionado
                
                //1 - converte o range1 para NSRange
                let range2:NSRange = angeFromTextRange(textRange: range1, textView: textView!)
                
                if (rangeAnterior != nil) {
                    if (textView!.text(in: range1)! == "\n") {  //|| range2 == rangeAnterior) {
                        return nil
                    }
                }
                
                
                //2 - passa os atributos do fundo de cor do texto selecionado
                let string = NSMutableAttributedString(attributedString: textView!.attributedText)
                let attributes:NSDictionary

                if (flag ==  true)
                {
                    //Remove o fundo do paragrafo marcado
                    string.removeAttribute(NSAttributedString.Key.backgroundColor, range: rangeAnterior)
                    textView!.attributedText = string
                    textView!.selectedRange = rangeAnterior

                    flag = false
                }
                
                //Atribuir o novo atributo
                attributes = [NSAttributedString.Key.backgroundColor:UIColor.yellow]
                string.addAttributes(attributes as! [NSAttributedString.Key : Any] , range: range2)
                textView!.attributedText = string
                textView!.selectedRange = range2
                rangeAnterior = range2
                
                if (CliqueDuplo == true) {
                    nomeCapituloVersiculo.text =
                        versiculoSel[0].name + " " + capitulo! //+ ":" + String(versiculo1)
                    
                    
                    versiculo_marcado = nomeCapituloVersiculo.text! + "\n\n" +
                        textView!.text(in:range1)! + "\n\n" +
                        "Bíblia Sagrada, Nova Versão Transformadora\n" +
                        "Copyright © 2016 por Editora Mundo Cristão.\n" +
                        "Todos os direitos reservados.\n"
                    
                    somente_versiculo_selecionado = textView!.text(in:range1)! + "\n\n" +
                        "Bíblia Sagrada, Nova Versão Transformadora\n" +
                        "Copyright © 2016 por Editora Mundo Cristão.\n" +
                    "Todos os direitos reservados.\n"
                    
                    
                    // Criar um option menu
                    let optionMenu = UIAlertController(title: "",
                                                  message: "",
                                                  preferredStyle: .alert)
                    // Change font of the title and message
                    var titleFont = [NSAttributedString.Key : Any]()
                    
                    titleFont = [ NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue) : UIFont(name: "AmericanTypewriter", size: 18)! ]

                    let attributedTitle = NSMutableAttributedString(string: "SELECIONE SUA OPÇÃO", attributes: titleFont )

                    optionMenu.setValue(attributedTitle, forKey: "attributedTitle")
                    
                    versiculo_marcado_segue = versiculo_marcado
                
                    if (somente_versiculo_selecionado == "\n" ||
                        somente_versiculo_selecionado == nil ||
                        somente_versiculo_selecionado == "") {
                            return nil
                    }
                    
                    // Acrescentar ações no menu
                    let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                    let shareAction = UIAlertAction(title: "Compartilhar", style: UIAlertAction.Style.default,
                                    handler: { (action) -> Void in
                                        let vc = UIActivityViewController(activityItems: [self.versiculo_marcado as Any],
                                              applicationActivities: nil)
                                        vc.popoverPresentationController?.sourceView = self.view
                                        vc.excludedActivityTypes = [ UIActivity.ActivityType.airDrop]
                                                                     //UIActivityType.postToFacebook]
                                    self.present(vc, animated: true, completion: nil)
                    })
                    let marcarAction = UIAlertAction(title: "Marcar", style: UIAlertAction.Style.default,
                                 handler: { (action) -> Void in
                                self.performSegue(withIdentifier: "marcacao", sender: self)
                    })
                    
    //                    marcarAction.setValue(UIImage(named: "marcador.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), forKey: "image")
    //                    shareAction.setValue(UIImage(named: "share.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), forKey: "image")
    //                    cancelAction.setValue(UIImage(named: "cancel.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), forKey: "image")
                    
                    optionMenu.view.tintColor = UIColor.brown
                    optionMenu.view.backgroundColor = UIColor.cyan
                    optionMenu.view.layer.cornerRadius = 25
                    
                    optionMenu.addAction(cancelAction)
                    optionMenu.addAction(shareAction)
                    optionMenu.addAction(marcarAction)
                    
                    // Display the menu
                    present(optionMenu, animated: true, completion: nil)
                    
                    versiculo_marcado_segue = versiculo_marcado
                    
                    CliqueDuplo = false
                }
                flag = true
                return textView!.text(in: range1)
            }
        }
        return nil
    }
    
    //Converte o range para NSRange
    func angeFromTextRange(textRange:UITextRange,textView:UITextView) -> NSRange {
        let location:Int = textView.offset(from: textView.beginningOfDocument, to: textRange.start)
        let length:Int = textView.offset(from: textRange.start, to: textRange.end)
        return NSMakeRange(location, length)
    }
    
    //Método para acionar o segmented control e direcionar para o controller de Livros
    @objc func vaiParaLivros(sender: UISegmentedControl) {
        sqlparcial = "" //"select BOOK_NAME as name from books;"
        
        switch sender.selectedSegmentIndex {
        case 0:
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Livros") as? ListaLivrosViewController {
                viewController.query = sqlparcial
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }

        default: break

        }
    }
    
    //Carregar o controller Ajustes
    @objc func addCard(sender: AnyObject) {

        let storyboard : UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Ajustes")
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        vc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        let popover: UIPopoverPresentationController! = vc.popoverPresentationController!
        popover.delegate = self
        popover.permittedArrowDirections = UIPopoverArrowDirection.left
        popover.barButtonItem = sender as? UIBarButtonItem
        vc.popoverPresentationController?.sourceView = self.view
        vc.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        vc.presentingViewController?.viewDidAppear(true)
        
        present(vc, animated: true, completion:nil)
    }
    

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.popover 
    }
    
    //Fazer o botao circular
    func configureButton()
    {
        //Botão capitulo anterior
        btnAnteriorCapitulo.layer.cornerRadius = 0.5 * btnAnteriorCapitulo.bounds.size.width
        //btnAnteriorCapitulo.layer.borderColor = UIColor(red: 255/255, green: 246/255, blue: 211/255, alpha: 1.0) .cgColor as CGColor/* #fff6d3 */
        btnAnteriorCapitulo.layer.borderColor = UIColor(red: 114/255, green: 0/255, blue: 45/255, alpha: 1.0) .cgColor as CGColor
        btnAnteriorCapitulo.layer.borderWidth = 0
        btnAnteriorCapitulo.clipsToBounds = true
        
        //Botão capítulo anterior
        btnProximoCapitulo.layer.cornerRadius = 0.5 * btnProximoCapitulo.bounds.size.width
        //btnProximoCapitulo.layer.borderColor = UIColor(red: 255/255, green: 246/255, blue: 211/255, alpha: 1.0) .cgColor as CGColor/* #fff6d3 */
        btnProximoCapitulo.layer.borderColor = UIColor(red: 114/255, green: 0/255, blue: 45/255, alpha: 1.0) .cgColor as CGColor
        btnProximoCapitulo.layer.borderWidth = 0
        btnProximoCapitulo.clipsToBounds = true
        
        //Botão próximo livro
        btnProximoLivro.layer.cornerRadius = 0.5 * btnProximoCapitulo.bounds.size.width
        btnProximoLivro.layer.borderColor = UIColor(red: 255/255, green: 246/255, blue: 211/255, alpha: 1.0) .cgColor as CGColor/* #fff6d3 */
        btnProximoLivro.layer.borderColor = UIColor(red: 114/255, green: 0/255, blue: 45/255, alpha: 1.0) .cgColor as CGColor
        btnProximoLivro.layer.borderWidth = 0
        btnProximoLivro.clipsToBounds = true
        
        //Botão Compartilhar
        btnCompartilhar.layer.cornerRadius = 0.5 * btnCompartilhar.bounds.size.width
        btnCompartilhar.layer.borderColor = UIColor(red: 255/255, green: 246/255, blue: 211/255, alpha: 1.0) .cgColor as CGColor/* #fff6d3 */
        btnCompartilhar.layer.borderColor = UIColor(red: 114/255, green: 0/255, blue: 45/255, alpha: 1.0) .cgColor as CGColor
        btnCompartilhar.layer.borderWidth = 0
        btnCompartilhar.clipsToBounds = true
        
        //Botao Marcar
        btnMarcar.layer.cornerRadius = 0.5 * btnMarcar.bounds.size.width
        btnMarcar.layer.borderColor = UIColor(red: 255/255, green: 246/255, blue: 211/255, alpha: 1.0) .cgColor as CGColor/* #fff6d3 */
        btnMarcar.layer.borderColor = UIColor(red: 114/255, green: 0/255, blue: 45/255, alpha: 1.0) .cgColor as CGColor
        btnMarcar.layer.borderWidth = 0
        btnMarcar.clipsToBounds = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        textView?.isSelectable = true
        formatarTexto()
        segment.sizeToFit()

        self.tabBarController?.tabBar.items![2].isEnabled = false
    }
    
    
    //Método para posicionar o textView de acordo com o Versículo selecionado
    override func viewDidLayoutSubviews() {
        let str1:NSString! = textView!.text! as NSString
        
        let substringRange = str1.range(of: String(versiculo1)+" ")
        let glyphRange = textView!.layoutManager.glyphRange(forCharacterRange: substringRange, actualCharacterRange: nil)
        let rect = textView?.layoutManager.boundingRect(forGlyphRange: glyphRange, in: textView!.textContainer)
        let topTextInset = textView?.textContainerInset.top
        
        var yy: CGFloat!
        
        //Se for selecionado o botao proximolivro entao ir para o topo do capitulo fazendo a rolagem
        if botaoProximo == false {
            yy = topTextInset! + (rect?.origin.y)!
              } else
        {   yy = topTextInset }
        
        let contentOffset = CGPoint(x: 0, y: yy)
        textView?.setContentOffset(contentOffset, animated: false)
        
        //Configurar os botoes capitulo anterior e posterior
        configureButton()
        
        //Scroll to a uitableview position
        if (versiculoInt  == 0) {
            versiculoScrow = 0 }
        else {
            versiculoScrow = versiculoInt!-1
        }
        
        let indice = NSIndexPath(row: versiculoScrow, section: 0)
        tblNova.scrollToRow(at: indice as IndexPath, at: .top, animated: false)

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Método para alterar a cor da string principal e da substring
    func apply (string: NSMutableAttributedString, word: String) -> NSMutableAttributedString {
        let range = (string.string as NSString).range(of: word)
        return apply(string: string, word: word, range: range, last: range)
    }
    
    func apply (string: NSMutableAttributedString, word: String, range: NSRange, last: NSRange) -> NSMutableAttributedString {
        //Ler as preferencias do sistema e aplicar os fontes com os tamanhos da configuraçào
        let vetorPreferencias: [PreferenciasSistema]! = DBManager.shared.preferenciasSistema()!
        let tamanhoGenerico: String! = vetorPreferencias[0].FonteTamanho!
        let tamanhoMenor: CGFloat! = CGFloat(Double(tamanhoGenerico)!-4)
        
        if range.location != NSNotFound {
            string.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: range)
            string.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: tamanhoMenor), range: range)
            //string.addAttribute(NSFontAttributeName, value:  UIFont(name: "Kailasa", size: 17.0)!,
            //                    range: range)

            //string.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 16), range: range)

           
//            let start = last.location + last.length
//            let end = string.string.characters.count - start
//            let stringRange = NSRange(location: start, length: end)
//            let newRange = (string.string as NSString).range(of: word, options: [], range: stringRange)
//            apply(string: string, word: word, range: newRange, last: range)
        }
        return string
    }
    
    @IBAction func MostrarProximoLivro () {
        // Método para mostrar o próximo livro
        proximoLivro = String(Int(livroID)! + 1)
        if (Int(proximoLivro)! <= 66) {
            versiculoSel = DBManager.shared.loadVersiculoPorLivroCapituloVerso(livro: proximoLivro,
                                                                        capitulo: "1",
                                                                           verso: 1)!
        //Atualiza o proximo livro para poder sempre aumentar o numero do livro
            livroID = proximoLivro
        
        //Mostrar no topo o Livro, Capítulo e Versículo
            nomeCapituloVersiculo.text = versiculoSel[0].name + " 1:1"
            
            title = nomeCapituloVersiculo.text!
        
            formatarTexto()

            botaoProximo = true
            viewDidLayoutSubviews()
            
            //Limite de livro e capítulo da Bíblia
            if (livroID == "66") && (capitulo == "22") {
                btnProximoCapitulo.isHidden = true
                btnProximoLivro.isHidden = true
            } else {
                if (livroID == "66") {
                    btnProximoLivro.isHidden = true
                }
                btnProximoCapitulo.isHidden = false
                btnAnteriorCapitulo.isHidden = false
            }
        }

    }
    
    @IBAction func MostrarProximoCapítulo () {
        // Método para mostrar o próximo capítulo
        versiculoSel = DBManager.shared.loadVersiculoPorLivroCapituloVerso(livro: String(Int(livroID)!),
                                                                           capitulo: String(Int(capitulo)!+1),
                                                                    verso: 1)
        //Verificar se o capitulo pertence ao livroID
        if versiculoSel == nil {
            versiculoSel = DBManager.shared.loadVersiculoPorLivroCapituloVerso(livro: String(Int(livroID)!+1),
                capitulo: "1",
                verso: 1)
            livroID = String(Int(livroID)!+1)
            capitulo = "1"
            versiculoInt=1
        } else {
        
        //Atualiza o proximo capítulo para poder sempre aumentar o numero do capítulo
        capitulo = String(Int(capitulo)!+1)
        versiculoInt = 1
        }
        
        //Mostrar no topo o Livro, Capítulo e Versículo
        nomeCapituloVersiculo.text! =
            versiculoSel[0].name! + " " + capitulo + ":1"
        title = nomeCapituloVersiculo.text
        nomeCapitulo = versiculoSel[0].name + " " + capitulo
        
        //segmented control
        segment.setTitle(nomeCapituloVersiculo.text!,forSegmentAt: 0)
        
        tblNova.reloadData()
        
        //Scroll to a uitableview position
//        let indice = NSIndexPath(row: Int(0), section: 0)
//        DispatchQueue.main.async {
//            self.tblNova.scrollToRow(at: indice as IndexPath, at: .top, animated: false)
//        }
        
        //viewDidLayoutSubviews()
        
        formatarTexto()
        
        botaoProximo = true
        
        //Limite de livro e capítulo da Bíblia
        if (livroID == "66") && (capitulo == "22") {
            btnProximoCapitulo.isHidden = true
            btnProximoLivro.isHidden = true
        } else {
            btnProximoCapitulo.isHidden = false
            btnAnteriorCapitulo.isHidden = false
        }
    }
    
    func convertIntToString (capit: Int) throws -> String {
        let capituloConvertidoParaString: String? = String(capit);
        
        guard (capituloConvertidoParaString != nil) else { throw IntToString.NotANumber }
        
        return capituloConvertidoParaString!
    }
    
    @IBAction func MostrarCapituloAnterior () {
        // Método para mostrar o capítulo anterior
        var capitulo_test: String! = ""
        do {
            //Subtrai o capitulo em 1 e converte para string
            let capituloInt: Int = Int(capitulo)! - 1
            capitulo_test = try convertIntToString(capit: capituloInt)
            print( capitulo_test as Any )
        } catch { //pega qualquer exceção não especificada anteriormente
            //faz algo aqui
            print("Erro na variavel capitulo")
        }
        
        versiculoSel = DBManager.shared.loadVersiculoPorLivroCapituloVerso(livro: livroID,
                                                                           capitulo:capitulo_test,
                                                                           verso: 1)
        //Verificar se o capitulo pertence ao livroID
        if versiculoSel == nil {
            versiculoSel = DBManager.shared.loadVersiculoPorLivroCapituloVerso(livro: String(Int(livroID)!-1),
                                capitulo: "1",
                                verso: 1)
            livroID = String(Int(livroID)!-1)
            capitulo = "1"
            versiculoInt = 1
        } else {
            
            //Atualiza o proximo capítulo para poder sempre aumentar o numero do capítulo
            capitulo = capitulo_test
            versiculoInt = 1
        }

        
        //Mostrar no topo o Livro, Capítulo e Versículo
        nomeCapituloVersiculo.text =
            versiculoSel[0].name + " " + capitulo + ":1"
        title = nomeCapituloVersiculo.text
        nomeCapitulo = versiculoSel[0].name + " " + capitulo
        
        //segmented control
        segment.setTitle(nomeCapituloVersiculo.text!,forSegmentAt: 0)
        
        
        formatarTexto()
        
        tblNova.reloadData()
        
        let indice = NSIndexPath(row: Int(0), section: 0)
        DispatchQueue.main.async {
            self.tblNova.scrollToRow(at: indice as IndexPath, at: .top, animated: false)
        }
        
        botaoProximo = true
        //viewDidLayoutSubviews()
        
        
        //Limite de livro e capítulo da Bíblia
        if (livroID == "1") && (capitulo == "1") {
            btnAnteriorCapitulo.isHidden = true
            btnProximoLivro.isHidden = false
            btnProximoCapitulo.isHidden = false
        } else {
            btnAnteriorCapitulo.isHidden = false
            if (livroID == "66") && (capitulo != "22") {
                btnProximoCapitulo.isHidden = false
            }
        }
    }

    func formatarTexto() {
 
        //Ler as preferencias do sistema e aplicar os fontes com os tamanhos da configuraçào
        var tamanhoGenerico : String! = ""
        
        let vetorPreferencias: [PreferenciasSistema]! = DBManager.shared.preferenciasSistema()!
        let fonteGenerica: String! = vetorPreferencias[0].FonteNome!
        tamanhoGenerico = vetorPreferencias[0].FonteTamanho!
        let fundo_noturno_preferencia = vetorPreferencias[0].FundoNoturno
        
        let corNumero: String!
        let corLetras: String!
        
        if (tamanhoGenerico == "" ) {
            tamanhoGenerico = "17"
        }
        
        //Verifica se uso o fundo noturno
        if (fundo_noturno_preferencia == "SIM") {
            corNumero = letras_brancas
            corLetras = letras_brancas
            fundo_bg = fundo_noturno
            fundo_bg_selecionador = fundo_orange
            tblNova.backgroundColor = UIColor.colorWithHexString(letras_pretas)
        } else {
            corNumero = numero_versiculo_azul
            corLetras = letras_pretas
            fundo_bg = fundo_default
            fundo_bg_selecionador = fundo_amarelo
            tblNova.backgroundColor = UIColor.colorWithHexString(fundo_default)
        }
        
        //Formatação da cor do número do verso
        let combination : NSMutableAttributedString! = NSMutableAttributedString()
        let tamanhoMenor: CGFloat! = CGFloat(Double(tamanhoGenerico)!-4)
        let tamanhoMaior: CGFloat! = CGFloat(Double(tamanhoGenerico)!)

        let yourAttributes = [NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString(corNumero),
                              NSAttributedString.Key.font: UIFont(name: fonteGenerica, size: tamanhoMenor)]
        
        let yourOtherAttributes  =
            [NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString(corLetras),
             NSAttributedString.Key.font: UIFont(name: fonteGenerica, size: tamanhoMaior)! ]
        

        
        let yourOtherAttributesBG =
                [NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString(corLetras),
                 NSAttributedString.Key.font: UIFont(name: fonteGenerica, size: tamanhoMaior)!,
                 NSAttributedString.Key.backgroundColor: UIColor.colorWithHexString(fundo_bg)]
        

        for v in versiculoSel {
            let partOne = NSMutableAttributedString(string: String(v.verso)
                + " ", attributes: (yourAttributes as Any as! [NSAttributedString.Key : Any]))
            
            let partTwo = NSMutableAttributedString(string: String(v.text),
                                                    attributes: (yourOtherAttributes as Any as! [NSAttributedString.Key : Any]))
            
            let partTwoBG = NSMutableAttributedString(string: String(v.text),
                            attributes: yourOtherAttributesBG )
            
            let partTres = NSMutableAttributedString(string: "\n\n", attributes: nil)
        
            combination.append(partOne)
            if (textoCompletoVersiculoDia! != String(v.text)) {
                combination.append(partTwo)
            } else {
                combination.append(partTwoBG)
            }
            combination.append(partTres)
        }
        //Ajustar o espaço entre as linhas
        let paragraphStyle : NSMutableParagraphStyle! = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.5
        paragraphStyle.lineHeightMultiple = 1
        
        let attString: NSMutableAttributedString! = combination
        attString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle as Any, range:NSMakeRange(0, attString.length))
        
        textView?.attributedText = attString

        tblNova.reloadData()
        
        //Fonte e tamanho do segmented control
        let attr = NSDictionary(object: UIFont(name: fonteGenerica, size: tamanhoMaior)!, forKey: NSAttributedString.Key.font as NSCopying)
        segment.setTitleTextAttributes((attr as [NSObject : AnyObject] as! [NSAttributedString.Key : Any]) , for: .normal)

    }
    
    
    // Criaçao do segue para passar dados para a proxima tela
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showLivros" {
            let livrosViewController = segue.destination as! ListaLivrosViewController
            livrosViewController.query = sqlparcial
        }
        
        if segue.identifier == "marcacao" {
            let marcacaoViewController = segue.destination as! MarcacaoViewController
            marcacaoViewController.textoVersiculoView = versiculo_marcado_segue
            
            marcacaoViewController.nomeCapitulo = nomeCapitulo
            marcacaoViewController.capitulo = capitulo
            marcacaoViewController.livroID = self.livroID
            marcacaoViewController.versiculo1 = versiculo_marcacao 
            marcacaoViewController.versiculos_selecionados =
                versiculos_selecionados_tblnova

            
        }

    }
    
    //Delegate para ativar o viewdidappear quando estiver no Ipad
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.viewWillAppear(true)
    }
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        viewController.viewDidAppear(true)
    }
    
    //delegate do Branch
    func configureControl(withData params: [AnyHashable : Any]!) {
        let dict = params as Dictionary
        if dict["$desktop_url"] != nil {
            // show the picture
        }
    }
    
    
    var deepLinkingCompleteDelegate: BranchDeepLinkingControllerCompletionDelegate?
    func closePressed()  {
        self.deepLinkingCompleteDelegate!.deepLinkingControllerCompleted()
    }
    
    //Compartilhar o link do Branch com o Face
    @IBAction func sharedSDK() {
        //Montagem do versículo do dia no Face
        //var textoFormatadoVerso : String! = ""
        var textoFormatadoFinal : String! = ""
        var totcaracteres : Int! = 0
        
        var textoTratado: String! = versiculoSel[0].text
        
        //Tramento para Twitter
        totcaracteres = textoTratado.count
        if totcaracteres >= 137 {
            totcaracteres =  112
        }
        
        textoTratado = textoTratado.substring(to: totcaracteres) + "..."
        
        textoFormatadoFinal =  textoTratado!
        
        let qString: String! = "?a=" + livroID! + "&b=" + capitulo! + ":" +
            String(versiculo1)
        
        let branchUniversalObject = BranchUniversalObject(canonicalIdentifier: UUID().uuidString)
        branchUniversalObject.title = nomeCapituloVersiculo.text! + " - NVT"
        branchUniversalObject.contentDescription = textoFormatadoFinal!
        branchUniversalObject.addMetadataKey("qstring", value: qString!)
        
        
        let linkProperties: BranchLinkProperties = BranchLinkProperties()
        linkProperties.feature = "invites"
        linkProperties.addControlParam("$desktop_url", withValue: "biblianvt://"+qString)
        linkProperties.addControlParam("$deeplink_path", withValue:  qString)
        linkProperties.addControlParam("$always_deeplink", withValue: "true")
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
       
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUITextDirection(_ input: Int) -> UITextDirection {
	return UITextDirection(rawValue: input)
}
