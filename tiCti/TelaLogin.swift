//
//  TelaLogin.swift
//  tiCti
//
//  Created by Ana Caroline Saraiva Bezerra on 08/11/15.
//  Copyright © 2015 Ana Caroline Saraiva Bezerra. All rights reserved.
//

import UIKit

class TelaLogin: UIViewController, UITableViewDelegate, UITableViewDataSource, tictiDelegate{

    //conectar com servidor
    let tic = ticti()
    
    
    
    //tableview do icone ta tela de login
    @IBOutlet weak var LIconTable: UITableView!
    
    
    //outras variáreis 
    var i = 1
    var j = 0
    
   
    @IBOutlet weak var Email: UITextField!
    
    @IBOutlet weak var Senha: UITextField!
    
    @IBOutlet weak var cadastrar: UIButton!
    
    @IBOutlet weak var Login: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //conectar com o servidor
        tic.connect()
        
        //fazer a tela subir com o teclado
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        
        
        //deixando o textfield e o botão arredondado
        Email.layer.cornerRadius = 12.0
        Senha.layer.cornerRadius = 12.0
        Login.layer.cornerRadius = 12.0
        Login.layer.shadowOpacity = 1.0
        Login.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        Senha.secureTextEntry = true 
        
        
        
        
        //tableview
        self.LIconTable.dataSource = self
        self.LIconTable.delegate = self
        
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBarHidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func EntarNaConta(sender: AnyObject)
    {
        tic.login(Email.text!, senha: Senha.text!) { (sucesso, nome) -> () in
            if(sucesso){
                //self.presentViewController(nav, animated: true, completion: nil)
                self.performSegueWithIdentifier("Logar", sender: self)
            }else{
                let Alert1 = UIAlertController(title: "Inconsistencia no login", message:"Usuário ou senha incorretos.", preferredStyle: UIAlertControllerStyle.Alert)
                
                Alert1.addAction(UIAlertAction(title: "Close", style: .Default, handler: {
                    (action: UIAlertAction!) in
                }))
                self.presentViewController(Alert1, animated: true, completion: nil)
                
            }
            
        }
    
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "Logar"){
            let nav = segue.destinationViewController as! UINavigationController;
            let perfil = nav.topViewController as! PerfilViewController;
            perfil.meu_email = self.Email.text!
        }
    }
    
    ///funções do teclado
    func keyboardWillShow(sender: NSNotification) {
        if(i==1){
            self.view.frame.origin.y -= 50
            i = 2
        }
    }
    func keyboardWillHide(sender: NSNotification) {
        if(i==2){
            self.view.frame.origin.y += 50
            i = 1 
        }
    }
    
    
    ///funções da tableview
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let celll : LSCell = tableView.dequeueReusableCellWithIdentifier("LCell") as! LSCell
        
        celll.backgroundColor = UIColor(red:(29.0/255.0),green:(55.0/255.0),blue:(60.0/255.0),alpha:1.0)
        
        celll.setLSCell("fundochecker.png", center: "logoentradaTicti.png")
        
        return celll
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
