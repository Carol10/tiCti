//
//  FimTicTacToe.swift
//  Jogo da velha
//
//  Created by Pedro Campos on 12/4/15.
//  Copyright © 2015 Locomotiva. All rights reserved.
//

import UIKit

class FimTicTacToe: UIViewController
{
    
    @IBOutlet var txt:UILabel!

    @IBOutlet var img: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if winnerTicTacToe[winnerTicTacToe.startIndex.advancedBy(1)] == "t" //eh o player1 (o)
        {
            if winnerTicTacToe[winnerTicTacToe.startIndex.advancedBy(0)] == "1"
            {
                txt.text = "Você venceu!"
                img.image = UIImage(named: "winner2.png")!
                t.venceu()
                
                
            }
            else if winnerTicTacToe[winnerTicTacToe.startIndex.advancedBy(0)] == "2"
            {
                txt.text = "Jogador 2 Venceu!"
                img.image =  UIImage(named: "loser.jpg")!
                t.perdeu()
            }
            else //empate
            {
                txt.text = "Empate!"
            }
        }
        else //(x)
        {
            if winnerTicTacToe[winnerTicTacToe.startIndex.advancedBy(0)] == "1"
            {
                txt.text = "Jogador 1 Venceu!"
                img.image =  UIImage(named: "loser.jpg")!
                t.perdeu()
            }
            else if winnerTicTacToe[winnerTicTacToe.startIndex.advancedBy(0)] == "2"
            {
                txt.text = "Você venceu!"
                img.image =  UIImage(named: "winner2.png")!
                t.venceu()
            }
            else //empate
            {
                txt.text = "Empate!"
            }

            
        }
    }

}
