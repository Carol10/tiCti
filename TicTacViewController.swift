

import UIKit

var winnerTicTacToe:String = String();

class TicTacViewController: UIViewController, tictiDelegate,  ARDAppClientDelegate, RTCEAGLVideoViewDelegate
{
    let tic = t
    // 1 = o, 2 = x
    
    var player1:Bool    = false;
    var minhaVez:Bool   = false;
    
    var meu_email       = "";
    var inimigo_email   = "";
    
    var souEu_str       = "";
    
    var gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0];
    
    let winningCombinations =   [
                                    [0, 1, 2],
                                    [3, 4, 5],
                                    [6, 7, 8],
                                    [0, 3, 6],
                                    [1, 4, 7],
                                    [2, 5, 8],
                                    [0, 4, 8],
                                    [2, 4, 6]
                                ];

    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet var vezLabel:UILabel!
    
    var image   = UIImage();
    
    @IBAction func buttonPressed(sender: AnyObject)
    {
        
        if gameState[sender.tag] == 0 && minhaVez == true
        {
            
            tic.movimento("\(sender.tag!)");
            
            if player1//bola
            {
                gameState[sender.tag]   = 1;
                
                image                   = UIImage(named: "o.png")!;
                
                vezLabel.text           = "Vez do jogador 2"
            }
            else
            {
                gameState[sender.tag]   = 2;
                
                image                   = UIImage(named: "x.png")!;
                
                vezLabel.text           = "Vez do jogador 1"
                
            }
            
            sender.setImage(image, forState: .Normal);
            
            minhaVez = false;
            
            for combination in winningCombinations
            {
                
                if gameState[combination[0]] != 0 && gameState[combination[0]] == gameState[combination[1]] && gameState[combination[1]] == gameState[combination[2]]
                {
                    winnerTicTacToe = "1\(player1)";
                    
                    if gameState[combination[0]] == 2
                    {
                        winnerTicTacToe = "2\(player1)";
                    }
                    
                    self.performSegueWithIdentifier("fimDeJogo", sender: self);
                    
                }
                
            }
            
            for var i = 0; i < gameState.count; i++
            {
                if gameState[i] == 0
                {
                    return;
                }
                
                if i == (gameState.count - 1)
                {
                    winnerTicTacToe = "E\(player1)"; //empate
                    print(winnerTicTacToe);
                    self.performSegueWithIdentifier("fimDeJogo", sender: self);
                }
            }
            
        }
        
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //server
        tic.delegate      = self;
        tic.connect();
        
        tic.meuemail      = meu_email;
        tic.inimigoemail  = inimigo_email;
        souEu_str       = tic.meuemail;
    
        tic.entreiNoJogo();
        
        if player1
        {
            vezLabel.text = "Vez do jogador 2"
        }
        else
        {
            vezLabel.text = "Vez do jogador 1"
        }
        
    }
    
    func adversarioConectou(email: String, sala_id: String)
    {
        player1          = true;
        minhaVez         = true;
        vezLabel.text    = "Sua jogada"
        //configVideoConferencia(sala_id)
    }
    
    func recebeuUmMovimento(de: String, dados: String)
    {
        if let dado:String = dados //se nao for vazio
        {
            if souEu_str != de
            {
                aplicaDadosRecebidos(dado);
                
                analisaDados();
                
                minhaVez      = true;
                
                vezLabel.text = "Sua jogada"
            }
        }
    }
    
    func aplicaDadosRecebidos(dad:String)
    {
        let dado:Int        = Int(String(dad))!
        
        if(player1)
        {
            gameState[dado] = 2;
            image           = UIImage(named: "x.png")!;
        }
        else
        {
            gameState[dado] = 1;
            image           = UIImage(named: "o.png")!;
        }
        
        buttons[dado].setImage(image, forState: .Normal);
        
    }
    
    func analisaDados()
    {
        
        for combination in winningCombinations
        {
            
            if gameState[combination[0]] != 0 && gameState[combination[0]] == gameState[combination[1]] && gameState[combination[1]] == gameState[combination[2]]
            {
                
                winnerTicTacToe = "1\(player1)";print(winnerTicTacToe);
                
                if gameState[combination[0]] == 2
                {
                    winnerTicTacToe = "2\(player1)";print(winnerTicTacToe);
                }
                
                self.performSegueWithIdentifier("fimDeJogo", sender: self);
            }
            
        }
        
        for var i = 0; i < gameState.count; i++
        {
            if gameState[i] == 0
            {
                return;
            }
            
            if i == (gameState.count - 1)
            {
                winnerTicTacToe = "E\(player1)"; //empate
                print(winnerTicTacToe);
                self.performSegueWithIdentifier("fimDeJogo", sender: self);
                
            }
        }
    }

    // MARK: Videoconferencia!
    func recebeuIdDaSala(id: String)
    {
        configVideoConferencia(id)
    }
    
    let videoHost = "https://apprtc.appspot.com"
    var remoteView: RTCEAGLVideoView!//(frame: CGRect())
    var client:ARDAppClient!
    var remoteTrack:RTCVideoTrack!
    
    func configVideoConferencia(sala:String)
    {
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
    
    func appClient(client: ARDAppClient!, didChangeState state: ARDAppClientState)
    {
        switch(state)
        {
        case ARDAppClientState.Connected:
            print("conectado"); break;
        case ARDAppClientState.Connecting:
            print("conectando"); break;
        case ARDAppClientState.Disconnected:
            print("desconectado"); /*self.remoteDisconected();*/ break;
        }
    }
    func appClient(client: ARDAppClient!, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack!)
    {
        self.remoteTrack = remoteVideoTrack
        self.remoteTrack.addRenderer(self.remoteView)
    }
    
    func appClient(client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!)
    {
        // nada, pois não vemos nosso proprio video
    }
    func appClient(client: ARDAppClient!, didError error: NSError!)
    {
        print("deu erro")
    }
    func videoView(videoView: RTCEAGLVideoView!, didChangeVideoSize size: CGSize)
    {
        print("size changed")
    }
    func appWillTerminate()
    {
        tic.sair()
    }

}

