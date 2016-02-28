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
    //MARK: interface    //    func atualiza()

    func pareou(com:String, jogo:UInt)
    func adversarioConectou(email:String, sala_id:String)
    func recebeuIdDaSala(id:String)
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
    func adversarioConectou(email:String, sala_id:String){
        print("\(email) chegou na sala: \(sala_id)")
    }
    func recebeuIdDaSala(id:String){
        print("id da sala recebido:\n\(id)")
    }
}

class ticti: NSObject , NSStreamDelegate{
    
    let tictiQueue = dispatch_get_main_queue()//dispatch_queue_create("tiCti.Queue", DISPATCH_QUEUE_SERIAL)
    
    var meuemail:String = ""
    var inimigoemail:String = ""
    let Hh =  "ec2-52-35-18-221.us-west-2.compute.amazonaws.com" // "10.0.0.103" //
    let host = "http://ec2-52-35-18-221.us-west-2.compute.amazonaws.com"// "http://10.0.0.103" //
    var delegate = tictiDelegate?()
    
    var inputStream: NSInputStream?
    var outputStream: NSOutputStream?
    
    func connect(){
        print("tentando conectar ao servidor")
        dispatch_async(tictiQueue) { () -> Void in
            var readStream: Unmanaged<CFReadStream>?
            var writeStream: Unmanaged<CFWriteStream>?
            CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, self.Hh, 86, &readStream, &writeStream)
            self.inputStream = readStream?.takeRetainedValue()
            self.outputStream = writeStream?.takeRetainedValue()
            
            self.inputStream!.delegate=self
            self.outputStream!.delegate=self
            
            self.inputStream!.setProperty(kCFBooleanTrue, forKey: kCFStreamPropertyShouldCloseNativeSocket as String)
            self.outputStream!.setProperty(kCFBooleanTrue, forKey: kCFStreamPropertyShouldCloseNativeSocket as String)
            self.inputStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            self.outputStream?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            
            self.inputStream?.open()
            self.outputStream?.open()
        }
    }
    func inputStreamHandleEvent(eventCode:NSStreamEvent){
        switch(eventCode){
        case NSStreamEvent.OpenCompleted :
            print("Conectado com o servidor")
            break
        case NSStreamEvent.HasBytesAvailable :
            if self.inputStream == nil{
                return;
            }
            if(self.inputStream!.hasBytesAvailable){
                // read bytes
                let bufferSize = 7168
                var buffer = Array<UInt8>(count: bufferSize, repeatedValue: 0)
                //var len:Int?;
                while(self.inputStream!.hasBytesAvailable){
                    let mxLength = bufferSize*sizeof(UInt8)
                    if let len = self.inputStream?.read(&buffer, maxLength: mxLength){
                        let dString = NSData(bytes: buffer, length: len)
                        let str = String(data: dString, encoding: NSASCIIStringEncoding)
                        print(str!)
                        if(str != ""){
                            let dic:NSDictionary = try! NSJSONSerialization.JSONObjectWithData(dString, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                            self.manageRecievedData(dic)
                        }
                    }
                }
            }
            break;
        case NSStreamEvent.HasSpaceAvailable :
            assert(false) // nunca deve acontecer para o inputStream
            break;
        case NSStreamEvent.ErrorOccurred :
            print("Erro ao conectar com o servidor. Tentando novamente em 5 segundos");
            self.reconnect()
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
        if(self.inputStream != nil){
            self.inputStream?.delegate=nil
            self.inputStream?.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode as String)
            self.inputStream?.close()
            self.inputStream = nil
        }
        if(self.outputStream != nil){
            self.outputStream?.delegate=nil
            self.outputStream?.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode as String)
            self.outputStream?.close()
            self.outputStream = nil
        }
    }
    
    func reconnect(){
        self.disconnect()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            self.connect()
        }
    }
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        if(aStream == self.inputStream){
            self.inputStreamHandleEvent(eventCode)
        }
    }
    
    // MARK: Send and recieve
    func send(let data:NSDictionary){
        dispatch_async(tictiQueue) { () -> Void in
            if let jdata = try? NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions(rawValue: 0)){
                self.outputStream?.write(UnsafePointer<UInt8>(jdata.bytes), maxLength: jdata.length)
            }
        }
    }
    
    func manageRecievedData(data:NSDictionary){
        dispatch_async(tictiQueue) { () -> Void in
            let type = data["type"] as! String
            switch type {
            case "movimento":
                self.delegate?.recebeuUmMovimento(((data["info"] as! NSDictionary)["from"] as! String), dados: data["data"] as! String)
                break;
            case "pareou":
                self.delegate?.pareou(data["com"] as! String, jogo: UInt(data["jogo"] as! String)!)
                break;
            case "chegou":
                self.delegate?.adversarioConectou(data["email"] as! String, sala_id: data["sala_id"] as! String)
                break;
                //            case "atualiza":
                //                delegate?.atualiza()
                //                break;
            case "sala_id":
                self.delegate?.recebeuIdDaSala(data["id"] as! String)
                break;
            default:
                print("Mensagem recebida, mas tipo desconhecido:")
                print(data)
                break;
            }
        }
    }
    
    // MARK: requisições pelo python
    func entreiNoJogo(){
        let dic = ["type":"entrei","email":meuemail,"contra":inimigoemail];
        send(dic)
    }
    
    func movimento(dados:String){
        let dic = ["type":"movimento","info":["from":meuemail,"to":inimigoemail],"data":dados];
        send(dic)
    }
    
    func queroJogar(jogo:UInt){
        let dic = ["type":"queroJogar","jogo":"\(jogo)","email":meuemail];
        print(dic)
        send(dic)
    }
    
    func nQueroJogar(jogo:UInt){
        let dic = ["type":"nQueroJogar","jogo":jogo,"email":meuemail];
        send(dic)
    }
    // MARK: Requisições por PHP
    
    func venceu(){
        let url: NSURL = NSURL(string: host+"?action=venceu&email=\(meuemail)")!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url)
        task.resume()
    }
    
    func perdeu(){
        let url: NSURL = NSURL(string: host+"?action=perdeu&email=\(meuemail)")!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url)
        task.resume()
    }
    
    func sair(){
        let dic = ["type":"sair","email":meuemail,"inimigo":inimigoemail];
        send(dic)
        //        let url: NSURL = NSURL(string: host+"?action=saiuDoJogo&email=\(meuemail)")!
        //        let task = NSURLSession.sharedSession().dataTaskWithURL(url)
        //        task.resume()
    }
    
    // MARK: funções de interface
    func login(var email:String, var senha:String, callback:(sucesso:Bool, nome:String)->()){
        email = email.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        senha = senha.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let url: NSURL = NSURL(string: host+"?action=login&email=\(email)&senha=\(senha)")!
        //var result = NSDictionary()
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            if error != nil{
                callback(sucesso: false, nome: "")
                return;
            }
            if let result = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary{
                print(result)
                if(result["status"] as! String == "sucess" ){
                    dispatch_async(self.tictiQueue, { () -> Void in
                        callback(sucesso: true, nome: result["nome"] as! String)
                    })
                }else{
                    dispatch_async(self.tictiQueue, { () -> Void in
                        callback(sucesso: false, nome: "")
                    })
                }
            }
        }
        task.resume()
        
    }
    func cadastra(var nome:String, var senha:String, email:String, callback:(sucesso:Bool) -> ()){
        nome = nome.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!;
        senha = senha.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!;
        let url: NSURL = NSURL(string: host+"?action=cadastra&nome=\(nome)&senha=\(senha)&email=\(email)")!
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
    func verificaDisponibilidadeDoemail(email: String, callback:(disponivel:Bool) -> ()){
        let url: NSURL = NSURL(string: host+"?action=disponibilidade&email=\(email)")!
        //var result = NSDictionary()
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            if error != nil{
                //callback(disponivel: false)
                return;
            }
            if let result = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary{
                if(result["status"] as! String == "sucess" ){
                    callback(disponivel: true)
                }else{
                    callback(disponivel: false)
                }
            }
        }
        task.resume()
    }
    func atualizarPerfil(nome:String,senha:String){
        let url: NSURL = NSURL(string: host+"?action=update&email=\(meuemail)&nome=\(nome)&senha=\(senha)")!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url)
        task.resume()
    }
    func atualizarFoto(imagem:UIImage, callback:(enviado:Bool)->()){
        let imageData = UIImagePNGRepresentation(imagem)
        if imageData != nil{
            if(meuemail == ""){
                print("Não posso enviar imagem porque a variável 'meuemail' está vazia");
                return;
            }
            let url = host+"?action=uploadImage&email=\(meuemail)"
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            //let session = NSURLSession.sharedSession()
            
            request.HTTPMethod = "POST"
            
            let boundary = NSString(format: "---------------------------14737809831466499882746641449")
            let contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
            request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
            
            let body = NSMutableData()
            
            // Title
            body.appendData(NSString(format: "\r\n--%@\r\n",boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(NSString(format:"Content-Disposition: form-data; name=\"title\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            //body.appendData("Hello World".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
            
            // Image
            body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(NSString(format:"Content-Disposition: form-data; name=\"profile_img\"; filename=\"img.jpg\"\\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(imageData!)
            body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            
            request.HTTPBody = body
            
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                if error != nil{
                    dispatch_async(self.tictiQueue, { () -> Void in
                        callback(enviado: false)
                    })
                    return;
                }
                let result = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                //print(result)
                
                if(result["status"] as! String == "sucess"){
                    dispatch_async(self.tictiQueue, { () -> Void in
                        callback(enviado: true);
                    })
                }else{
                    dispatch_async(self.tictiQueue, { () -> Void in
                        callback(enviado: false);
                    })
                }
            }).resume()
        }
    }
    func dadosDoUsuario(email: String, callback:(nome:String,email:String,jogando:Bool,vitorias:UInt,derrotas:UInt,imagem:UIImage)->()){
        var url = host+"?action=getData&email=\(email)";
        var nome:String!,email:String!,jogando:Bool!,vitorias:UInt!,derrotas:UInt!,imagem:UIImage!;
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string:url)!) { (data, response, error) -> Void in
            
            let dic = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
            nome = dic["nome"] as! String
            email = dic["email"] as! String
            jogando = Int(dic["jogando"] as! String) == 0 ? false : true
            vitorias = UInt(dic["vitorias"] as! String)
            derrotas = UInt(dic["derrotas"] as! String)
            url = self.host+"?action=getImage&email=\(email)";
            
            NSURLSession.sharedSession().dataTaskWithURL(NSURL(string:url)!, completionHandler: { (Data, Response, Error) -> Void in
                print("ola")
                if Data != nil{
                    imagem = UIImage(data: Data!);
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        callback(nome: nome, email: email, jogando: jogando, vitorias: vitorias, derrotas: derrotas, imagem: imagem);
                    })
                }
                
            }).resume()
        }
        task.resume()
    }
    func pegarRanking(callback:(dados:NSArray,imagens:NSArray)->()){
        let urlStr = host+"?action=getRanking"
        let url = NSURL(string: urlStr)!;
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            if error != nil{
                return;
            }
            let arr = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSArray
            let iarr = NSMutableArray();
            var n = 0;
            for p:NSDictionary in (arr as! [NSDictionary]){
                let URL = self.host+"?action=getImage&email=\(p["email"])"
                print(URL)
                NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: URL)!, completionHandler: { (data, response, error) -> Void in
                    if (data != nil){
                        iarr.addObject(UIImage(data: data!)!)
                        n++;
                        if(n == 3){
                            dispatch_async(self.tictiQueue, { () -> Void in
                                callback(dados: arr, imagens: iarr)
                            })
                        }
                    }
                }).resume()
            }
            //callback(arr)
            
        }
        task.resume()
    }
    
    //qqjoq -> quem quer jogar o quê
    //    func atualizarDados(ranking:Bool, minhasInfo:Bool, jogos:Bool, qqjoq:Bool, callback:(NSDictionary) ->()){
    //        let url: NSURL = NSURL(string: host+"?action=disponibilidade&email=")!
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