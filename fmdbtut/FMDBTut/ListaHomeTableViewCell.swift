//
//  ListaHomeTableViewCell.swift
//  BibliaNVT
//
//  Created by MacBook Pro i7 on 15/11/2017.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit

class ListaHomeTableViewCell: UITableViewCell {
    @IBOutlet var imagemLista: UIImageView!
    @IBOutlet var textoLista : UILabel!
    @IBOutlet var tipoLinha : UILabel!
    @IBOutlet var btnCompartilhar: UIButton!
    
    {
    didSet {
    imagemLista.layer.cornerRadius = imagemLista.bounds.width / 2
    imagemLista.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
