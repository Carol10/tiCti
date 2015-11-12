//
//  LSCell.swift
//  tiCti
//
//  Created by Ana Caroline Saraiva Bezerra on 10/11/15.
//  Copyright © 2015 Ana Caroline Saraiva Bezerra. All rights reserved.
//

import UIKit

class LSCell: UITableViewCell {

    
    @IBOutlet weak var LIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setLSCell(imageName: String)
    {
        self.LIcon.image = UIImage(named: imageName)
    }
}
