//
//  PerfilCell.swift
//  tiCti
//
//  Created by Ana Caroline Saraiva Bezerra on 16/11/15.
//  Copyright © 2015 Ana Caroline Saraiva Bezerra. All rights reserved.
//

import UIKit

class PerfilCell: UITableViewCell {

    @IBOutlet weak var menuLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setLabel(menuText: String)
    {
        self.menuLabel.text = menuText
    }
}
