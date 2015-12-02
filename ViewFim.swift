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

    @IBAction func jogarDenovo(sender: AnyObject)
    {
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()

        if(winner == 1)
        {
            if player1 == true //eh o jogador 1 entao:
            {
                text.text = "Você Venceu!"
                t.venceu()
            }
            else
            {
                text.text = "Jogador 1 Venceu!"
                //t.perdeu()
            }
            
        }
        else if(winner == 2)
        {
            if player1 == true //eh o jogador 1 entao:
            {
                text.text = "Jogador 2 Venceu!"
                //t.perdeu()
            }
            else
            {
                text.text = "Você Venceu!"
                //t.venceu()
            }
        }
        else//0
        {
            text.text = "Empate!"
            //t.empate()
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
