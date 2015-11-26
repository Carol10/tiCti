//
//  ViewController.swift
//  damas
//
//  Created by Phablulo Joel on 11/11/15.
//  Copyright © 2015 Phablulo Joel. All rights reserved.
//

import UIKit

class DamasViewController: UIViewController, tictiDelegate,ARDAppClientDelegate, RTCEAGLVideoViewDelegate {
    
    var meu_email = ""
    var inimigo_email = ""
    
    var tabuleiro = [String:quadrado]();
    //var mesa:UIView!
    var aresta:CGFloat = 0;
    let t = ticti();
    var meu_turno = false;
    var peças_comidas:CGFloat = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ondamas")
        colocaTabuleiro()
        start()
    }
    
    func start(){
        t.delegate=self
        
        t.connect()
        t.meuemail=meu_email
        t.inimigoemail=inimigo_email
        t.entreiNoJogo()
    }
    func colocaTabuleiro(){
        self.view.backgroundColor=UIColor.whiteColor()
        aresta = self.view.frame.size.width/CGFloat(8)
//        mesa = UIView(frame: CGRect(x: 0, y: y, width: self.view.frame.size.width, height: self.view.frame.size.width))
//        mesa.backgroundColor=UIColor.grayColor()
//        self.view.addSubview(mesa)
        
        var p = false;
        for(var i:CGFloat = 0; i < 8; i++){ // linhas
            for(var j = 0; j < 8; j++){ // colunas
                let x:CGFloat, y:CGFloat;
                x = CGFloat(j)*aresta; y = 250+i*aresta;
                let nome:String = "\(Int(i))\(Int(j))";
                let B = quadrado(frame: CGRect(x: x,y: y,width: aresta,height: aresta))
                B.usavel=true
                B.userInteractionEnabled=false;
                B.linha = Double(i);
                B.coluna = Double(j);
                if(p){
                    B.backgroundColor = UIColor.blackColor()
                    B.is_black=true
                }else{
                    B.backgroundColor = UIColor.whiteColor()
                    B.is_black=false
                }
                self.view.addSubview(B)
                //self.mesa.addSubview(B)
                tabuleiro[nome] = B;
                p = !p;
            }
            p = !p;
        }
        // colocar peças
        for i in 0...2{ // inimigo
            for j in 0...7{
                if(p){
                    let q = tabuleiro["\(Int(i))\(Int(j))"]!;
                    q.ocupado=true
                    let arestaBola = aresta/1.2;
                    let b = bolinha(frame: CGRect(x: 0, y: 0, width: arestaBola, height: arestaBola))
                    b.layer.cornerRadius = arestaBola/2
                    b.clipsToBounds=true;
                    b.center = q.center
                    b.image=UIImage(named: "vermelho.png")
                    q.bola=b
                    self.view.addSubview(b)
                    //self.mesa.addSubview(b)
                }
                p = !p;
            }
            p = !p;
        }
        for i in 5...7{ // eu
            for j in 0...7{
                if(p){
                    let q = tabuleiro["\(Int(i))\(Int(j))"]!;
                    q.ocupado=true
                    let arestaBola = aresta/1.2;
                    let b = bolinha(frame: CGRect(x: 0, y: 0, width: arestaBola, height: arestaBola))
                    b.userInteractionEnabled=true;
                    b.layer.cornerRadius = arestaBola/2
                    b.clipsToBounds=true;
                    b.center = q.center
                    b.image=UIImage(named: "azul.png")
                    q.bola=b
                    self.view.addSubview(b)
                }
                p = !p;
            }
            p = !p;
        }
    }
    
    
    // --
    var movendo:Bool=false;
    var movido_primeiro=false;
    var primeira_bolinha:bolinha?;
    var last_location:CGPoint?
    var ultimo_lugar:CGPoint?;
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(!meu_turno) { return }
        let touch = touches.first;
        if let b = touch?.view as? bolinha{
            movido_primeiro=true;
            self.ultimo_lugar = b.center
            primeira_bolinha = b;
            primeira_bolinha?.layer.zPosition=999;
            last_location = touch?.locationInView(self.view)
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.primeira_bolinha?.transform=CGAffineTransformMakeScale(1.3, 1.3)
            })
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(!movido_primeiro){ return }
        movendo=true;
        let touch = touches.first
        if let _ = touch?.view as? bolinha{
            let current_location = touch?.locationInView(self.view)
            let movimento = CGVector(dx: current_location!.x - last_location!.x, dy: current_location!.y - last_location!.y)
            primeira_bolinha!.center = CGPoint(x: primeira_bolinha!.center.x + movimento.dx , y: primeira_bolinha!.center.y + movimento.dy)
            last_location = current_location;
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?){
        if(movendo && movido_primeiro){
            //print(primeira_bolinha)
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.primeira_bolinha?.transform=CGAffineTransformIdentity
            })
            
            if(!meu_turno){ return }
            let touch = touches.first!
            let location = touch.locationInView(self.view)
            let novo_quadrado:quadrado = pegaQuadradoNoPonto(location)
            let ultimo_quadrado:quadrado = pegaQuadradoNoPonto(ultimo_lugar!)
            primeira_bolinha?.layer.zPosition=1
            
            if(!novo_quadrado.usavel){
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.primeira_bolinha?.center=self.ultimo_lugar!;
                })
                primeira_bolinha=nil;
                movendo=false
                return;
            }
            
            //MARK: Regras!
            var movimento_aceito = false
            var string_for_server=""
            var fez_dama = "nao"
            if(!primeira_bolinha!.é_dama){
                //MARK: nao pode pular mais de uma casa
                if(novo_quadrado.linha - ultimo_quadrado.linha == -1 && fabs(novo_quadrado.coluna - ultimo_quadrado.coluna) == 1){
                    movimento_aceito=true
                    let uql = Int(ultimo_quadrado.linha)
                    let uqc = Int(ultimo_quadrado.coluna)
                    let nql = Int(novo_quadrado.linha)
                    let nqc = Int(novo_quadrado.coluna)
                    
                    if novo_quadrado.linha == 0{
                        fez_dama = "sim"
                    }
                    
                    string_for_server = "{\"de\":\"\(7-uql)\(7-uqc)\",\"para\":\"\(7-nql)\(7-nqc)\",\"comeu\":\"nao\", \"fez_dama\": \"\(fez_dama)\"}"
                }
                    
                    //MARK: COMER!
                else if(fabs(novo_quadrado.linha - ultimo_quadrado.linha) == 2 && fabs(novo_quadrado.coluna - ultimo_quadrado.coluna) == 2){
                    
                    let nome = "\(Int((ultimo_quadrado.linha+novo_quadrado.linha)/2))\(Int((ultimo_quadrado.coluna+novo_quadrado.coluna)/2))"
                    print("nome: \(nome), ocupado: \(tabuleiro[nome]!.ocupado)")
                    if(tabuleiro[nome]!.ocupado){
                        movimento_aceito=true;
                        peças_comidas++;
                        self.tabuleiro[nome]!.ocupado=false
                        print(peças_comidas)
                        UIView.animateWithDuration(0.5, animations: { () -> Void in
                            self.tabuleiro[nome]!.bola?.center=CGPoint(x: 20+self.aresta*self.peças_comidas, y: self.view.frame.size.height + CGFloat(2)*self.aresta)
                            }, completion: { (complete) -> Void in
                                self.tabuleiro[nome]!.bola=nil;
                        })
                        let uql = Int(ultimo_quadrado.linha)
                        let uqc = Int(ultimo_quadrado.coluna)
                        let nql = Int(novo_quadrado.linha)
                        let nqc = Int(novo_quadrado.coluna)
                        let cql = Int((ultimo_quadrado.linha+novo_quadrado.linha)/2)
                        let cqc = Int((ultimo_quadrado.coluna+novo_quadrado.coluna)/2)
                        
                        if novo_quadrado.linha == 0{
                            fez_dama = "sim"
                        }
                        
                        string_for_server = "{\"de\":\"\(7-uql)\(7-uqc)\",\"para\":\"\(7-nql)\(7-nqc)\",\"comeu\":\"sim\",\"comido\":\"\(7-cql)\(7-cqc)\",\"qts\":\"\(Int(peças_comidas))\", \"fez_dama\": \"\(fez_dama)\"}"
                    }
                }
            }else{ // é dama!
                print("é dama")
            }
            
            
            //----
            //print("is_black: \(novo_quadrado.is_black), ocupado: \(novo_quadrado.ocupado), aceito: \(movimento_aceito))")
            if(novo_quadrado.is_black && !novo_quadrado.ocupado && movimento_aceito){
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.primeira_bolinha?.center=novo_quadrado.center;
                })
                novo_quadrado.bola=self.primeira_bolinha!
                if(fez_dama == "sim"){
                    self.primeira_bolinha!.é_dama = true
                }
                t.movimento(string_for_server)
                ultimo_quadrado.ocupado=false
                ultimo_quadrado.bola=nil
                meu_turno=false
            }else{
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.primeira_bolinha?.center=self.ultimo_lugar!;
                })
            }
            primeira_bolinha=bolinha()
            movendo=false
        }
        
    }
    func pegaQuadradoNoPonto(ponto:CGPoint) -> quadrado{
        let rct = CGRectMake(ponto.x-1, ponto.y-1, 2, 2);
        for (_,i) in tabuleiro{
            if(CGRectIntersectsRect(rct, i.frame)){
                return i;
            }
        }
        return quadrado();
    }
    
    //MARK: TicTi delegate
    
    func recebeuUmMovimento(de: String, dados: String) {
        let dta = dados.dataUsingEncoding(NSASCIIStringEncoding)
        let js = try! NSJSONSerialization.JSONObjectWithData(dta!, options: NSJSONReadingOptions(rawValue: 0))
        print(js)
        let antigo_quadrado = tabuleiro[js["de"] as! String];
        antigo_quadrado?.ocupado=false
        let novo_quadrado = self.tabuleiro[js["para"] as! String];
        novo_quadrado!.ocupado=true
        novo_quadrado!.bola=antigo_quadrado!.bola;
        meu_turno=true
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            antigo_quadrado!.bola!.center = self.tabuleiro[js["para"] as! String]!.center
            }) { (completed) -> Void in
                antigo_quadrado?.bola=nil;
                antigo_quadrado?.ocupado=false
        }
        if(js["comeu"] as! String == "sim"){
            //print(js["comido"] as! String)
            let t = tabuleiro[js["comido"] as! String];
            let qts = CGFloat(Int(js["qts"] as! String)!);
            //print(t?.bola)
            t?.ocupado=false
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                t?.bola?.center=CGPoint(x: 20 + self.aresta*qts, y: self.view.frame.size.height + self.aresta)
                }, completion: { (completed) -> Void in
                    t?.bola=nil
            })
        }
        if(js["fez_dama"] as! String == "sim"){
            novo_quadrado!.bola?.image=(UIImage(named: "vermelho_dama.png"))
        }
    }
    override func viewWillDisappear(animated: Bool) {
        t.sair()
    }
    func adversarioConectou(apelido: String, sala_id:String) {
        print("\(apelido) conectou.")
        meu_turno=true;
        let y = fabs(self.view.frame.size.width - self.view.frame.size.height) - 2*aresta
        self.configVideoConferencia(y, sala: sala_id)
    }
    
    func recebeuIdDaSala(id: String) {
        print("id da sala recebido:\n\(id)")
        let y = fabs(self.view.frame.size.width - self.view.frame.size.height) - 2*aresta
        self.configVideoConferencia(y, sala: id)
    }
    
    // MARK: Videoconferencia!
    let videoHost = "https://apprtc.appspot.com"
    var remoteView: RTCEAGLVideoView!//(frame: CGRect())
    var client:ARDAppClient!
    var remoteTrack:RTCVideoTrack!
    func configVideoConferencia(altura:CGFloat, sala:String){
        print(">>>> \(altura)")
        let width:CGFloat = 200// altura/1.4
        remoteView = RTCEAGLVideoView(frame: CGRect(x: self.view.frame.size.width-width, y: 0, width: width, height: 250))
        remoteView.layer.zPosition=100
        self.view.addSubview(remoteView)
        client = ARDAppClient(delegate: self)
        client.serverHostUrl=videoHost
        client.connectToRoomWithId(sala, options: nil)
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
    
}

