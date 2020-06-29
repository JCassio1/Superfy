//
//  TableViewCell.swift
//  Superfy
//
//  Created by MR.Robot 💀 on 26/06/2020.
//  Copyright © 2020 Joselson Dias. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var songArtwork: UIImageView!
    @IBOutlet weak var songInformation: UILabel!
    
    @IBOutlet weak var currentArtistName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//extension 
