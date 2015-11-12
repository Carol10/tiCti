//
//  TelaCadastro.swift
//  tiCti
//
//  Created by Ana Caroline Saraiva Bezerra on 08/11/15.
//  Copyright © 2015 Ana Caroline Saraiva Bezerra. All rights reserved.
//

import UIKit

class TelaCadastro: UIViewController, UITableViewDataSource, UITableViewDelegate{

    ///tabela do icone na tela de cadastro
    @IBOutlet weak var CIconTable: UITableView!
    
    
    
    ///outras variáveis 
    
    @IBOutlet weak var Prox: UIButton!
    @IBOutlet weak var Voltar: UIButton!
    @IBOutlet weak var Perg: UILabel!
    @IBOutlet weak var Dados: UITextField!
    @IBOutlet weak var TLogin: UIButton!
    
    
    var arrayDados:[String] = ["email", "nome", "senha", "comfSenha", "apelido"]
    
    
    var estado:Int = 0  //[0] submeter email, se ok, e continuar;
                        //[1] submete nome e sobrenome, continuar
                        //[2] submete senha, se ok, continua
                        //[3] confima senha, se ok, continua
                        //[4] submete ID, se ok, e continua pro editor de perfil
    var entrada = 1
    var retorno = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //fazer a tela subir com o teclado
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        
        //colocando sombra e deixando o botões arredondados
        Prox.layer.shadowOpacity = 1.0
        Voltar.layer.shadowOpacity = 1.0
        
        Prox.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        Voltar.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        
        Prox.layer.cornerRadius = 10.0
        Voltar.layer.cornerRadius = 10.0
        
        //deixando o textfield arredondado 
        Dados.layer.cornerRadius = 12.0
    
        
        //tableView
        self.CIconTable.dataSource = self
        self.CIconTable.delegate = self
        //--------------------------------------------------------------------------------------------------
        
        //inicializando o registro
        if(estado == 0 && entrada == 1){
            Registro(estado)
            entrada = 0
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    ///funções do teclado
    func keyboardWillShow(sender: NSNotification)
    {
        self.view.frame.origin.y -= 150
    }
    func keyboardWillHide(sender: NSNotification)
    {
        self.view.frame.origin.y += 150
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
    
   
    @IBAction func DadosAField(sender: AnyObject)
    {
        
    }
    
    
    /// funções de a ação nos botões
    @IBAction func ProximoA(sender: AnyObject)
    {
        Registro(estado)
        
        print(" ")
        print(arrayDados[0])
        print(arrayDados[1])
        print(arrayDados[2])
        print(arrayDados[3])
        print(arrayDados[4])
        print(" ")
    }
    
    @IBAction func VoltarA(sender: AnyObject)
    {
        if(estado == 0){
            self.dismissViewControllerAnimated(true, completion: nil)
        }else{
            retorno = 1
            estado = estado - 1
            Registro(estado)
        }
    }

    
    //funções de registro------------------------------------------------------------------------------------
    
    func Registro(estado: Int) -> Void
    {
        if(estado == 0){
            Perg.text = "Insira seu email"
            Dados.placeholder = "email@exemplo.com"
            Dados.text = ""
            self.estado = estado + 1
            
        }else if(estado == 1){
            Perg.text = "Insira seu nome"
            Dados.placeholder = "Ana Caroline da Silva"
            if(retorno == 0){
                arrayDados[0] = Dados.text!
            }else{
                retorno = 0
            }
            Dados.text = ""
            self.estado = estado + 1
            
        }else if(estado == 2){
            Perg.text = "Insira sua senha"
            Dados.secureTextEntry = true
            Dados.placeholder = "no mínimo 6 dígitos"
            if(retorno == 0){
                arrayDados[1] = Dados.text!
            }else{
                retorno = 0
            }
            Dados.text = ""
            self.estado = estado + 1
        
        }else if(estado == 3){
            Perg.text = "Confirme sua senha"
            Dados.placeholder = "no mínimo 6 dígitos"
            if(retorno == 0){
                arrayDados[2] = Dados.text!
            }else{
                retorno = 0
            }
            verificaSenha(arrayDados[2], senha2: arrayDados[3])
            Dados.text = ""
            self.estado = estado + 1
        
        }else if(estado == 4){
            Perg.text = "Insira seu apelido"
            Dados.secureTextEntry = false
            Dados.placeholder = "Carol"
            if(retorno == 0){
                arrayDados[3] = Dados.text!
            }else{
                retorno = 0
            }
            Dados.text = ""
            self.estado = estado + 1
            
        }else if(estado == 5){
            if(retorno == 0){
                arrayDados[4] = Dados.text!
            }else{
                retorno = 0
            }
        
        }
        
    }
    
    func verificaSenha(senha1: String, senha2: String) -> Void
    {
        
        if(senha1 != senha2){

        }else{
      
        }
        
    }
    
    func verificarEmai(email: String) -> Void
    {
        
        
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
