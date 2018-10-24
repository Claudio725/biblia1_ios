//
//  MarcadorTableViewCell.swift
//  BibliaNVT
//
//  Created by MacBook Pro i7 on 27/10/2017.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit

class MarcadorTableViewCell: UITableViewCell {
    
    @IBOutlet var nome: UILabel!
    @IBOutlet var livroID : UILabel!
    @IBOutlet var capitulo : UILabel!
    @IBOutlet var verso: UILabel!
    @IBOutlet var texto: UILabel!
    @IBOutlet var titulo: UILabel!
    @IBOutlet var btnCompartilhar: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

}
