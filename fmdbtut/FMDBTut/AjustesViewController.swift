//
//  AjustesViewController.swift
//  BibliaNVT
//
//  Created by MacBook Pro i7 on 30/01/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit


class AjustesViewController: UIViewController,
        UIPickerViewDataSource,
        UIPickerViewDelegate {
    @IBOutlet weak var meuPicker: UIPickerView!
    @IBOutlet var slider: UISlider!
    @IBOutlet var lblTamanho: UILabel!
    @IBOutlet var lblFonte : UILabel!
    @IBOutlet var switchFundoNoturno : UISwitch!
    
    
    let dadosPicker:[vetorFonte] = Ajuste().printFonts()
    var fonteEscolhido: String!
    var fundoNoturnoSalvar: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        meuPicker.dataSource = self
        meuPicker.delegate = self
        
        //Ler as preferencias do sistema e mostrar a configuraçào
        let vetorPreferencias: [PreferenciasSistema]! = DBManager.shared.preferenciasSistema()!
        let fonteGenerica: String = vetorPreferencias[0].FonteNome!
        let tamanhoGenerico: String = vetorPreferencias[0].FonteTamanho!
        if (vetorPreferencias[0].FundoNoturno == nil) {
            fundoNoturnoSalvar = "NAO"
        } else {
        fundoNoturnoSalvar = vetorPreferencias[0].FundoNoturno!
        }
        
        lblFonte.text = fonteGenerica
        lblTamanho.text = tamanhoGenerico
        fonteEscolhido = fonteGenerica
        
        slider.value = Float(Double(tamanhoGenerico)!)

        switchFundoNoturno.addTarget(self, action: #selector(switchIsChanged),
                                     for: UIControl.Event.valueChanged)
        
        if (fundoNoturnoSalvar == "SIM") {
            switchFundoNoturno.setOn(true, animated: true)
        }
        else {
            switchFundoNoturno.setOn(false, animated: false)
        }
        aplicarAlteracoes()
        
        
        // Remove the title of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        //Back ground da tela
        view.self.backgroundColor = UIColor.colorWithHexString("#f4f4ee")
    }
    
    func aplicarAlteracoes() {
        
        guard let tamanho_r = lblTamanho.text else { return }
        let tt = Double(tamanho_r)!
        let fonteNovo = NSAttributedString(string: fonteEscolhido!, attributes: [NSAttributedString.Key.font:UIFont(name: fonteEscolhido, size: CGFloat(tt))!,NSAttributedString.Key.foregroundColor:UIColor.black])
        lblFonte!.attributedText = fonteNovo
        let NovoTamanho = NSAttributedString(string: String(Int(slider.value)), attributes: [NSAttributedString.Key.font:UIFont(name: fonteEscolhido, size: CGFloat(tt))!,NSAttributedString.Key.foregroundColor:UIColor.black])
        lblTamanho.attributedText = NovoTamanho
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        //view.backgroundColor = UIColor(red: 114/255, green: 0/255, blue: 45/255, alpha: 1.0)
    }
 
    //Data sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dadosPicker.count
    }
 
    //Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dadosPicker[row].Nome
    }
 
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fonteEscolhido = dadosPicker[row].Nome
        lblFonte.text = fonteEscolhido
        aplicarAlteracoes()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = dadosPicker[row].Nome
        let myTitle = NSAttributedString(string: titleData!, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 15.0)!,NSAttributedString.Key.foregroundColor:UIColor.blue])
        return myTitle
    }
    


    /* better memory management version */
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel?
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            //color the label's background
            let hue = CGFloat(row)/CGFloat(dadosPicker.count)
            pickerLabel?.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
        let titleData = dadosPicker[row].Nome
        let myTitle = NSAttributedString(string: titleData!, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 19.0)!,NSAttributedString.Key.foregroundColor:UIColor.black])
        pickerLabel!.attributedText = myTitle
        pickerLabel!.textAlignment = .center
        
        return pickerLabel!
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 39.0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 380
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let currentValue = Int(sender.value)
        
        lblTamanho.text = "\(currentValue)"
        aplicarAlteracoes()

    }
    
    @objc func switchIsChanged(switchState: UISwitch) {
        if switchState.isOn {
            fundoNoturnoSalvar = "SIM"
        } else {
            fundoNoturnoSalvar = "NAO"
        }
        aplicarAlteracoes()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func sairTela() {
        //Salva as configurações novas
        DBManager.shared.alterarPreferencias(fonte: fonteEscolhido!,
                        tamanho: lblTamanho.text!,
                        fundo_noturno: fundoNoturnoSalvar)
    
        self.dismiss(animated: true, completion: nil)
 
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {

    }
    

}
