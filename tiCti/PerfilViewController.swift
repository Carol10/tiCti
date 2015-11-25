//
//  PerfilViewController.swift
//  tiCti
//
//  Created by Ana Caroline Saraiva Bezerra on 11/11/15.
//  Copyright © 2015 Ana Caroline Saraiva Bezerra. All rights reserved.
//

import UIKit

class PerfilViewController: UIViewController, tictiDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var meu_email:String = ""
    
    //conestando com o servidor 
    let tic = ticti()
    
    
    //outras variáveis
    @IBOutlet weak var fotoPerfil: UIImageView!
    @IBOutlet weak var editarFoto: UIButton!
    @IBOutlet weak var pts: UILabel!
    @IBOutlet weak var nomeUser: UILabel!
    
    @IBOutlet weak var SairdoApp: UIBarButtonItem!
    
    @IBOutlet weak var menJogos: UIBarButtonItem!
    
    var i = 0;
    var imageP = UIImagePickerController()
    
    @IBOutlet weak var tutorial: UIButton!
    @IBOutlet weak var alterarDados: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("email: \(meu_email)")
        //conectar com o servidor
        tic.connect()
        
        tic.dadosDoUsuario(meu_email) { (nome, email, jogando, vitorias, derrotas, imagem) -> () in
            self.nomeUser.text = nome
            self.pts.text = "\(vitorias) pts"
            self.fotoPerfil.image = imagem
            
            
        }

        // Do any additional setup after loading the view.

        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica", size: 30)!], forState: .Normal)
        self.navigationController?.navigationBar.tintColor = UIColor(red:(29.0/255.0),green:(55.0/255.0),blue:(60.0/255.0),alpha:1.0)
        
        
        
        self.imageP.delegate = self
        
       
 
        
        
        
        ///setando a cor o tamanho do titulo de navigation 
        let attrs = [
            NSForegroundColorAttributeName : UIColor(red:(29.0/255.0),green:(55.0/255.0),blue:(60.0/255.0),alpha:1.0),
            NSFontAttributeName : UIFont(name: "Helvetica", size: 30)!
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs
        UINavigationBar.appearance().barTintColor = UIColor(red:(168.0/255.0),green:(200.0/255.0),blue:(89.0/255.0),alpha:1.0)

    
        
        //deixando a foto do perfil arredondada
        fotoPerfil.layer.cornerRadius = self.fotoPerfil.frame.size.width / 2
        self.fotoPerfil.clipsToBounds = true;
        
        
        //programando o botão editar foto e outros
        editarFoto.backgroundColor = UIColor(red: (220.0/255.0), green: (97.0/255.0), blue: (9.0/255.0), alpha: 1.0)
        editarFoto.layer.shadowOpacity = 1.0
        editarFoto.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        editarFoto.layer.cornerRadius = 10.0
        
        tutorial.layer.shadowOpacity = 1.0
        tutorial.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        tutorial.layer.cornerRadius = 10.0
        
        alterarDados.layer.shadowOpacity = 1.0
        alterarDados.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        alterarDados.layer.cornerRadius = 10.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if( segue.identifier == "jogosMenu"){
            let jg = segue.destinationViewController as! Jogos;
            jg.meu_email = meu_email
        }
    }
    
    @IBAction func EditaFotoA(sender: AnyObject) {
        imageP.allowsEditing = false
        imageP.sourceType = .PhotoLibrary
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.presentViewController(self.imageP, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        fotoPerfil.image = image
        
        tic.meuemail = meu_email
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tic.atualizarFoto(image) { (enviado) -> () in
                if enviado {
                    let Alert1 = UIAlertController(title: "Editar foto", message:"sua foto foi alterada com sucesso!", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    Alert1.addAction(UIAlertAction(title: "Close", style: .Default, handler: {
                        (action: UIAlertAction!) in
                    }))
                    self.presentViewController(Alert1, animated: true, completion: nil)
                    
                }else{
                    let Alert2 = UIAlertController(title: "Editar foto", message: "Não foi possível alterar sua foto no momento, tente novamente mais tarde.", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    Alert2.addAction(UIAlertAction(title: "Close", style: .Default, handler: {
                        (action: UIAlertAction!) in
                    }))
                    self.presentViewController(Alert2, animated: true, completion: nil)
                    
                }
                
            }
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
