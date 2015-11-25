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
    
    @IBOutlet weak var b11: botao_ttt!
    @IBOutlet weak var b12: botao_ttt!
    @IBOutlet weak var b13: botao_ttt!
    
    @IBOutlet weak var b21: botao_ttt!
    @IBOutlet weak var b22: botao_ttt!
    @IBOutlet weak var b23: botao_ttt!
    
    @IBOutlet weak var b31: botao_ttt!
    @IBOutlet weak var b32: botao_ttt!
    @IBOutlet weak var b33: botao_ttt!
    
    var botoes:NSArray!
    
    
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
        
        botoes = [[b11,b12,b13],[b21,b22,b23],[b31,b32,b33]]
        
        for(var linha = 0; linha < 3; linha++){
            for(var coluna = 0; coluna < 3; coluna++){
                (botoes[linha][coluna] as! botao_ttt).linha = linha;
                (botoes[linha][coluna] as! botao_ttt).coluna = coluna;
                botoes[linha][coluna].addTarget(self, action: "numSei:", forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
    }
    
    
    func numSei(sender: botao_ttt){
        if(!ehMinhaVez){ return }
        if(jogador==1){
            sender.enabled = false
            sender.setTitle("X", forState: .Disabled)
            sender.é_x = true
            verifica()
            //jogador = 2
        }
        else if(jogador==2){
            sender.enabled = false
            sender.setTitle("O", forState: .Disabled)
            sender.é_x = false
            verifica()
            //jogador = 1
        }
        tic.movimento("\(sender.linha) \(sender.coluna)")
        ehMinhaVez = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ResetGame(){
        for(var linha = 0; linha < 3; linha++){
            for(var coluna = 0; coluna < 3; coluna++){
                (botoes[linha][coluna] as! botao_ttt).enabled = true
                (botoes[linha][coluna] as! botao_ttt).é_x = false
            }
        }
        //
        velhaTest = 0
    }
    
    
    func verifica(){
        var diagonal = 0;
        var colunas = 0;
        var linhas = 0;
        for(var linha = 0; linha < 3; linha++){
            linhas=0
            for(var coluna = 0; coluna < 3; coluna++){
                if(!(botoes[linha][coluna] as! botao_ttt).enabled){
                    if(linha == coluna){
                        if((botoes[linha][coluna] as! botao_ttt).é_x){
                            diagonal++;
                        }else{
                            diagonal--;
                        }
                    }
                    if((botoes[linha][coluna] as! botao_ttt).é_x){
                        colunas++; linhas++;
                    }else{
                        colunas--; linhas--;
                    }
                }
            }
        }
        if((diagonal == 3 || linhas == 3 || colunas == 3)){
            AlertFunc(1)
        }else if((diagonal == -3 || linhas == -3 || colunas == -3)){
            AlertFunc(2)
        }else{
            var dv = true;
            for(var linha = 0; linha < 3; linha++){
                for(var coluna = 0; coluna < 3; coluna++){
                    if (botoes[linha][coluna] as! botao_ttt).enabled == true{
                        dv = false
                        break;
                    }
                }
            }
            if(dv){
                velhaTest=1;
                AlertFunc(0)
            }
        }
        
        print("diagonal: \(diagonal)\nlinhas: \(linhas)\ncolunas:\(colunas)");
        //
        //        if((l[0][0] == 1 || l[0][0] == 2) || (l[2][0] == 1 || l[2][0] == 2) || (l[1][2] == 1 || l[2][3] == 2)){
        //            if(l11 == 1 || l11 == 2){
        //                if((l11 == l12 && l11 == l13) || (l11 == l21 && l11 == l31) || (l11 == l22 && l11 == l33)){
        //
        //                    AlertFunc()
        //
        //                }
        //
        //            }
        //            if(l31 == 1 || l31 == 2){
        //                if((l31 == l22 && l31 == l13) || (l31 == l32 && l31 == l33)){
        //
        //                    AlertFunc()
        //
        //                }
        //            }
        //            if(l23 == 1 || l23 == 2){
        //                if((l23 == l22 && l23 == l21) || (l23 == l13 && l23 == l33)){
        //
        //                    AlertFunc()
        //
        //                }
        //            }
        //        }
        //
        //
        //        if(b11.enabled == false && b12.enabled == false && b13.enabled == false){
        //            if(b21.enabled == false && b22.enabled == false && b23.enabled == false){
        //                if(b31.enabled == false && b32.enabled == false && b33.enabled == false){
        //
        //                    velhaTest = 1
        //                    AlertFunc()
        //
        //                }
        //            }
        //        }
    }
    
    func AlertFunc(vencedor: Int){
        if(velhaTest == 0){
            let Alert1 = UIAlertController(title: "TicTacToe", message: "O vencedor é o jogador \(vencedor)", preferredStyle: UIAlertControllerStyle.Alert)
            
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
    
    func adversarioConectou(email: String) {
        jogador = 1
        ehMinhaVez = true
    }
    func recebeuUmMovimento(de: String, dados: String) {
        ehMinhaVez = true
        let coef:NSArray = dados.characters.split{$0 == " "}.map(String.init) // linha, coluna
        let bt:botao_ttt = botoes[Int(coef[0] as! String)!][Int(coef[1] as! String)!] as! botao_ttt
        if(jogador == 2 ){
            bt.é_x = true
            bt.enabled = false
            bt.setTitle("X", forState: .Disabled)
        }else if(jogador == 1){
            bt.é_x = false
            bt.enabled = false
            bt.setTitle("O", forState: .Disabled)
        }
        verifica()
        
    }
    //    @IBAction func B11(sender: AnyObject) {
    //        if(!ehMinhaVez){ return }
    //        if(jogador==1){
    //            tic.movimento("11")
    //            l11 = 1
    //            b11.enabled = false
    //            b11.setTitle("X", forState: .Disabled)
    //            verifica()
    //            jogador = 2
    //        }
    //        else if(jogador==2){
    //            l11 = 2
    //            b11.enabled = false
    //            b11.setTitle("O", forState: .Disabled)
    //            verifica()
    //            jogador = 1
    //        }
    //    }
    //
    //    @IBAction func B12(sender: AnyObject) {
    //        if(!ehMinhaVez){ return }
    //        if(jogador==1){
    //            tic.movimento("12")
    //            l12 = 1
    //            b12.enabled = false
    //            b12.setTitle("X", forState: .Disabled)
    //            verifica()
    //            jogador = 2
    //        }
    //        else if(jogador==2){
    //            l12 = 2
    //            b12.enabled = false
    //            b12.setTitle("O", forState: .Disabled)
    //            verifica()
    //            jogador = 1
    //        }
    //    }
    //
    //    @IBAction func B13(sender: AnyObject) {
    //        if(!ehMinhaVez){ return }
    //        if(jogador==1){
    //            tic.movimento("13")
    //            l13 = 1
    //            b13.enabled = false
    //            b13.setTitle("X", forState: .Disabled)
    //            verifica()
    //            jogador = 2
    //        }
    //        else if(jogador==2){
    //            l13 = 2
    //            b13.enabled = false
    //            b13.setTitle("O", forState: .Disabled)
    //            verifica()
    //            jogador = 1
    //        }
    //    }
    //
    //    @IBAction func B21(sender: AnyObject) {
    //        if(!ehMinhaVez){ return }
    //        if(jogador==1){
    //            tic.movimento("21")
    //            l21 = 1
    //            b21.enabled = false
    //            b21.setTitle("X", forState: .Disabled)
    //            verifica()
    //            jogador = 2
    //        }
    //        else if(jogador==2){
    //            l21 = 2
    //            b21.enabled = false
    //            b21.setTitle("O", forState: .Disabled)
    //            verifica()
    //            jogador = 1
    //        }
    //    }
    //
    //    @IBAction func B22(sender: AnyObject) {
    //        if(!ehMinhaVez){ return }
    //        if(jogador==1){
    //            tic.movimento("22")
    //            l22 = 1
    //            b22.enabled = false
    //            b22.setTitle("X", forState: .Disabled)
    //            verifica()
    //            jogador = 2
    //        }
    //        else if(jogador==2){
    //            l22 = 2
    //            b22.enabled = false
    //            b22.setTitle("O", forState: .Disabled)
    //            verifica()
    //            jogador = 1
    //        }
    //
    //    }
    //
    //    @IBAction func B23(sender: AnyObject) {
    //        if(!ehMinhaVez){ return }
    //        if(jogador==1){
    //            tic.movimento("23")
    //            l23 = 1
    //            b23.enabled = false
    //            b23.setTitle("X", forState: .Disabled)
    //            verifica()
    //            jogador = 2
    //        }
    //        else if(jogador==2){
    //            l23 = 2
    //            b23.enabled = false
    //            b23.setTitle("O", forState: .Disabled)
    //            verifica()
    //            jogador = 1
    //        }
    //
    //    }
    //
    //    @IBAction func B31(sender: AnyObject) {
    //        if(!ehMinhaVez){ return }
    //        if(jogador==1){
    //            tic.movimento("31")
    //            l31 = 1
    //            b31.enabled = false
    //            b31.setTitle("X", forState: .Disabled)
    //            verifica()
    //            jogador = 2
    //        }
    //        else if(jogador==2){
    //            l31 = 2
    //            b31.enabled = false
    //            b31.setTitle("O", forState: .Disabled)
    //            verifica()
    //            jogador = 1
    //        }
    //
    //    }
    //
    //    @IBAction func B32(sender: AnyObject) {
    //        if(!ehMinhaVez){ return }
    //        if(jogador==1){
    //            tic.movimento("32")
    //            l32 = 1
    //            b32.enabled = false
    //            b32.setTitle("X", forState: .Disabled)
    //            verifica()
    //            jogador = 2
    //        }
    //        else if(jogador==2){
    //            l32 = 2
    //            b32.enabled = false
    //            b32.setTitle("O", forState: .Disabled)
    //            verifica()
    //            jogador = 1
    //        }
    //
    //    }
    //
    //    @IBAction func B33(sender: AnyObject) {
    //        if(!ehMinhaVez){ return }
    //        if(jogador==1){
    //            tic.movimento("33")
    //            l33 = 1
    //            b33.enabled = false
    //            b33.setTitle("X", forState: .Disabled)
    //            verifica()
    //            jogador = 2
    //        }
    //        else if(jogador==2){
    //            l33 = 2
    //            b33.enabled = false
    //            b33.setTitle("O", forState: .Disabled)
    //            verifica()
    //            jogador = 1
    //        }
    //    }
    //
    //    func adversarioConectou(email: String) {
    //        jogador = 1
    //        ehMinhaVez = true
    //    }
    //    func recebeuUmMovimento(de: String, dados: String) {
    //        switch dados{
    //            case "11":
    //                botoes[coef[0] as! Int][coef[1] as! Int]
    //                break;
    //            case "12":
    //                if(jogador==2){
    //                    tic.movimento("12")
    //                    l12 = 1
    //                    l12 = 2
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
    //        }
    //    }
    //        }
    //    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
