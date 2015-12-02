//
//  velhaViewController.swift
//  tiCti
//
//  Created by Ana Caroline Saraiva Bezerra on 19/11/15.
//  Copyright © 2015 Ana Caroline Saraiva Bezerra. All rights reserved.
//

import UIKit

class velhaViewController: UIViewController, tictiDelegate, ARDAppClientDelegate, RTCEAGLVideoViewDelegate{
    
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
    
    var botoes:[NSArray]!
    
    
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
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).velha=self
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
    
    func adversarioConectou(email: String, sala_id: String) {
        jogador = 1
        ehMinhaVez = true
        configVideoConferencia(sala_id)
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
    
    override func viewWillDisappear(animated: Bool) {
        tic.sair()
        remoteView.removeFromSuperview()
    }
    
    // MARK: Videoconferencia!
    func recebeuIdDaSala(id: String) {
        configVideoConferencia(id)
    }
    let videoHost = "https://apprtc.appspot.com"
    var remoteView: RTCEAGLVideoView!//(frame: CGRect())
    var client:ARDAppClient!
    var remoteTrack:RTCVideoTrack!
    func configVideoConferencia(sala:String){
        //print(">>>> \(altura)")
        let width:CGFloat = 200// altura/1.4
        remoteView = RTCEAGLVideoView(frame: CGRect(x: self.view.frame.size.width-width, y: 10, width: width, height: 250))
        remoteView.layer.zPosition=100
        //self.view.addSubview(remoteView)
        UIApplication.sharedApplication().keyWindow?.addSubview(remoteView)
        client = ARDAppClient(delegate: self)
        client.serverHostUrl=videoHost
        client.connectToRoomWithId(sala, options: nil)
        //remoteView.layer.zPosition = 100
        //client.set
    }
    func appClient(client: ARDAppClient!, didChangeState state: ARDAppClientState) {
        switch(state){
        case ARDAppClientState.Connected:
            print("conectado"); break;
        case ARDAppClientState.Connecting:
            print("conectando"); break;
        case ARDAppClientState.Disconnected:
            print("desconectado"); /*self.remoteDisconected();*/ break;
        }
    }
    func appClient(client: ARDAppClient!, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack!) {
        self.remoteTrack = remoteVideoTrack
        self.remoteTrack.addRenderer(self.remoteView)
    }
    func appClient(client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
        // nada, pois não vemos nosso proprio video
    }
    func appClient(client: ARDAppClient!, didError error: NSError!) {
        print("deu erro")
    }
    func videoView(videoView: RTCEAGLVideoView!, didChangeVideoSize size: CGSize) {
        print("size changed")
    }
    func appWillTerminate(){
        tic.sair()
    }

}