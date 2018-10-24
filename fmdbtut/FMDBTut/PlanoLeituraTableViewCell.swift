//
//  PlanoLeituraTableViewCell.swift
//  BibliaNVT
//
//  Created by MacBook Pro i7 on 07/02/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit

class PlanoLeituraTableViewCell: UITableViewCell {
    
    @IBOutlet var numDia : UILabel!
    @IBOutlet var btnCheckBox : UIButton!
    @IBOutlet var btnLivro1 : UIButton!
    @IBOutlet var btnLivro2: UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
