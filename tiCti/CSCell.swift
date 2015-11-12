//
//  CSCell.swift
//  tiCti
//
//  Created by Ana Caroline Saraiva Bezerra on 09/11/15.
//  Copyright © 2015 Ana Caroline Saraiva Bezerra. All rights reserved.
//

import UIKit

class CSCell: UITableViewCell {

    @IBOutlet weak var CIcon: UIImageView!
    
    @IBOutlet weak var Title: UILabel!
    
    var i = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        Title.layer.cornerRadius = 10.0
        Title.clipsToBounds = true 
        
        //arrendondando e pondo sombra na label
        Title.layer.shadowOpacity = 1.0
        Title.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
    }
   
    func setSCCell(imageName: String)
    {
        self.CIcon.image = UIImage(named: imageName)
    }

}
