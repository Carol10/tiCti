//
//  AlterarDadosViewController.swift
//  tiCti
//
//  Created by Ana Caroline Saraiva Bezerra on 19/11/15.
//  Copyright © 2015 Ana Caroline Saraiva Bezerra. All rights reserved.
//

import UIKit

class AlterarDadosViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nomeField: UITextField!
    @IBOutlet weak var senhaField: UITextField!
    
    @IBOutlet weak var atualizaEmail: UIButton!
    @IBOutlet weak var atualizaNome: UIButton!
    @IBOutlet weak var atualizaSenha: UIButton!
    @IBOutlet weak var atualizaTudo: UIButton!
    
    
    let tic = ticti()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.navigationItem.title = "Alterar Dados"
        // Do any additional setup after loading the view.
        
        //arrendondar os botões e colocar sombras
        atualizaEmail.layer.shadowOpacity = 1.0
        atualizaEmail.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        atualizaEmail.layer.cornerRadius = 10.0
        
        atualizaNome.layer.shadowOpacity = 1.0
        atualizaNome.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        atualizaNome.layer.cornerRadius = 10.0
        
        atualizaSenha.layer.shadowOpacity = 1.0
        atualizaSenha.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        atualizaSenha.layer.cornerRadius = 10.0
        
        atualizaTudo.layer.shadowOpacity = 1.0
        atualizaTudo.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        atualizaTudo.layer.cornerRadius = 10.0
        
        //arredondar o textField
        emailField.layer.cornerRadius = 12.0
        nomeField.layer.cornerRadius = 12.0
        senhaField.layer.cornerRadius = 12.0
        
        
        tic.connect()
        
        
        atualizaEmail.addTarget(self, action: Selector("mudarEmail"), forControlEvents: UIControlEvents.TouchUpInside)
        atualizaNome.addTarget(self, action: Selector("mudarNome"), forControlEvents: UIControlEvents.TouchUpInside)
        atualizaSenha.addTarget(self, action: Selector("mudarSenha"), forControlEvents: UIControlEvents.TouchUpInside)
        atualizaTudo.addTarget(self, action: Selector("mudarTudo"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mudarEmail(){
        
    }
    func mudarNome(){
        
    }
    func mudarSenha(){
        
    }
    func mudarTudo(){
        
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
