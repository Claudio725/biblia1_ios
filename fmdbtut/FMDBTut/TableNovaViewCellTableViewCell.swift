//
//  TableNovaViewCellTableViewCell.swift
//  BibliaNVT
//
//  Created by MacBook Pro i7 on 19/04/2018.
//  Copyright © 2018 Appcoda. All rights reserved.
//

import UIKit

class TableNovaViewCellTableViewCell: UITableViewCell {
    @IBOutlet var lblTextoVerso: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
