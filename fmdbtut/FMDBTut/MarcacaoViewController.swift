//
//  MarcacaoViewController.swift
//  BibliaNVT
//
//  Created by MacBook Pro i7 on 25/10/2017.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit
import UserNotifications

class MarcacaoViewController: UIViewController,UITextFieldDelegate,
    UIGestureRecognizerDelegate,Mensagem, UNUserNotificationCenterDelegate {

    //Outlet para mostrar o texto do versículo selecionado
    @IBOutlet var versiculo_marcado: UITextView!
    @IBOutlet var titulo: UITextField!
    
    //Variavel para receber o texto do versiculo marcado
    var textoVersiculoView: String!
    
    //Variaveis com o nome do livro, o livroID, capitulo e versiculo
    var nomeCapitulo: String!
    var livroID : String!
    var capitulo : String!
    var versiculo1 : Int32!
    var versiculos_selecionados : [Int32]!
    
    //Metodo para habilitar a tecla Enter realizar Pesquisa de Versículo - palavra-chave
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titulo.resignFirstResponder()
        Marcar()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [[.alert, .sound, .badge]], completionHandler: {(granted, Error) in
            
        })
        UNUserNotificationCenter.current().delegate = self

        // Do any additional setup after loading the view.
        title = "MARCAÇÃO"
        
        //atribuir o texto a texto da tela
        versiculo_marcado.text = textoVersiculoView
        
        //Esconder o teclado quando se tecla em qualquer parte da tela
        self.hideKeyboardWhenTappedAround()
        
        // Remove the title of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //Habilitar a tecla Enter para realizar a pesquisa
        titulo.enablesReturnKeyAutomatically = true
        self.titulo.becomeFirstResponder()
        self.titulo.delegate = self
        
        versiculo_marcado.backgroundColor = UIColor(red: 181/255, green: 167/255, blue: 68/255, alpha: 1.0) /* #b5a744 */
        
        
        //Back ground da tela
        view.self.backgroundColor = UIColor.colorWithHexString("#f4f4ee")
        
        configureButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Fazer o botao circular
    func configureButton()
    {
        versiculo_marcado.layer.cornerRadius = 0.05 * versiculo_marcado.bounds.size.width
        versiculo_marcado.layer.borderColor = UIColor(red: 255/255, green: 246/255, blue: 211/255, alpha: 1.0) .cgColor as CGColor/* #fff6d3 */
        versiculo_marcado.layer.borderWidth = 2.0
        versiculo_marcado.clipsToBounds = true
    }
    
    //IBaction para salvar a marcação e sair da tela
    @IBAction func Marcar() {
        //Variavel para guardar os versiculos selecionados
        var versiculos_sels : String! = ""
        //Validaçao da tela e montagem da cláusula do sql
        if titulo.text != nil && titulo.text != " " && titulo.text != "" {
            //Salva as configurações novas
            for i in 0...versiculos_selecionados.count-1 {
                DBManager.shared.atualizarMarcacao(titulo: titulo.text!,
                               livroID: livroID, capituloID: capitulo, versiculoID: versiculos_selecionados[i])
                if (i > 0) {
                    versiculos_sels = versiculos_sels + "-"
                }
                versiculos_sels = versiculos_sels + String(versiculos_selecionados[i])
            }
            //Realizar o agendamento da notificação
            let content = UNMutableNotificationContent()
            content.title = "Versículo(s) marcado(s)"
            //Nome do Livro capitulo:versiculo
            content.subtitle = nomeCapitulo  + ":" + versiculos_sels
            content.body = titulo.text! //titulo do texto a ser lido
            content.sound = UNNotificationSound.default
            //Agenda o trigger para 10 segundos
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            let request = UNNotificationRequest(identifier: "nvt.marcarVersiculos", content: content, trigger: trigger)
            
            // Schedule the notification
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

            mensagem(message: "Marcação realizada!")
        } else {
            mensagem(message: "Preencha o título!")
        }
    }
    
    //Método para habilitar a messagem quando o app estiver no Foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent willPresentnotification: UNNotification, withCompletionHandler completionHandler: @escaping(UNNotificationPresentationOptions) -> Void){
        
        completionHandler([.alert, .sound])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
