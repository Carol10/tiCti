//
//  Jogos.swift
//  tiCti
//
//  Created by Ana Caroline Saraiva Bezerra on 17/11/15.
//  Copyright © 2015 Ana Caroline Saraiva Bezerra. All rights reserved.
//

import UIKit

class Jogos: UIViewController{

    //servidor 
    let tic = ticti()
    
    
    @IBOutlet weak var Bdamas: UIButton!
    @IBOutlet weak var Bvelha: UIButton!
    @IBOutlet weak var Bpontos: UIButton!
    
    @IBOutlet weak var I: UIImageView!
    @IBOutlet weak var J: UIImageView!
    @IBOutlet weak var K: UIImageView!
    
    
    @IBOutlet weak var foto1: UIImageView!
    @IBOutlet weak var foto2: UIImageView!
    @IBOutlet weak var foto3: UIImageView!
    
   
    @IBOutlet weak var nome1: UILabel!
    @IBOutlet weak var nome2: UILabel!
    @IBOutlet weak var nome3: UILabel!
    
    @IBOutlet weak var pedestal1: UIButton!
    @IBOutlet weak var pedestal2: UIButton!
    @IBOutlet weak var pedestal3: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pedestal1.enabled = false
        pedestal2.enabled = false
        pedestal3.enabled = false
        
        foto1.layer.cornerRadius=60
        foto2.layer.cornerRadius=60
        foto3.layer.cornerRadius=60
        
        self.navigationItem.title = "Jogos"
        
        tic.connect()
        
        
        tic.pegarRanking { (dados, imagens) -> () in
            print("chamou")
            //dispatch_async(<#T##queue: dispatch_queue_t##dispatch_queue_t#>, <#T##block: dispatch_block_t##dispatch_block_t##() -> Void#>)
            self.nome1.text = (dados[0] as! NSDictionary)["nome"] as? String
            self.nome2.text = (dados[1] as! NSDictionary)["nome"] as? String
            self.nome3.text = (dados[2] as! NSDictionary)["nome"] as? String
            
            self.pedestal1.setTitle("\((dados[0] as! NSDictionary)["vitorias"] as! String) pts", forState: .Disabled)
            self.pedestal2.setTitle("\((dados[1] as! NSDictionary)["vitorias"] as! String) pts", forState: .Disabled)
            self.pedestal3.setTitle("\((dados[2] as! NSDictionary)["vitorias"] as! String) pts", forState: .Disabled)
            
            self.foto1.image = imagens[0] as? UIImage;
            self.foto2.image = imagens[1] as? UIImage;
            self.foto3.image = imagens[2] as? UIImage;
        }
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
