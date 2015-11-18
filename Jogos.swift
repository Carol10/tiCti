//
//  Jogos.swift
//  tiCti
//
//  Created by Ana Caroline Saraiva Bezerra on 17/11/15.
//  Copyright © 2015 Ana Caroline Saraiva Bezerra. All rights reserved.
//

import UIKit

class Jogos: UIViewController {

    @IBOutlet weak var Bdamas: UIButton!
    @IBOutlet weak var Bvelha: UIButton!
    @IBOutlet weak var Bpontos: UIButton!
    
    @IBOutlet weak var I: UIImageView!
    @IBOutlet weak var J: UIImageView!
    @IBOutlet weak var K: UIImageView!
    
    
    @IBOutlet weak var foto1: UIImageView!
    @IBOutlet weak var foto2: UIImageView!
    @IBOutlet weak var foto3: UIImageView!
    
   
    @IBOutlet weak var nome1: UILabel!
    @IBOutlet weak var nome2: UILabel!
    @IBOutlet weak var nome3: UILabel!
    
    @IBOutlet weak var pedestal1: UIButton!
    @IBOutlet weak var pedestal2: UIButton!
    @IBOutlet weak var pedestal3: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Jogos"
        
       
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
