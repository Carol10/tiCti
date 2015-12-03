//
//  Jogos.swift
//  tiCti
//
//  Created by Ana Caroline Saraiva Bezerra on 17/11/15.
//  Copyright © 2015 Ana Caroline Saraiva Bezerra. All rights reserved.
//

import UIKit

class Jogos: UIViewController, tictiDelegate{
    
    var meu_email = ""

    //servidor 
    let tic = ticti()
    
    
    @IBOutlet weak var Bdamas: UIButton!
    @IBOutlet weak var Bvelha: UIButton!
    @IBOutlet weak var Bpontos: UIButton!
    
    @IBOutlet weak var I: UILabel!
    @IBOutlet weak var J: UILabel!
    @IBOutlet weak var K: UILabel!

    
    
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
        print(meu_email)
        
        tic.delegate=self
        tic.connect()
        
        
        tic.pegarRanking { (dados, imagens) -> () in
            //dispatch_async(<#T##queue: dispatch_queue_t##dispatch_queue_t#>, <#T##block: dispatch_block_t##dispatch_block_t##() -> Void#>)
            self.nome1.text = (dados[0] as! NSDictionary)["nome"] as? String
            self.nome2.text = (dados[1] as! NSDictionary)["nome"] as? String
            self.nome3.text = (dados[2] as! NSDictionary)["nome"] as? String
            
            let v1 = Int((dados[0] as! NSDictionary)["vitorias"] as! String)!*10
            let v2 = Int((dados[1] as! NSDictionary)["vitorias"] as! String)!*10
            let v3 = Int((dados[2] as! NSDictionary)["vitorias"] as! String)!*10
            
            self.pedestal1.setTitle("\(v1) pts", forState: .Disabled)
            self.pedestal2.setTitle("\(v2) pts", forState: .Disabled)
            self.pedestal3.setTitle("\(v3) pts", forState: .Disabled)
            
            self.foto1.image = imagens[0] as? UIImage;
            self.foto2.image = imagens[1] as? UIImage;
            self.foto3.image = imagens[2] as? UIImage;
        }
        
        Bdamas.addTarget(self, action: Selector("goDama"), forControlEvents: UIControlEvents.TouchUpInside)
        Bvelha.addTarget(self, action: Selector("goVelha"), forControlEvents: UIControlEvents.TouchUpInside)
        Bpontos.addTarget(self, action: Selector("goPontinhos"), forControlEvents: UIControlEvents.TouchUpInside)
       
    }
    
    func goDama(){
        self.I.backgroundColor = UIColor(red:(168.0/255.0),green:(200.0/255.0),blue:(89.0/255.0),alpha:1.0)
        tic.meuemail = meu_email
        tic.queroJogar(1)
    }
    func goVelha(){
        self.J.backgroundColor = UIColor(red:(168.0/255.0),green:(200.0/255.0),blue:(89.0/255.0),alpha:1.0)
        tic.meuemail = meu_email
        tic.queroJogar(2)
    }
    func goPontinhos(){
        self.K.backgroundColor = UIColor(red:(168.0/255.0),green:(200.0/255.0),blue:(89.0/255.0),alpha:1.0)
        tic.meuemail = meu_email
        tic.queroJogar(3)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func pareou(com: String, jogo: UInt) {
        print("pareou!")
        self.I.backgroundColor = UIColor.clearColor()
        self.J.backgroundColor = UIColor.clearColor()
        self.K.backgroundColor = UIColor.clearColor()
        if(jogo == 1){
            let vc = DamasViewController()
            vc.meu_email = meu_email
            vc.inimigo_email = com
            self.navigationController?.pushViewController(vc, animated: true)
            //self.presentViewController(vc, animated: true, completion: nil)
        }else if(jogo == 2){
//            let vc = velhaViewController()
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("VelhaVC") as! velhaViewController;
            
            vc.meu_email = meu_email
            vc.inimigo_email = com
            self.navigationController?.pushViewController(vc, animated: true)
            //3self.presentViewController(vc, animated: true, completion: nil)
        }else if(jogo == 3){
//          let vc = pontosViewController()
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PontosVC") as! GameViewController;
            
            vc.meu_email = meu_email
            vc.inimigo_email = com
           
            self.navigationController?.pushViewController(vc, animated: true)
            // self.presentViewController(vc, animated: true, completion: nil)
        }
        
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
