//
//  GameViewController.swift
//  LigaPontos
//
//  Created by Pedro Campos on 11/11/15.
//  Copyright (c) 2015 Pedro Campos. All rights reserved.
//


// so falta ajeitar o txt, de vez de cada jogador

import UIKit
import SpriteKit
import AVFoundation

var player1:Bool = true //player 1 // se for falso eh a vez do player2 :)
var winner:Int = -1
var t = ticti()
class GameViewController: UIViewController, tictiDelegate,  ARDAppClientDelegate, RTCEAGLVideoViewDelegate
{
    
    
    var meu_email = ""
    var inimigo_email = ""
    var souEu_str = String()
    var minhaVez:Bool = true
    
    let jogadaAudioPath = NSBundle.mainBundle().pathForResource("pen_sound", ofType: "mp3")!
    let errorAudioPath = NSBundle.mainBundle().pathForResource("error", ofType: "wav")!
    let doneAudioPath = NSBundle.mainBundle().pathForResource("done", ofType: "mp3")!
    var jogada = AVAudioPlayer()
    var errorSound = AVAudioPlayer()
    var doneSound = AVAudioPlayer()
    
    @IBOutlet var txt: UILabel! //texto que alerta sobre a vez de cada jogador
    
    @IBOutlet var butonsLat:[UIButton]!
    @IBOutlet var butonsTop:[UIButton]!
    @IBOutlet var box:[UIImageView]!
    
    var mapLat =
    [
        ["-","-","-","-","-","-"],
        ["-","-","-","-","-","-"],
        ["-","-","-","-","-","-"],
        ["-","-","-","-","-","-"],
        ["-","-","-","-","-","-"]
        
    ]
    
    var mapTop =
    [
        ["-","-","-","-","-"],
        ["-","-","-","-","-"],
        ["-","-","-","-","-"],
        ["-","-","-","-","-"],
        ["-","-","-","-","-"],
        ["-","-","-","-","-"]
    ]
    
    var images = [UIImage(), UIImage()]
    
    func finish()
    {
        var contP1 = 0
        
        var contP2 = 0
        
        for(var x = 0; x < box.count ; x++)
        {
            if(box[x].tag == 1)
            {
                contP1++
            }
            else if(box[x].tag == 2)
            {
                contP2++
            }
        }
        
        if(box.count == contP1 + contP2)
        {
            if(contP1 > contP2)//p1 ganha
            {
                winner = 1
                self.performSegueWithIdentifier("telaFim", sender: self)
            }
            else if(contP2 > contP1)//p2 ganha
            {
                winner = 2
                self.performSegueWithIdentifier("telaFim", sender: self)
            }
            else//empate
            {
                winner = 0
                self.performSegueWithIdentifier("telaFim", sender: self)
            }
        }
    }
    
    func analisaMapa() -> Void
    {
        for(var i = 0; i < 5; i++)
        {
            for(var j = 0; j < 5; j++)
            {
                
                if(mapLat[i][j] != "-" && mapTop[i][j] != "-" && mapLat[i][j + 1] != "-" && mapTop[i + 1][j] != "-")
                {
                   let z = i + j + i*4
                        
                    if(box[z].tag == 0)
                    {
                        if(player1 == true)//azul
                        {
                                box[z].image = UIImage(named: "boxBlue.png")
                                box[z].tag = 1
                            
                                minhaVez = true
                                txt.text = "Sua vez!"
                        }
                        else//verm
                        {
                                box[z].image = UIImage(named: "boxRed.png")
                                box[z].tag = 2
                            
                                minhaVez = true
                                txt.text = "Sua vez!"
                        }
                        
                        //som
                        do{
                            try doneSound = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: doneAudioPath))
                            
                                doneSound.volume = 0.5
                                doneSound.play()
                            
                        }catch
                        {
                            print("problema audio: done.mp3")
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func buttonPressed(sender: AnyObject)
    {
        let botao:UIButton = sender as! UIButton
        
        var aux:Int!
        
        let txtId:String = botao.restorationIdentifier!
        
        if(botao.tag == 0)
        {
            if(minhaVez)
            {
                minhaVez = false
                
                if(player1 == true)
                {
                    txt.text = "Vez do Jogador 2"
                    
                    aux = 1
                    
                    images[0] = UIImage(named: "tracoo.png")!
                    images[1] = UIImage(named: "tracooHor.png")!
                }
                else
                {
                    txt.text = "Vez do Jogador 1"
                    
                    aux = 2
                    
                    images[0] = UIImage(named: "tracooRed.png")!
                    images[1] = UIImage(named: "tracooRedHor.png")!
                }
                
                botao.tag = aux
                
                if txtId[txtId.startIndex.advancedBy(0)] == "t" //topnn
                {
                    botao.setBackgroundImage(images[0], forState: .Normal)
                    
                }
                else //latnn
                {
                    botao.setBackgroundImage(images[1], forState: .Normal)
                }
                
                jogada.play() //audio
                
                let coord1 = Int(String(txtId[txtId.startIndex.advancedBy(3)]))!
                let coord2 = Int(String(txtId[txtId.startIndex.advancedBy(4)]))!
                
                if txtId[txtId.startIndex.advancedBy(0)] == "t" //topnn
                {
                    //usa mapTop
                    
                    mapTop[coord1][coord2] = "\(aux)"
                    
                }
                else //latnn
                {
                    //usa mapLat
                    
                    mapLat[coord1][coord2] = "\(aux)"
                }
                
                analisaMapa()
                
                finish()
                
                //envia dados pra o outroJogador
                t.movimento("\(txtId)\(minhaVez)")
            }
            else
            {
                print("ainda nao chegou sua vez \(souEu_str)")
            }
            
        }
        else
        {
            
            errorSound.play()

        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //server
        t.delegate = self
        t.connect()
        
        t.meuemail = meu_email
        t.inimigoemail = inimigo_email
        
        souEu_str = t.meuemail
        //aqui eu decido quem vai ser o player 1 ou o 2
        t.entreiNoJogo()
        
        //--------

//        if let scene = GameScene(fileNamed:"GameScene")
//        {
//            // Configure the view.
//            let skView = self.view as! SKView
//            skView.showsFPS = true
//            skView.showsNodeCount = true
//            
//            /* Sprite Kit applies additional optimizations to improve rendering performance */
//            skView.ignoresSiblingOrder = true
//            
//            /* Set the scale mode to scale to fit the window */
//            scene.scaleMode = .AspectFill
//            
//            skView.presentScene(scene)
//        }
        //-----
        
        do
        {
            try errorSound = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: errorAudioPath))
            
                errorSound.volume = 0.02
            
            try jogada = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: jogadaAudioPath))
            
                jogada.volume = 0.05
            
        }catch
        {
            //processar o erro
            
            print("Erro no carregamento d audio")
        }
        
        //-----
        
        
        txt.text = "Vez do Jogador 1"
    }
    
    func adversarioConectou(email: String, sala_id: String)
    {
        player1 = true
        minhaVez = true
        txt.text = "Sua vez :)"
        configVideoConferencia(sala_id)
    }
    
    
    func aplicaDadosRecebidos(txtId:String)
    {
        var aux:Int!
        
        if !(player1 == true) //pq os dados recebidos sao do adversario entao inverte (!)
        {
            txt.text = "Vez do Jogador 2"
            
            aux = 1
            
            images[0] = UIImage(named: "tracoo.png")!
            images[1] = UIImage(named: "tracooHor.png")!
        }
        else
        {
            txt.text = "Vez do Jogador 1"
            
            aux = 2
            
            images[0] = UIImage(named: "tracooRed.png")!
            images[1] = UIImage(named: "tracooRedHor.png")!
        }
        
        let coord1 = Int(String(txtId[txtId.startIndex.advancedBy(3)]))!
        let coord2 = Int(String(txtId[txtId.startIndex.advancedBy(4)]))!
        
        if txtId[txtId.startIndex.advancedBy(0)] == "t" //topnn
        {
            let z = coord1 + coord2 + coord1*4
            
            butonsTop[z].tag = aux
            butonsTop[z].setBackgroundImage(images[0], forState: .Normal)
            
            mapTop[coord1][coord2] = "\(aux)"
            
        }
        else //latnn
        {
            let z = coord1 + coord2 + coord1*5
            
            butonsLat[z].tag = aux
            butonsLat[z].setBackgroundImage(images[1], forState: .Normal)
            
            mapLat[coord1][coord2] = "\(aux)"
            
        }
        
        //analisa mapa
        
        for(var i = 0; i < 5; i++)
        {
            for(var j = 0; j < 5; j++)
            {
                
                if(mapLat[i][j] != "-" && mapTop[i][j] != "-" && mapLat[i][j + 1] != "-" && mapTop[i + 1][j] != "-")
                {
                    let z = i + j + i*4
                    
                    if(box[z].tag == 0)
                    {
                        if !(player1 == true)
                        {
                            box[z].image = UIImage(named: "boxBlue.png")
                            box[z].tag = 1
                        }
                        else//verm
                        {
                            box[z].image = UIImage(named: "boxRed.png")
                            box[z].tag = 2
                        }
                    }
                }
            }
        }
        
        finish()
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).pontos=self
    }
    
    func recebeuUmMovimento(de: String, dados: String)
    {
        if let dado:String = dados //se nao for vazio
        {
            if souEu_str != de
            {
                aplicaDadosRecebidos(dado)
                
                //aki
                if( dado[dado.startIndex.advancedBy(5)] == "t") //joga denovo 
                {
                    minhaVez = false
                    txt.text = "Vez do outro jogador"
                }
                else
                {
                    minhaVez = true
                    txt.text = "Sua vez"
                }
            }
        }
    }
    
    override func shouldAutorotate() -> Bool
    {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask
    {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
    
    //MARK: -VideoConferencia!
    
    func recebeuIdDaSala(id: String) {
        print("id da sala recebido:\n\(id)")
        self.configVideoConferencia(id)
    }
    
    @IBOutlet weak var remoteView: RTCEAGLVideoView!
    let videoHost = "https://apprtc.appspot.com"
    var client:ARDAppClient!
    var remoteTrack:RTCVideoTrack!
    func configVideoConferencia(sala:String){
        //self.view.addSubview(remoteView)
        //UIApplication.sharedApplication().keyWindow?.addSubview(remoteView)
        client = ARDAppClient(delegate: self)
        client.serverHostUrl=videoHost
        client.connectToRoomWithId(sala, options: nil)
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
        t.sair()
    }
    override func viewWillDisappear(animated: Bool) {
        t.sair()
        client.disconnect()
        remoteView.removeFromSuperview()
    }
}
