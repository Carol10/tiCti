//
//  TelaCadastro.swift
//  tiCti
//
//  Created by Ana Caroline Saraiva Bezerra on 08/11/15.
//  Copyright © 2015 Ana Caroline Saraiva Bezerra. All rights reserved.
//

import UIKit

class TelaCadastro: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate{

    ///tabela do icone na tela de cadastro
    @IBOutlet weak var CIconTable: UITableView!
    
    
    
    ///outras variáveis 
    
    @IBOutlet weak var TLogin: UIButton!
    
    
    var arrayDados:[String] = ["email", "senha", "nome"]
    
    @IBOutlet weak var Cadastar: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var senhaField: UITextField!
    @IBOutlet weak var nomeField: UITextField!
    
    var i =  1
    var j = 1

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //fazer a tela subir com o teclado
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        
        //colocando sombra e deixando o botões arredondados
        Cadastar.layer.shadowOpacity = 1.0
        Cadastar.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        Cadastar.layer.cornerRadius = 10.0
      
        
        //deixando o textfield arredondado 
        emailField.layer.cornerRadius = 12.0
        senhaField.layer.cornerRadius = 12.0
        nomeField.layer.cornerRadius = 12.0 
    
        
        //tableView
        self.CIconTable.dataSource = self
        self.CIconTable.delegate = self
        //--------------------------------------------------------------------------------------------------
        
        emailField.placeholder = "email@exemplo.com"
        nomeField.placeholder = "Ana Caroline"
        senhaField.secureTextEntry = true
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    ///funções do teclado
    func keyboardWillShow(sender: NSNotification)
    {
        if(i==1){
            self.view.frame.origin.y -= 45
            i = 2
        }
    }
    func keyboardWillHide(sender: NSNotification)
    {
        if(i==2){
            self.view.frame.origin.y += 45
            i = 1
        }
    }
    
    
    
    ///funções da tableview
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellc : CSCell = tableView.dequeueReusableCellWithIdentifier("CCell") as! CSCell
        
        cellc.setSCCell("Captura de Tela 2015-09-17 às 17.13.20.png")
        
        return cellc
    }
    
   
    
    /// funções de a ação nos botões

    @IBAction func cadastrarA(sender: AnyObject) {
        
        Registro()
        
        if(j == 1){
           self.performSegueWithIdentifier("ligaLogin", sender: self)
        }
        
        print(" ")
        print(arrayDados[0])
        print(arrayDados[1])
        print(arrayDados[2])
        print(" ")
        
    }

    
    //funções de registro------------------------------------------------------------------------------------
    
    func Registro() -> Void
    {
        
        arrayDados[0] = emailField.text!
        if(verificarEmai(arrayDados[0]) == false){
            let alert = UIAlertView()
            alert.title = "Email Inválido"
            alert.message = "Digite seu email novamente."
            alert.addButtonWithTitle("Close")
            alert.show()
            j = 2
        }else{
            j = 1
        }
        arrayDados[1] = senhaField.text!
        arrayDados[2] = nomeField.text!
        
    }
    
    
    func verificarEmai(email: String) -> Bool
    {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
            
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(email)
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
