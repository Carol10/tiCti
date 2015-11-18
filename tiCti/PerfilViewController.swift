//
//  PerfilViewController.swift
//  tiCti
//
//  Created by Ana Caroline Saraiva Bezerra on 11/11/15.
//  Copyright © 2015 Ana Caroline Saraiva Bezerra. All rights reserved.
//

import UIKit

class PerfilViewController: UIViewController {
    
    //outras variáveis
    @IBOutlet weak var fotoPerfil: UIImageView!
    @IBOutlet weak var editarFoto: UIButton!
    @IBOutlet weak var pts: UILabel!
    @IBOutlet weak var nomeUser: UILabel!
    
    @IBOutlet weak var SairdoApp: UIBarButtonItem!
    
    @IBOutlet weak var menJogos: UIBarButtonItem!
    
    var i = 0;
    
    @IBOutlet weak var tutorial: UIButton!
    @IBOutlet weak var alterarDados: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pts.text = "1000 pts"
        nomeUser.text = "Ana Caroline"

        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica", size: 30)!], forState: .Normal)
        self.navigationController?.navigationBar.tintColor = UIColor(red:(29.0/255.0),green:(55.0/255.0),blue:(60.0/255.0),alpha:1.0)
       
 
        
        
        
        ///setando a cor o tamanho do titulo de navigation 
        let attrs = [
            NSForegroundColorAttributeName : UIColor(red:(29.0/255.0),green:(55.0/255.0),blue:(60.0/255.0),alpha:1.0),
            NSFontAttributeName : UIFont(name: "Helvetica", size: 30)!
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs
        UINavigationBar.appearance().barTintColor = UIColor(red:(168.0/255.0),green:(200.0/255.0),blue:(89.0/255.0),alpha:1.0)

    
        
        //deixando a foto do perfil arredondada
        fotoPerfil.image = UIImage(named: "Captura de Tela 2015-09-17 às 17.13.20.png")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
