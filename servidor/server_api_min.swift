//
//  server_api_min.swift
//  serverClass
//
//  Created by Phablulo Joel on 06/11/15.
//  Copyright © 2015 Phablulo Joel. All rights reserved.
//

import UIKit

protocol tictiDelegate{
    //MARK: jogando
    func recebeuUmMovimento(de:String, dados:String)
    //MARK: interface
//    func atualiza()
    func pareou(com:String, jogo:UInt)
}
extension tictiDelegate{
    func recebeuUmMovimento(de:String, dados:String){
        print("Recebi um movimento de \(de): \(dados)")
    }
//    func atualiza(){
//        print("Dados do app se tornaram desatualizados")
//    }
    func pareou(com:String, jogo:UInt){
        print("Pareei com \(com) no jogo com id \(jogo)")
    }
}

class ticti: NSObject , NSStreamDelegate{
    var meuApelido:String = ""
    var inimigoApelido:String = ""
    var Hh = "172.16.3.33" // "10.0.0.102"
    var host = "http://172.16.3.33"//"http://10.0.0.105"
    var delegate = tictiDelegate?()
    
    var inputStream: NSInputStream?
    var outputStream: NSOutputStream?
    
    func connect(){
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, Hh, 86, &readStream, &writeStream)
        inputStream = readStream?.takeRetainedValue()
        outputStream = writeStream?.takeRetainedValue()
        
        inputStream!.delegate=self
        outputStream!.delegate=self
        
        inputStream!.setProperty(kCFBooleanTrue, forKey: kCFStreamPropertyShouldCloseNativeSocket as String)
        outputStream!.setProperty(kCFBooleanTrue, forKey: kCFStreamPropertyShouldCloseNativeSocket as String)
        inputStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        outputStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        inputStream?.open()
        outputStream?.open()
    }
    func inputStreamHandleEvent(eventCode:NSStreamEvent){
        switch(eventCode){
        case NSStreamEvent.OpenCompleted :
            print("Conectado com o servidor")
            //if(outputOpened && ) // should send some message to server?
            // sim. Envia o apelido.
            break
        case NSStreamEvent.HasBytesAvailable :
            if(inputStream!.hasBytesAvailable){
                // read bytes
                let bufferSize = 7168
                var buffer = Array<UInt8>(count: bufferSize, repeatedValue: 0)
                var len:Int?;
                while(inputStream!.hasBytesAvailable){
                    len = inputStream!.read(&buffer, maxLength: bufferSize*sizeof(UInt8))
                    let dString = NSData(bytes: buffer, length: len!)
                    let dic:NSDictionary = try! NSJSONSerialization.JSONObjectWithData(dString, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                    manageRecievedData(dic)
                }
            }
            break;
        case NSStreamEvent.HasSpaceAvailable :
            assert(false) // nunca deve acontecer para o inputStream
            break;
        case NSStreamEvent.ErrorOccurred :
            print("Erro ao conectar com o servidor. Tentando novamente em 5 segundos");
            reconnect()
            break;
        case NSStreamEvent.EndEncountered:
            // ignore.
            break;
        default:
            assert(false)
            break;
        }
    }
    
    func disconnect(){
        if(inputStream != nil){
            inputStream?.delegate=nil
            inputStream?.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode as String)
            inputStream?.close()
            inputStream = nil
        }
        if(outputStream != nil){
            outputStream?.delegate=nil
            outputStream?.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode as String)
            outputStream?.close()
            outputStream = nil
        }
    }
    
    func reconnect(){
        disconnect()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            self.connect()
        }
    }
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        //dispatch_async(dispatch_get_main_queue()) { () -> Void in
        if(aStream == self.inputStream){
            self.inputStreamHandleEvent(eventCode)
        }
    }
    
    // MARK: Send and recieve
    func send(let data:NSDictionary){
        let jdata = try! NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions(rawValue: 0))
        outputStream!.write(UnsafePointer<UInt8>(jdata.bytes), maxLength: jdata.length)
    }
    
    func manageRecievedData(data:NSDictionary){
        let type = data["type"] as! String
        switch type {
            case "movimento":
                delegate?.recebeuUmMovimento(((data["info"] as! NSDictionary)["from"] as! String), dados: data["data"] as! String)
                break;
            case "pareou":
                delegate?.pareou(data["com"] as! String, jogo: UInt(data["jogo"] as! String)!)
                break;
//            case "atualiza":
//                delegate?.atualiza()
//                break;
            default:
                print("Mensagem recebida, mas tipo desconhecido:")
                print(data)
                break;
        }
    }
    
    // MARK: requisições pelo python
    func entreiNoJogo(){
        let dic = ["type":"entrei","apelido":meuApelido];
        send(dic)
    }
    
    func movimento(dados:String){
        let dic = ["type":"movimento","info":["from":meuApelido,"to":inimigoApelido],"data":dados];
        send(dic)
    }
    
    func queroJogar(jogo:UInt){
        let dic = ["type":"queroJogar","jogo":"\(jogo)","apelido":meuApelido];
        send(dic)
    }
    
    func nQueroJogar(jogo:UInt){
        let dic = ["type":"nQueroJogar","jogo":jogo,"apelido":meuApelido];
        send(dic)
    }
    // MARK: Requisições por PHP
    
    func venceu(){
        let url: NSURL = NSURL(string: host+"?action=venceu&apelido=\(meuApelido)")!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url)
        task.resume()
    }
    
    func perdeu(){
        let url: NSURL = NSURL(string: host+"?action=perdeu&apelido=\(meuApelido)")!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url)
        task.resume()
    }
    
    func sair(){
        let url: NSURL = NSURL(string: host+"?action=saiuDoJogo&apelido=\(meuApelido)")!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url)
        task.resume()
    }
    
    // MARK: funções de interface
    func login(apelido:String, senha:String, callback:(sucesso:Bool, nome:String)->()){
        let url: NSURL = NSURL(string: host+"?action=login&apelido=\(apelido)&senha=\(senha)")!
        var result = NSDictionary()
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            result = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
            if(result["status"] as! String == "sucess" ){
                callback(sucesso: true, nome: result["nome"] as! String)
            }else{
                callback(sucesso: false, nome: "")
            }
        }
        task.resume()

    }
    func cadastra(nome:String, senha:String, apelido:String, callback:(sucesso:Bool) -> ()){
        let url: NSURL = NSURL(string: host+"?action=cadastra&nome=\(nome)&senha=\(senha)&apelido=\(apelido)")!
        var result = NSDictionary()
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            if (data == nil && response == nil){
                print("Veja isso:\nhttp://stackoverflow.com/questions/31254725/transport-security-has-blocked-a-cleartext-http")
                exit(1);
            }
            result = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
            if(result["status"] as! String == "sucess" ){
                callback(sucesso: true)
            }else{
                callback(sucesso: false)
            }
        }
        task.resume()
    }
    func verificaDisponibilidadeDoApelido(apelido: String, callback:(disponivel:Bool) -> ()){
        let url: NSURL = NSURL(string: host+"?action=disponibilidade&apelido=\(apelido)")!
        var result = NSDictionary()
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            result = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
            if(result["status"] as! String == "sucess" ){
                callback(disponivel: true)
            }else{
                callback(disponivel: false)
            }
        }
        task.resume()
    }
    func atualizarPerfil(nome:String,senha:String){
        let url: NSURL = NSURL(string: host+"?action=update&apelido=\(meuApelido)&nome=\(nome)&senha=\(senha)")!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url)
        task.resume()
    }
    func atualizarFoto(imagem:UIImage, callback:(enviado:Bool)->()){
        let imageData = UIImagePNGRepresentation(imagem)
        
        if imageData != nil{
            if(meuApelido == ""){
                print("Não posso enviar imagem porque a variável 'meuApelido' está vazia");
                return;
            }
            let url = host+"?action=uploadImage&apelido=\(meuApelido)"
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            //let session = NSURLSession.sharedSession()
            
            request.HTTPMethod = "POST"
            
            let boundary = NSString(format: "---------------------------14737809831466499882746641449")
            let contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
            print("Content Type \(contentType)")
            request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
            
            let body = NSMutableData()
            
            // Title
            body.appendData(NSString(format: "\r\n--%@\r\n",boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(NSString(format:"Content-Disposition: form-data; name=\"title\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Hello World".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
            
            // Image
            body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(NSString(format:"Content-Disposition: form-data; name=\"profile_img\"; filename=\"img.jpg\"\\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(imageData!)
            body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            
            request.HTTPBody = body
            
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                let result = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
                if(result["status"] as! String == "sucess"){
                    callback(enviado: true);
                }else{
                    callback(enviado: false);
                }
            }).resume()
        }
    }
    func dadosDoUsuario(apelido: String, callback:(nome:String,apelido:String,jogando:Bool,vitorias:UInt,derrotas:UInt,imagem:UIImage)->()){
        var url = host+"?action=getData&apelido=\(apelido)";
        var nome:String!,apelido:String!,jogando:Bool!,vitorias:UInt!,derrotas:UInt!,imagem:UIImage!;
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string:url)!) { (data, response, error) -> Void in
            
           let dic = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
            nome = dic["nome"] as! String
            apelido = dic["apelido"] as! String
            jogando = Int(dic["jogando"] as! String) == 0 ? false : true
            vitorias = UInt(dic["vitorias"] as! String)
            derrotas = UInt(dic["derrotas"] as! String)
            url = self.host+"?action=getImage&apelido=\(apelido)";
            
            NSURLSession.sharedSession().dataTaskWithURL(NSURL(string:url)!, completionHandler: { (Data, Response, Error) -> Void in
                imagem = UIImage(data: Data!);
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    callback(nome: nome, apelido: apelido, jogando: jogando, vitorias: vitorias, derrotas: derrotas, imagem: imagem);
                })
            }).resume()
        }
        task.resume()
    }
    func pegarRanking(callback:(NSArray)->()){
        let urlStr = host+"?action=getRanking"
        let url = NSURL(string: urlStr)!;
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            let arr = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSArray
            callback(arr)
            
        }
        task.resume()
    }
    
    //qqjoq -> quem quer jogar o quê
//    func atualizarDados(ranking:Bool, minhasInfo:Bool, jogos:Bool, qqjoq:Bool, callback:(NSDictionary) ->()){
//        let url: NSURL = NSURL(string: host+"?action=disponibilidade&apelido=")!
//        var result = NSDictionary()
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
//            result = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
//            callback(result);
//        }
//        task.resume()
//    }
    // ----
//    func acessURL(urlPath:String) -> NSDictionary{
//        let url: NSURL = NSURL(string: urlPath)!
//        var result = NSDictionary()
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
//            result = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
//        }
//        task.resume()
//        return result
//    }
}
