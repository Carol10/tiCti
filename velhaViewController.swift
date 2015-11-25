//
//  velhaViewController.swift
//  tiCti
//
//  Created by Ana Caroline Saraiva Bezerra on 19/11/15.
//  Copyright © 2015 Ana Caroline Saraiva Bezerra. All rights reserved.
//

import UIKit

class velhaViewController: UIViewController, tictiDelegate{
    
    let tic = ticti()
    var meu_email = ""
    var inimigo_email = ""
    
    @IBOutlet weak var b11: UIButton!
    @IBOutlet weak var b12: UIButton!
    @IBOutlet weak var b13: UIButton!
    
    @IBOutlet weak var b21: UIButton!
    @IBOutlet weak var b22: UIButton!
    @IBOutlet weak var b23: UIButton!
    
    @IBOutlet weak var b31: UIButton!
    @IBOutlet weak var b32: UIButton!
    @IBOutlet weak var b33: UIButton!
    
    var l11 = 0
    var l12 = 0
    var l13 = 0
    
    var l21 = 0
    var l22 = 0
    var l23 = 0
    
    var l31 = 0
    var l32 = 0
    var l33 = 0
    
    
    var ehMinhaVez = false
    var jogador = 2
    var velhaTest = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tic.delegate = self
        tic.meuemail = meu_email
        tic.inimigoemail = inimigo_email
        tic.connect()
        tic.entreiNoJogo()
        self.navigationItem.title = "Jogo da velha"
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ResetGame(){
        
        l11 = 0
        l12 = 0
        l13 = 0
        
        l21 = 0
        l22 = 0
        l23 = 0
        
        l31 = 0
        l32 = 0
        l33 = 0
        
        b11.enabled = true
        b12.enabled = true
        b13.enabled = true
        
        b21.enabled = true
        b22.enabled = true
        b23.enabled = true
        
        b31.enabled = true
        b32.enabled = true
        b33.enabled = true
        
        velhaTest = 0
        
    }
    
    
    func verifica(){
        
        if((l11 == 1 || l11 == 2) || (l31 == 1 || l31 == 2) || (l23 == 1 || l23 == 2)){
            if(l11 == 1 || l11 == 2){
                if((l11 == l12 && l11 == l13) || (l11 == l21 && l11 == l31) || (l11 == l22 && l11 == l33)){
                    
                    AlertFunc()
                    
                }
                
            }
            if(l31 == 1 || l31 == 2){
                if((l31 == l22 && l31 == l13) || (l31 == l32 && l31 == l33)){
                    
                    AlertFunc()
                    
                }
            }
            if(l23 == 1 || l23 == 2){
                if((l23 == l22 && l23 == l21) || (l23 == l13 && l23 == l33)){
                    
                    AlertFunc()
                    
                }
            }
        }
        
        
        if(b11.enabled == false && b12.enabled == false && b13.enabled == false){
            if(b21.enabled == false && b22.enabled == false && b23.enabled == false){
                if(b31.enabled == false && b32.enabled == false && b33.enabled == false){
                    
                    velhaTest = 1
                    AlertFunc()
                    
                }
            }
        }
        
        
    }
    
    func AlertFunc(){
        if(velhaTest == 0){
            let Alert1 = UIAlertController(title: "TicTacToe", message: "O vencedor é o jogador \(jogador)", preferredStyle: UIAlertControllerStyle.Alert)
            
            Alert1.addAction(UIAlertAction(title: "Close", style: .Default, handler: {
                (action: UIAlertAction!) in self.ResetGame()
            }))
            presentViewController(Alert1, animated: true, completion: nil)
        }else{
            let Alertv = UIAlertController(title: "TicTacToe", message: "Velha!", preferredStyle: UIAlertControllerStyle.Alert)
            
            Alertv.addAction(UIAlertAction(title: "Close", style: .Default, handler: {
                (action: UIAlertAction!) in self.ResetGame()
            }))
            presentViewController(Alertv, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func B11(sender: AnyObject) {
        if(!ehMinhaVez){ return }
        if(jogador==1){
            tic.movimento("11")
            l11 = 1
            b11.enabled = false
            b11.setTitle("X", forState: .Disabled)
            verifica()
            jogador = 2
        }
        else if(jogador==2){
            l11 = 2
            b11.enabled = false
            b11.setTitle("O", forState: .Disabled)
            verifica()
            jogador = 1
        }
        ehMinhaVez = false
    }
    
    @IBAction func B12(sender: AnyObject) {
        if(!ehMinhaVez){ return }
        if(jogador==1){
            tic.movimento("12")
            l12 = 1
            b12.enabled = false
            b12.setTitle("X", forState: .Disabled)
            verifica()
            jogador = 2
        }
        else if(jogador==2){
            l12 = 2
            b12.enabled = false
            b12.setTitle("O", forState: .Disabled)
            verifica()
            jogador = 1
        }
        ehMinhaVez = false
    }
    
    @IBAction func B13(sender: AnyObject) {
        if(!ehMinhaVez){ return }
        if(jogador==1){
            tic.movimento("13")
            l13 = 1
            b13.enabled = false
            b13.setTitle("X", forState: .Disabled)
            verifica()
            jogador = 2
        }
        else if(jogador==2){
            l13 = 2
            b13.enabled = false
            b13.setTitle("O", forState: .Disabled)
            verifica()
            jogador = 1
        }
        ehMinhaVez = false
    }
    
    @IBAction func B21(sender: AnyObject) {
        if(!ehMinhaVez){ return }
        if(jogador==1){
            tic.movimento("21")
            l21 = 1
            b21.enabled = false
            b21.setTitle("X", forState: .Disabled)
            verifica()
            jogador = 2
        }
        else if(jogador==2){
            l21 = 2
            b21.enabled = false
            b21.setTitle("O", forState: .Disabled)
            verifica()
            jogador = 1
        }
        ehMinhaVez = false
    }
    
    @IBAction func B22(sender: AnyObject) {
        if(!ehMinhaVez){ return }
        if(jogador==1){
            tic.movimento("22")
            l22 = 1
            b22.enabled = false
            b22.setTitle("X", forState: .Disabled)
            verifica()
            jogador = 2
        }
        else if(jogador==2){
            l22 = 2
            b22.enabled = false
            b22.setTitle("O", forState: .Disabled)
            verifica()
            jogador = 1
        }
       ehMinhaVez = false
    }
    
    @IBAction func B23(sender: AnyObject) {
        if(!ehMinhaVez){ return }
        if(jogador==1){
            tic.movimento("23")
            l23 = 1
            b23.enabled = false
            b23.setTitle("X", forState: .Disabled)
            verifica()
            jogador = 2
        }
        else if(jogador==2){
            l23 = 2
            b23.enabled = false
            b23.setTitle("O", forState: .Disabled)
            verifica()
            jogador = 1
        }
        ehMinhaVez = false
    }
    
    @IBAction func B31(sender: AnyObject) {
        if(!ehMinhaVez){ return }
        if(jogador==1){
            tic.movimento("31")
            l31 = 1
            b31.enabled = false
            b31.setTitle("X", forState: .Disabled)
            verifica()
            jogador = 2
        }
        else if(jogador==2){
            l31 = 2
            b31.enabled = false
            b31.setTitle("O", forState: .Disabled)
            verifica()
            jogador = 1
        }
        ehMinhaVez = false
    }
    
    @IBAction func B32(sender: AnyObject) {
        if(!ehMinhaVez){ return }
        if(jogador==1){
            tic.movimento("32")
            l32 = 1
            b32.enabled = false
            b32.setTitle("X", forState: .Disabled)
            verifica()
            jogador = 2
        }
        else if(jogador==2){
            l32 = 2
            b32.enabled = false
            b32.setTitle("O", forState: .Disabled)
            verifica()
            jogador = 1
        }
        ehMinhaVez = false
    }
    
    @IBAction func B33(sender: AnyObject) {
        if(!ehMinhaVez){ return }
        if(jogador==1){
            tic.movimento("33")
            l33 = 1
            b33.enabled = false
            b33.setTitle("X", forState: .Disabled)
            verifica()
            jogador = 2
        }
        else if(jogador==2){
            l33 = 2
            b33.enabled = false
            b33.setTitle("O", forState: .Disabled)
            verifica()
            jogador = 1
        }
        ehMinhaVez = false
    }
    
    func adversarioConectou(email: String) {
        jogador = 1
        ehMinhaVez = true 
    }
    func recebeuUmMovimento(de: String, dados: String) {
        ehMinhaVez = true
        
        
        
//        switch dados{
//            case "11":
//                if(jogador==2){
//                    tic.movimento("11")
//                    l11 = 1
//                    b11.enabled = false
//                    b11.setTitle("X", forState: .Disabled)
//                    verifica()
//                    jogador = 1
//                }
//                else if(jogador==1){
//                    l11 = 2
//                    b11.enabled = false
//                    b11.setTitle("O", forState: .Disabled)
//                    verifica()
//                    jogador = 2
//                }
//                break;
//            case "12":
//                if(jogador==2){
//                    tic.movimento("12")
//                    l12 = 1
//                    b12.enabled = false
//                    b12.setTitle("X", forState: .Disabled)
//                    verifica()
//                    jogador = 1
//                }
//                else if(jogador==1){
//                    l12 = 1
//                    b12.enabled = false
//                    b12.setTitle("O", forState: .Disabled)
//                    verifica()
//                    jogador = 2
//            }
//            break;
//            case "13":
//                if(jogador==2){
//                    tic.movimento("13")
//                    l13 = 2
//                    b13.enabled = false
//                    b13.setTitle("X", forState: .Disabled)
//                    verifica()
//                    jogador = 1
//                }
//                else if(jogador==1){
//                    l13 = 1
//                    b13.enabled = false
//                    b13.setTitle("O", forState: .Disabled)
//                    verifica()
//                    jogador = 2
//            }
//                break;
//            
//            case "21":
//                if(jogador==2){
//                    tic.movimento("21")
//                    l21 = 2
//                    b21.enabled = false
//                    b21.setTitle("X", forState: .Disabled)
//                    verifica()
//                    jogador = 1
//                }
//                else if(jogador==1){
//                    l21 = 1
//                    b21.enabled = false
//                    b21.setTitle("O", forState: .Disabled)
//                    verifica()
//                    jogador = 2
//            }
//                break;
//            case "22":
//                if(jogador==2){
//                    tic.movimento("22")
//                    l22 = 2
//                    b22.enabled = false
//                    b22.setTitle("X", forState: .Disabled)
//                    verifica()
//                    jogador = 1
//                }
//                else if(jogador==1){
//                    l22 = 1
//                    b22.enabled = false
//                    b22.setTitle("O", forState: .Disabled)
//                    verifica()
//                    jogador = 2
//            }
//                break;
//            case "23":
//                if(jogador==1){
//                    tic.movimento("23")
//                    l23 = 1
//                    b23.enabled = false
//                    b23.setTitle("X", forState: .Disabled)
//                    verifica()
//                    jogador = 2
//                }
//                else if(jogador==2){
//                    l23 = 2
//                    b23.enabled = false
//                    b23.setTitle("O", forState: .Disabled)
//                    verifica()
//                    jogador = 1
//            }
//            break
//            case "31":
//                if(jogador==2){
//                    tic.movimento("31")
//                    l31 = 2
//                    b31.enabled = false
//                    b31.setTitle("X", forState: .Disabled)
//                    verifica()
//                    jogador = 1
//                }
//                else if(jogador==1){
//                    l31 = 1
//                    b31.enabled = false
//                    b31.setTitle("O", forState: .Disabled)
//                    verifica()
//                    jogador = 2
//                }
//                
//            break
//            case "32":
//                if(jogador==2){
//                    tic.movimento("32")
//                    l32 = 2
//                    b32.enabled = false
//                    b32.setTitle("X", forState: .Disabled)
//                    verifica()
//                    jogador = 1
//                }
//                else if(jogador==1){
//                    l32 = 1
//                    b32.enabled = false
//                    b32.setTitle("O", forState: .Disabled)
//                    verifica()
//                    jogador = 2
//                }
//            
//            break
//            case "33":
//                if(jogador==2){
//                    tic.movimento("33")
//                    l33 = 2
//                    b33.enabled = false
//                    b33.setTitle("X", forState: .Disabled)
//                    verifica()
//                    jogador = 1
//                }
//                else if(jogador==1){
//                    l33 = 1
//                    b33.enabled = false
//                    b33.setTitle("O", forState: .Disabled)
//                    verifica()
//                    jogador = 2
//                }
//            break
//            default:
//            break
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
