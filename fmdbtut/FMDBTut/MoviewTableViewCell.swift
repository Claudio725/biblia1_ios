//
//  MoviewTableViewCell.swift
//  FMDBTut
//
//  Created by MacBook Pro i7 on 30/12/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit

class MoviewTableViewCell: UITableViewCell {
    
    @IBOutlet var nome: UILabel!
    @IBOutlet var testamento : UILabel!
    @IBOutlet var livroID : UILabel!
    @IBOutlet var capitulo : UILabel!
    @IBOutlet var verso: UILabel!
    @IBOutlet var texto: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code


    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
