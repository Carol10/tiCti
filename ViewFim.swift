//
//  ViewFim.swift
//  Pontos
//
//  Created by Pedro Campos on 11/17/15.
//  Copyright © 2015 Pedro Campos. All rights reserved.
//

import UIKit

class ViewFim: UIViewController
{
    @IBOutlet var text: UILabel!
    
    @IBOutlet var img:UIImageView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        img.removeFromSuperview();
        if(winner == 1)
        {
            if player1 == true //eh o jogador 1 entao:
            {
                text.text = "Você Venceu!"
                t.venceu()
                //img.image = UIImage(named:"winner2.png")
            }
            else
            {
                text.text = "Jogador 1 Venceu!"
                t.perdeu()
                //img.image = UIImage(named: "loser.jpg")
            }
            
        }
        else if(winner == 2)
        {
            if player1 == true //eh o jogador 1 entao:
            {
                text.text = "Jogador 2 Venceu!"
                t.perdeu()
                //img.image = UIImage(named: "loser.jpg")
            }
            else
            {
                text.text = "Você Venceu!"
                t.venceu()
                //img.image = UIImage(named:"winner2.png")
            }
        }
        else//0
        {
            text.text = "Empate!"
            //t.empate()
        }
    }

}
