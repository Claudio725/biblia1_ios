//
//  DetalheViewController.swift
//  FMDBTut
//
//  Created by MacBook Pro i7 on 30/12/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit
import Social
import MessageUI
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import Foundation
import Branch

extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}


class DetalheTableViewController: UIViewController,MFMailComposeViewControllerDelegate,FBSDKSharingDelegate {

    @IBOutlet var testamento: UILabel?
    
    @IBOutlet var livro:UILabel?
    
    @IBOutlet var btnFace : UIButton?
    
    @IBOutlet var btnEmail : UIButton?
    
    @IBOutlet var btnTwitter : UIButton?
    
    @IBOutlet var btnLerCapituloInteiro : UIButton!
    
    @IBOutlet var texto: UITextView!
    
    var sqlVersiculo: String!
    
    var verso: [VersoInfo]!
    
    var nome : String! = ""
    var capitulo: String! = ""
    var verso_share: Int32 = 0
    
    
    //Enum para montar no email
    enum MIMEType: String {
        case jpg = "image/jpeg"
        case png = "image/png"
        case doc = "application/msword"
        case ppt = "application/vnd.ms-powerpoint"
        case html = "text/html"
        case pdf = "application/pdf"
        
        init?(type:String) {
            switch type.lowercased() {
            case "jpg": self = .jpg
            case "png": self = .png
            case "doc": self = .doc
            case "ppt": self = .ppt
            case "html": self = .html
            case "pdf": self = .pdf
            default: return nil
            }
        }
    }
    
    func showEmail(attachmentFile: String, mensagem: String, para: String) {
        
        // Verificar se o dispositivo pode enviar email
        guard MFMailComposeViewController.canSendMail() else {
        let alertMessage = UIAlertController(title: "E-mail indisponível!", message: "Você não registrou sua conta no E-mail. Por favor vá nos Ajustes > E-mail para criar uma.", preferredStyle: .alert)
        alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertMessage, animated: true, completion: nil)
        return
        }
        
        let emailTitle = "Nova Versão Transformadora"
        let messageBody = mensagem
        let toRecipients = [para]
        
        // Initialize the mail composer and populate the mail content
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        //mailComposer.addAttachmentData(UIImageJPEGRepresentation(UIImage(named: "emailImage")!, CGFloat(1.0))!, mimeType: "image/png", fileName:  "Assinatura_Janeiro.png")
        mailComposer.setSubject(emailTitle)
        mailComposer.setMessageBody(messageBody, isHTML: true)
        mailComposer.setToRecipients(toRecipients)
        
        present(mailComposer, animated: true, completion: nil)
        return
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
        default:    break
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove o título na seta de volta da navegação
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //Back ground da tela
        view.backgroundColor  = UIColor.colorWithHexString("#f4f4ee")
        
        //Carrega o versiculo conforme a palavra-chave
        
        verso = DBManager.shared.loadVersiculoDetalhado(complSql: sqlVersiculo)
        
        //Campos da tela
        testamento?.text = verso[0].testamento
        testamento?.font = UIFont(name: "BrandonGrotesque-Bold", size: 19)
        testamento?.font = UIFont.boldSystemFont(ofSize: 19)
        
        livro?.text = verso[0].name.trim() + " " + verso[0].capitulo + ":" +
            verso[0].verso
        livro?.font = UIFont(name: "BrandonGrotesque-Bold", size: 19)
        livro?.font = UIFont.boldSystemFont(ofSize: 19)
        
        texto.text = verso[0].text
        
        //Variáveis para compartilhar no face
        nome = verso[0].name.trim()
        capitulo = verso[0].capitulo
        verso_share = Int32(String(verso[0].verso))!
        
        //Formataçao de fundo do texto
        let fontNameR = "Cochin"
        let fontSizeR = "16"
        let combination : NSMutableAttributedString! = NSMutableAttributedString()
        let tamanhoMaior: CGFloat! = CGFloat(Double(fontSizeR)!)
        let yourOtherAttributesBG =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: fontNameR, size: tamanhoMaior)!,
             NSAttributedString.Key.backgroundColor: UIColor.colorWithHexString("#b5a744")]
                //UIColor(red: 181/255, green: 167/255, blue: 68/255, alpha: 1.0) /* #b5a744 */]
        
        let partTwoBG = NSMutableAttributedString(string: String(texto.text),
                                                  attributes: yourOtherAttributesBG )
        combination.append(partTwoBG)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3.5
        paragraphStyle.lineHeightMultiple = 1
        paragraphStyle.alignment = .center
        
        let attString: NSMutableAttributedString! = combination
        
        attString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attString.length))

        texto?.attributedText = attString
        
        //texto.font = UIFont(name: "BrandonGrotesque-Bold", size: 16)
        texto.font = UIFont.boldSystemFont(ofSize: 16)
        texto.backgroundColor = UIColor(red: 181/255, green: 167/255, blue: 68/255, alpha: 1.0) /* #b5a744 */
        configureButton()
        
    }
    
    
    //Enviar o versículo detalhado para uma pessoa a ser escolhida
    @IBAction func enviar_Email () {
        var mensagem_montada : String!=""

        let bold : String! = "<b>"
        let fimBold : String! = "</b>"
        
        mensagem_montada! = bold + verso[0].text + fimBold  +
            "<a href=\"https://fb.me/680438488793610?a=" + verso[0].livroID! + "&b=" + verso[0].capitulo! +
                ":" + verso[0].verso! + "\">" +
            verso[0].name!.trim() + " " + verso[0].capitulo! + ":" +
                verso[0].verso! + " (NVT)</a><br><br>" +
            "De: Nova Versão Transformadora"
    
        
        let toRecipients = ""
        
        self.showEmail(attachmentFile: "", mensagem: mensagem_montada, para: toRecipients)
    }



    @IBAction func Twitter () {
        //Twitter
        
        // Display Tweet Composer
        var textoFormatadoFinal : String! = ""
        var totcaracteres : Int!
        
        var textoTratado: String! =
            //self.verso[0].name + " " + self.verso[0].capitulo + ":" + self.verso[0].verso + " - NVT \n" +
                self.verso[0].text
        totcaracteres = textoTratado.count
        if totcaracteres > 137 {
            totcaracteres = textoTratado.count - 137
        } else {
            totcaracteres = textoTratado.count}
        
        textoTratado = textoTratado.substring(to: totcaracteres) + "..."
        
        textoFormatadoFinal =   textoTratado!
        
//        let tweetComposer = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//        tweetComposer?.setInitialText(textoFormatadoFinal!)
//        //tweetComposer?.add(UIImage(named: "mc.png"))
//        self.present(tweetComposer!, animated: true, completion: nil)
        
        //
        let qString: String! = "?a=" + self.verso[0].livroID! + "&b=" + capitulo! + ":" +
            String(verso[0].verso)
        
        let branchUniversalObject = BranchUniversalObject(canonicalIdentifier: UUID().uuidString)
        branchUniversalObject.title = self.verso[0].name + " " + self.verso[0].capitulo + ":" + self.verso[0].verso + " - NVT"
        branchUniversalObject.contentDescription = textoFormatadoFinal!
        branchUniversalObject.addMetadataKey("qstring", value: qString!)
        
        let linkProperties: BranchLinkProperties = BranchLinkProperties()
        linkProperties.feature = "invites"
        linkProperties.channel = "twitter"
        linkProperties.addControlParam("$deeplink_path", withValue: qString)
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //Passar o book_id e o capitulo para filtrar o Versiculo
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "showListaVersiculoLivro" {

                    let ListaController = segue.destination as! ListaVersiculoViewController
                
                    let x = Int(verso[0].verso)
    
                    ListaController.versiculo1 = Int32(x!)
                    ListaController.livroID = verso[0].livroID!
                    ListaController.capitulo = verso[0].capitulo!
                    ListaController.textoCompletoVersiculoDia = texto.text

            }
        }
    }
    

    
    override func viewDidLayoutSubviews() {
        //Ajustar o textview para poder se autodimensionar de acordo com o texto.
        
        let contentSize = self.texto.sizeThatFits(self.texto.bounds.size)
        var frame = self.texto.frame
        frame.size.height = contentSize.height
        self.texto.frame = frame
        
        let aspectRatioTextViewConstraint = NSLayoutConstraint(item: self.texto as Any, attribute: .height, relatedBy: .equal, toItem: self.texto, attribute: .width, multiplier: texto.bounds.height/texto.bounds.width, constant: 1)
        self.texto.addConstraint(aspectRatioTextViewConstraint)
    }
    
    //Compartilhar o link do Branch com o Face
    @IBAction func sharedSDK() {
        //Montagem do versículo do dia no Face
        var textoFormatadoFinal : String! = ""
        var totcaracteres : Int! = 0
        
        var textoTratado: String! =
                self.verso[0].text
        
        //Tramento para Twitter
        totcaracteres = textoTratado.count
        if totcaracteres >= 137 {
            totcaracteres =  112
        }
        
        textoTratado = textoTratado.substring(to: totcaracteres) + "..."
        
        textoFormatadoFinal =  textoTratado!
        
        let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
        
        let qString: String! = "?a=" + self.verso[0].livroID! + "&b=" + capitulo! + ":" +
            String(verso_share)
        let urlString : String! = "https://fb.me/680438488793610" + qString
        
        content.contentURL = NSURL(string: urlString) as URL?
        content.contentTitle = self.verso[0].name + " " + self.verso[0].capitulo + ":" + self.verso[0].verso +
            " - NVT"
        content.contentDescription = textoFormatadoFinal!
        
        let branchUniversalObject = BranchUniversalObject(canonicalIdentifier: UUID().uuidString)
        branchUniversalObject.title = content.contentTitle
        branchUniversalObject.contentDescription = textoFormatadoFinal!
        branchUniversalObject.addMetadataKey("qstring", value: qString!)
        
        
        let linkProperties: BranchLinkProperties = BranchLinkProperties()
        linkProperties.feature = "invites"
        linkProperties.addControlParam("$desktop_url", withValue: "biblianvt://"+qString)
        linkProperties.addControlParam("$deeplink_path", withValue:  qString)
        linkProperties.addControlParam("$always_deeplink", withValue: "true")
        linkProperties.addControlParam("$ios_deepview", withValue: "default_template")
        linkProperties.addControlParam("$android_deepview", withValue: "default_template")
        
//        branchUniversalObject.getShortUrl(with: linkProperties) { (url, error) in
//            if (error == nil) {
//                print("Got my Branch link to share: (url)")
//                let dialog : FBSDKShareDialog = FBSDKShareDialog()
//                dialog.fromViewController = self
//                content.contentURL = NSURL(string: url!) as URL!
//                dialog.shareContent = content
//                let facebookURL = NSURL(string: "fbauth2://app")
//                if(UIApplication.shared.canOpenURL(facebookURL! as URL)){
//                    dialog.mode = FBSDKShareDialogMode.feedWeb
//                }else{
//                    dialog.mode = FBSDKShareDialogMode.native
//                }
//                dialog.delegate = self
//                dialog.show()
//
//            } else {
//                print(String(format: "Branch error : %@", error! as CVarArg))
//            }
//            
//        }
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
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        print(error as Any)
    }
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print(results.debugDescription)
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print(sharer.debugDescription as Any)
    }
    
    @IBAction func sharedEmail() {
        //Montagem do versículo do dia no Face
        var textoFormatadoFinal : String! = ""
        var totcaracteres : Int! = 0
        
        var textoTratado: String! =
            self.verso[0].text
        
        //Tramento para Twitter
        totcaracteres = textoTratado.count
        if totcaracteres >= 137 {
            totcaracteres =  112
        }
        
        textoTratado = textoTratado.substring(to: totcaracteres) + "..."
        
        textoFormatadoFinal =  textoTratado!
        
        let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
        
        let qString: String! = "?a=" + self.verso[0].livroID! + "&b=" + capitulo! + ":" +
            String(verso_share)
        let urlString : String! = "https://fb.me/680438488793610" + qString
        
        content.contentURL = NSURL(string: urlString) as URL?
        content.contentTitle = self.verso[0].name + " " + self.verso[0].capitulo + ":" + self.verso[0].verso +
            " - NVT"
        content.contentDescription = textoFormatadoFinal!
        
        let branchUniversalObject = BranchUniversalObject(canonicalIdentifier: UUID().uuidString)
        branchUniversalObject.title = content.contentTitle + " - NVT"
        branchUniversalObject.contentDescription = textoFormatadoFinal!
        branchUniversalObject.addMetadataKey("qstring", value: qString!)
        
        
        let linkProperties: BranchLinkProperties = BranchLinkProperties()
        linkProperties.feature = "share"
        linkProperties.channel = "email"
        linkProperties.addControlParam("$email_subject", withValue: content.contentTitle)
        linkProperties.addControlParam("$desktop_url", withValue: "biblianvt://"+qString)
        linkProperties.addControlParam("$deeplink_path", withValue:  qString)
        linkProperties.addControlParam("$always_deeplink", withValue: "true")
        linkProperties.addControlParam("$ios_deepview", withValue: "default_template")
        linkProperties.addControlParam("$android_deepview", withValue: "default_template")
        
//        branchUniversalObject.getShortUrl(with: linkProperties) { (url, error) in
//            if (error == nil) {
//                print("Got my Branch link to share: (url)")
//                let dialog : FBSDKShareDialog = FBSDKShareDialog()
//                dialog.fromViewController = self
//                content.contentURL = NSURL(string: url!) as URL!
//                dialog.shareContent = content
//                let facebookURL = NSURL(string: "fbauth2://app")
//                if(UIApplication.shared.canOpenURL(facebookURL! as URL)){
//                    dialog.mode = FBSDKShareDialogMode.feedWeb
//                }else{
//                    dialog.mode = FBSDKShareDialogMode.native
//                }
//                dialog.delegate = self
//                dialog.show()
//                
//            } else {
//                print(String(format: "Branch error : %@", error! as CVarArg))
//            }
//            
//        }
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
    
    //Fazer o botao circular
    func configureButton()
    {
        texto.layer.cornerRadius = 0.05 * texto.bounds.size.width
        texto.layer.borderColor = UIColor(red: 255/255, green: 246/255, blue: 211/255, alpha: 1.0) .cgColor as CGColor/* #fff6d3 */
        texto.layer.borderWidth = 2.0
        texto.clipsToBounds = true
    }

}
