//
//  ViewController.swift
//  tiCti
//
//  Created by Ana Caroline Saraiva Bezerra on 08/11/15.
//  Copyright © 2015 Ana Caroline Saraiva Bezerra. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //tabela de uma única celula pra cololcar o Icone do App
    @IBOutlet weak var IconTable: UITableView!
    
    
    //outras variáveis
    @IBOutlet weak var cadastrado: UIButton!
    @IBOutlet weak var Ncadastrado: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //sombras nos botões
        cadastrado.layer.shadowOpacity = 1.0
        Ncadastrado.layer.shadowOpacity = 1.0
        cadastrado.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        Ncadastrado.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        
        //deixar os botões arredondados 
        cadastrado.layer.cornerRadius = 10.0
        Ncadastrado.layer.cornerRadius = 10.0
        
        //segues
        cadastrado.addTarget(self, action: "vaiLogin", forControlEvents: UIControlEvents.TouchUpInside)
        Ncadastrado.addTarget(self, action: "vaiCadastro", forControlEvents: UIControlEvents.TouchUpInside)
        
        //tableView
        self.IconTable.dataSource = self
        self.IconTable.delegate = self
        
    }
    
    func vaiLogin(){
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            self.performSegueWithIdentifier("proLogin", sender: self)
        })
    }
    func vaiCadastro(){
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            self.performSegueWithIdentifier("proCadastro", sender: self)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //Funções que controlam a minha TableView---------------------------------------------------------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell : ScreenCell = tableView.dequeueReusableCellWithIdentifier("MyCell") as! ScreenCell
        
        cell.setCell("fundochecker.png",center: "logoentradaTicti.png")
        
        return cell
    }

}

