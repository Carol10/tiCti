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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        
        
        
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellc : CSCell = tableView.dequeueReusableCellWithIdentifier("CCell") as! CSCell
        
        cellc.setSCCell("Captura de Tela 2015-09-17 às 17.13.20.png")
        
        return cellc
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
