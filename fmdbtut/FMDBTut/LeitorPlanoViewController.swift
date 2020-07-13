//
//  LeitorPlanoViewController.swift
//  BibliaNVT
//
//  Created by MacBook Pro i7 on 10/02/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit


class LeitorPlanoViewController: UIViewController,UITextViewDelegate,
UITableViewDataSource,UITableViewDelegate, Mensagem{
    
    //Variáveis para receber o Livro, capítulo(s) e versículo(s)
    var Livro: String!
    var Capitulo1: String!
    var Capitulo2: String!
    var Versiculo1: String!
    var Versiculo2: String!
    var livroExtenso: String!
    
    //Outlets para os botões de Voltar e Próximo Capítulo
    @IBOutlet var btnAnterior: UIButton!
    @IBOutlet var btnProxCapitulo: UIButton!
    @IBOutlet var btnMarcar: UIButton!
    @IBOutlet var btnCompart: UIButton!
    @IBOutlet var btnCopiar: UIButton!
    
    //Outlet para a listview de plano
    @IBOutlet var tblNovaPlano: UITableView!
    @IBOutlet var stackView_c : UIStackView!
    
    //Range anterior para comparar no long press
    var textoAnterior:String!
    var flag:Bool! = false
    var rangeAnterior:NSRange!
    var CliqueDuplo: Bool! = false
    
    var nomeCapituloVersiculo: String!
    var botaoProximo: Bool!
    var moverCapitulo: String! = ""
    var nomeCapitulo: String! = ""
    
    //Outlet para mostrar o texto do versículo selecionado
    @IBOutlet var textView: UITextView!

    var livroID : String!
    var capitulo : String!
    var versiculo1 : Int32!
    var versiculoInt : Int!
    var textoCompletoVersiculoDia: String!
    
    var versiculoSel: [LivroCapituloVersiculo]!
    var versiculoSelTbl:  [VersoInfo1]!
    var versiculo_marcado_segue: String! = ""
    var somente_versiculo_selecionado : String! = ""
    var versiculo_marcado:String!
    var versiculo_marcacao: Int32!
    
    //Variavel para receber as linhas selecionadas na tblNova
    var selectedCells:[Int] = []
    
    //Array para receber todos os versiculos selecionados na tblNova
    var versiculos_selecionados_tblnova:[Int32] = []
    
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
        
        //Preparar a listview
        tblNovaPlano.dataSource = self
        tblNovaPlano.delegate = self
        tblNovaPlano.rowHeight = UITableView.automaticDimension
        tblNovaPlano.estimatedRowHeight = 25
        

        //Prepara a variavel para receber o numero do versiculo se for passado
        if (versiculo1 != nil ) {
            versiculoInt = Int(versiculo1)
        } else {
            versiculoInt = 0
        }
        
        
        //Com a abreviação do livro, capitulo e versiculos buscar na base o texto desejado

        // A lógica para controle dos botões :
        //      Se o capitulo2 estiver preenchido então mostrar o Livro e os capitulos1 e 2.
        btnAnterior.isEnabled = false
        
        if (Capitulo2 != nil) {
            btnProxCapitulo.isEnabled = true
        } else {
            // Se o capitulo2 nao estiver preenchido verificar se os versiculos estao preenchidos
            // se versiculos preenchidos entao mostrar livro, capitulo1 e versiculo1 ate
            //versiculo2
            btnProxCapitulo.isEnabled = false
            if (Versiculo1 != nil) && (Versiculo2 != nil) {
                btnProxCapitulo.isEnabled = true
            } else {
                // Mostrar somente o livro e o capitulo1
                btnProxCapitulo.isEnabled = false
                
            }
        }
        
        //Carrega os dados do Livro selecionado
        versiculoSel = DBManager.shared.trazerLivroCapitulo(livro: Livro,
                                                            capituloCorrente: Capitulo1,
                                                            capitulo1: Capitulo1, capitulo2: Capitulo2, versiculo1: Versiculo1, versiculo2: Versiculo2)
        
        //Se capitulo2 estiver vazio então mostrar os versículos1 e 2
        livroExtenso = versiculoSel[0].livro
        if (Capitulo2 == "") {
            if (Versiculo1 != "") && (Versiculo2 != "") {
                nomeCapituloVersiculo = livroExtenso! + " " + Capitulo1 + "."
                nomeCapituloVersiculo = nomeCapituloVersiculo + Versiculo1 + "-" + Versiculo2
            }
                else {
                    nomeCapituloVersiculo = livroExtenso! + " " + Capitulo1
                }
            }
        else {
            nomeCapituloVersiculo = livroExtenso! + " " + Capitulo1
        }
        
        title = nomeCapituloVersiculo
        self.livroID = versiculoSel[0].livroID
        nomeCapitulo = livroExtenso! + " " + versiculoSel[0].capítulo
        
        //Delegate no textview para o controller
        textView.delegate = self
        
        //self.automaticallyAdjustsScrollViewInsets = true
        if #available(iOS 11.0, *) {
            textView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        formatarTexto()
        
        //Back ground da tela
        view.self.backgroundColor = UIColor.colorWithHexString(fundo_bg)
        
        //Na carga da tela atribuir o numero do capitulo1 à variavel moverCapitulo
        //controlar que essa variavel fique sempre no limite entre o capitulo1 e o
        //capitulo2
        moverCapitulo! = Capitulo1
        
        if Capitulo2 == "" {
            btnProxCapitulo.isEnabled = false
            btnAnterior.isEnabled = false
        }
        
        btnAnterior.isEnabled = false
        
        botaoProximo = false
        
        //Back ground da tela
        //view.self.backgroundColor = UIColor.colorWithHexString("#f4f4ee")
        textView.backgroundColor = UIColor.colorWithHexString("#f4f4ee")
        tblNovaPlano.backgroundColor = UIColor.colorWithHexString("#f4f4ee")
        stackView_c.sizeToFit()
        stackView_c.addBackground(color: UIColor.colorWithHexString("#E9FFE9"))
        
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
        
        //Na carga desta tela carregar a variavel capitulo com capitulo1
        //Se houver movimento para o segundo capitulo entao atualizar esta variavel
        capitulo = Capitulo1
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
                    capitulo = versiculoSel[0].capítulo
                    
                    nomeCapituloVersiculo =
                        versiculoSel[0].livro + " " + capitulo! //+ ":" + String(versiculo1)
                    
                    
                    versiculo_marcado = nomeCapituloVersiculo! + "\n\n" +
                        textView!.text(in:range1)! + "\n\n" +
                        "Bíblia Sagrada, Nova Versão Transformadora\n" +
                        "Copyright © 2016 por Editora Mundo Cristão.\n" +
                    "Todos os direitos reservados.\n";
                    
                    somente_versiculo_selecionado = textView!.text(in:range1)! + "\n\n" +
                        "Bíblia Sagrada, Nova Versão Transformadora\n" +
                        "Copyright © 2016 por Editora Mundo Cristão.\n" +
                    "Todos os direitos reservados.\n";
                    
                    
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
                                                        self.performSegue(withIdentifier: "marcacaopeloplano", sender: self)
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

    //Carregar o controller Ajustes
    @objc func addCard(sender: AnyObject) {
        
        let storyboard : UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Ajustes")
        vc.modalPresentationStyle = UIModalPresentationStyle.popover//formSheet
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        let popover: UIPopoverPresentationController! = vc.popoverPresentationController!
        //popover.delegate = self
        popover.permittedArrowDirections = UIPopoverArrowDirection.any
        popover.barButtonItem = sender as? UIBarButtonItem
        vc.popoverPresentationController?.sourceView = self.view
        vc.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        vc.presentingViewController?.viewDidAppear(true)
        present(vc, animated: true, completion:nil)
//        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "Ajustes")
//        vc.modalPresentationStyle = UIModalPresentationStyle.popover
//        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
//        popover.barButtonItem = sender as? UIBarButtonItem
//        popover.delegate = self
//        present(vc, animated: true, completion:nil)
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        formatarTexto()
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none    //fullscreen
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        textView?.isSelectable = true
        formatarTexto()
        self.tabBarController?.tabBar.items![2].isEnabled = false
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navigationController = UINavigationController(rootViewController: controller.presentedViewController)
//        let btnDone = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(ListaVersiculoViewController.dismiss as (ListaVersiculoViewController) -> () -> ()))
        let btnDone = UIBarButtonItem(title: "Sair", style: .done, target: self,
                                      action: #selector(dismiss(_:)))
        navigationController.topViewController?.navigationItem.rightBarButtonItem = btnDone
        return navigationController
    }
    
    @objc private func dismiss(_ tapGestureDC: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func MoveProximoCapitulo() {
        //Carrega os dados do Livro selecionado no próximo capitulo
        //Usar para o botão 2 de próximo capitulo
        moverCapitulo! = String(Int(moverCapitulo)!+1)
        if (Int(moverCapitulo!)! > Int(Capitulo2)!)  {
            moverCapitulo! = Capitulo2
        } else {
        versiculoSel = DBManager.shared.trazerLivroCapitulo(livro: Livro,
                                                            capituloCorrente: moverCapitulo,
                                                            capitulo1: Capitulo1 , capitulo2: Capitulo2, versiculo1: Versiculo1, versiculo2: Versiculo2)
        livroExtenso = versiculoSel[0].livro
            
        nomeCapituloVersiculo = livroExtenso! + " " +  moverCapitulo!
        title = nomeCapituloVersiculo
        self.livroID = versiculoSel[0].livroID
        nomeCapitulo = livroExtenso! + " " + versiculoSel[0].capítulo
        capitulo = versiculoSel[0].capítulo
        
        //Se o proximo capitulo for o ultimo entao esconde o botão Próximo
        if (Int(moverCapitulo!)! == Int(Capitulo2)!)  {
            botaoProximo! = false
            btnProxCapitulo.isEnabled = false
            btnAnterior.isEnabled = true
        } else {
            //Se o proximo capitulo for menor que o ultimo e maior que primeiro
            if (Int(moverCapitulo!)! < Int(Capitulo2)!) &&
                (Int(moverCapitulo!)! > Int(Capitulo1)!){
                botaoProximo! = true
                btnProxCapitulo.isEnabled = true
                btnAnterior.isEnabled = true
            }
        }

        formatarTexto()
            
        viewDidLayoutSubviews()
        }
    }
    
    @IBAction func MoveCapituloAnterior() {
        //Carrega os dados do Livro selecionado do capitulo anterior
        //Usar para o botão 1 de  capitulo anterior
        moverCapitulo = String(Int(moverCapitulo)!-1)
        if (Int(moverCapitulo!)! < Int(Capitulo1)!)  {
            moverCapitulo! = Capitulo1
        } else {
        versiculoSel = DBManager.shared.trazerLivroCapitulo(livro: Livro,
                                                capituloCorrente: moverCapitulo,
                                                capitulo1: Capitulo1 , capitulo2: Capitulo2,versiculo1: Versiculo1, versiculo2: Versiculo2)
        livroExtenso = versiculoSel[0].livro
        
        nomeCapituloVersiculo = livroExtenso! + " " +  moverCapitulo!
        title = nomeCapituloVersiculo
        self.livroID = versiculoSel[0].livroID
        nomeCapitulo = livroExtenso! + " " + versiculoSel[0].capítulo
        capitulo = versiculoSel[0].capítulo
        
        //Se o proximo capitulo for o primeiro entao esconde os botão Primeiro
            if (Int(moverCapitulo!)! == Int(Capitulo1)!)  {
                botaoProximo! = true
                btnProxCapitulo.isEnabled = true
                btnAnterior.isEnabled = false
            } else {
                //Se o proximo capitulo for menor que o ultimo e maior que primeiro
                if (Int(moverCapitulo!)! < Int(Capitulo2)!) &&
                    (Int(moverCapitulo!)! > Int(Capitulo1)!){
                    botaoProximo! = true
                    btnProxCapitulo.isEnabled = true
                    btnAnterior.isEnabled = true
                }
            }
        
        formatarTexto()
        
        viewDidLayoutSubviews()
        }
    }

    //Método para posicionar o textView de acordo com o Versículo selecionado
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let str1 = textView.text as NSString
        var numVersiculo:Int
        
        if (Versiculo1 == "") {
            numVersiculo = 1
            Versiculo1 = "1"
        } else {
            numVersiculo = Int(Versiculo1)!
        }
        
        let substringRange = str1.range(of: Versiculo1 + " ")
        let glyphRange = textView.layoutManager.glyphRange(forCharacterRange: substringRange, actualCharacterRange: nil)
        let rect = textView.layoutManager.boundingRect(forGlyphRange: glyphRange, in: textView.textContainer)
        let topTextInset = textView.textContainerInset.top
        
        var yy: CGFloat!
        
        //Se não for selecionado o versiculo entao ir para o topo do capitulo fazendo a rolagem
        if numVersiculo > 1 {
            yy = topTextInset + rect.origin.y
        } else
        {   yy = topTextInset }
        
        let contentOffset = CGPoint(x: 0, y: yy)
        //if botaoProximo == true {
            textView.setContentOffset(contentOffset, animated: false)
        //}
        
        //Scroll to a uitableview position
        var posicao: Int! = 0
        if (versiculoInt > 0) {
            posicao = versiculoInt - 1
        } else {
            posicao = 0
        }
        let indice = NSIndexPath(row: posicao, section: 0)
        tblNovaPlano.scrollToRow(at: indice as IndexPath, at: .top, animated: false)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Criaçao do segue para passar dados para a proxima tela
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "marcacaopeloplano" {
            let marcacaoViewController = segue.destination as! MarcacaoViewController
            marcacaoViewController.textoVersiculoView = versiculo_marcado_segue
            
            marcacaoViewController.nomeCapitulo = nomeCapitulo
            marcacaoViewController.capitulo = capitulo
            marcacaoViewController.livroID = self.livroID
            marcacaoViewController.versiculo1 = versiculo_marcacao //(Int32(newstring!) as Any as! Int32)  //self.versiculo1
            marcacaoViewController.versiculos_selecionados =
            versiculos_selecionados_tblnova
            
        }
    }
    
    func formatarTexto() {
        //Ler as preferencias do sistema e aplicar os fontes com os tamanhos da configuraçào
        let vetorPreferencias: [PreferenciasSistema]! = DBManager.shared.preferenciasSistema()!
        let fonteGenerica: String! = vetorPreferencias[0].FonteNome!
        let tamanhoGenerico: String! = vetorPreferencias[0].FonteTamanho!
        let fundo_noturno_preferencia = vetorPreferencias[0].FundoNoturno
        
        let corNumero: String!
        let corLetras: String!
        
        //Verifica se uso o fundo noturno
        if (fundo_noturno_preferencia == "SIM") {
            corNumero = letras_brancas
            corLetras = letras_brancas
            fundo_bg = fundo_noturno
            fundo_bg_selecionador = fundo_orange
            tblNovaPlano.backgroundColor = UIColor.colorWithHexString(letras_pretas)
        } else {
            corNumero = numero_versiculo_azul
            corLetras = letras_pretas
            fundo_bg = fundo_default
            fundo_bg_selecionador = fundo_amarelo
            tblNovaPlano.backgroundColor = UIColor.colorWithHexString(fundo_default)
        }
        
        //Formatação da cor do número do verso
        let combination = NSMutableAttributedString()
        let tamanhoMenor: CGFloat! = CGFloat(Double(tamanhoGenerico)!-1)
        let tamanhoMaior: CGFloat! = CGFloat(Double(tamanhoGenerico)!)
        
        let yourAttributes = [NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString(corNumero),
                              NSAttributedString.Key.font: UIFont(name: fonteGenerica, size: tamanhoMenor)]
        
        let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString(corLetras),
                                   NSAttributedString.Key.font: UIFont(name: fonteGenerica, size: tamanhoMaior) ]
        
        for v in versiculoSel {
            let partOne = NSMutableAttributedString(string: String(v.verse)
                + " ", attributes: yourAttributes as Any as? [NSAttributedString.Key : Any] )
            let partTwo = NSMutableAttributedString(string: String(v.texto), attributes: yourOtherAttributes as Any as? [NSAttributedString.Key : Any])
            let partTres = NSMutableAttributedString(string: "\n\n", attributes: nil)
            
            combination.append(partOne)
            combination.append(partTwo)
            combination.append(partTres)
        }
        //Ajustar o espaço entre as linhas
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.5
        paragraphStyle.lineHeightMultiple = 1
        
        let attString: NSMutableAttributedString = combination
        attString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attString.length))
        
        textView.attributedText! = attString
        
        tblNovaPlano.reloadData()
        
    }
    
    @IBAction func close(segue:UIStoryboardSegue) {
        
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
    
    //Métodos da tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return versiculoSel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableNovaPlanoViewCell
        
        // Configure the cell...
        cell.lblPlanoVerso?.attributedText = makeAttributedString(
            title: String(versiculoSel[indexPath.row].texto),
            cor: UIColor.colorWithHexString(fundo_default),
            maior: true,
            verso: String(versiculoSel[indexPath.row].verse)  )
        
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
        
        versiculo_marcacao = Int32(versiculoSel[(indexPath.row)].verse)
        if (versiculo_marcacao != nil) {
            versiculos_selecionados_tblnova.append(versiculo_marcacao)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.backgroundColor = UIColor.colorWithHexString(fundo_bg)
            versiculo_marcacao = Int32(versiculoSel[(indexPath.row)].verse)
            
            if (versiculo_marcacao != nil) {
                //Remove o elemento do array
                if let index = versiculos_selecionados_tblnova.firstIndex(
                    of: Int32(versiculoSel[(indexPath.row)].verse)!) {
                    versiculos_selecionados_tblnova.remove(at: index)
                    //self.stackView_c.isHidden = true
                }
            }
        }
    }
    
    @IBAction func Compartilhar_versiculos() {
        var Temp1: String!=""
        versiculo_marcado = ""
        
        if let indexPaths = tblNovaPlano.indexPathsForSelectedRows?.sorted() {
            let contador = indexPaths.count
            for i in 0...contador-1 {
                let thisPath = indexPaths[i] as IndexPath
                let cell = tblNovaPlano.cellForRow(at: thisPath as IndexPath) as! TableNovaPlanoViewCell?
                Temp1 = cell!.lblPlanoVerso.text!
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
        
        if let indexPaths = tblNovaPlano.indexPathsForSelectedRows?.sorted() {
            let contador = indexPaths.count
            
            for i in 0...contador-1 {
                let thisPath = indexPaths[i] as IndexPath
                
                if (tblNovaPlano.cellForRow(at: thisPath as IndexPath) as! TableNovaPlanoViewCell? != nil) {
                    let cell = tblNovaPlano.cellForRow(at: thisPath as IndexPath) as! TableNovaPlanoViewCell?
                    Temp1 = cell!.lblPlanoVerso.text!
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
            
            self.performSegue(withIdentifier: "marcacaopeloplano", sender: self)
        }
        else {
            versiculo_marcado! = ""
            mensagem(message: "Selecione o(s) versículo(s)!")
        }
    }
    
    @IBAction func Copiar_versiculos() {
        var Temp1: String!=""
        versiculo_marcado = ""
        
        if let indexPaths = tblNovaPlano.indexPathsForSelectedRows?.sorted() {
            let contador = indexPaths.count
            
            for i in 0...contador-1 {
                let thisPath = indexPaths[i] as IndexPath
                if (tblNovaPlano.cellForRow(at: thisPath as IndexPath) as! TableNovaPlanoViewCell? != nil) {
                    let cell = tblNovaPlano.cellForRow(at: thisPath as IndexPath) as! TableNovaPlanoViewCell?
                    Temp1 = cell!.lblPlanoVerso.text!
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
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUITextDirection(_ input: Int) -> UITextDirection {
	return UITextDirection(rawValue: input)
}
