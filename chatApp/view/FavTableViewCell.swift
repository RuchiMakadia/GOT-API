//
//  FavTableViewCell.swift
//  chatApp
//
//  Created by eHeuristic on 22/04/19.
//  Copyright © 2019 eHeuristic. All rights reserved.
//

import UIKit

class FavTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imgbackground: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
