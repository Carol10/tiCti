//
//  Inicio.swift
//  Pontos
//
//  Created by Pedro Campos on 11/19/15.
//  Copyright © 2015 Pedro Campos. All rights reserved.
//

import UIKit

class Inicio: UIViewController
{
    @IBOutlet var load: UIImageView!
    
    var seg = Int()
    var timer = NSTimer()
    var arrayGif = Array<UIImage>()
    
    func contador()
    {
        seg++
        
        if seg == 5
        {
            load.stopAnimating()
            
            timer.invalidate()
            
            self.performSegueWithIdentifier("start", sender: self)
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        //-------
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "contador", userInfo: nil, repeats: true)
        
        for x in 1...36
        {
            let str = "loading-\(x) (arrastado).tiff"
            
            let img = UIImage(named:str)!
            
            arrayGif.append(img)
        }

        load.animationImages = arrayGif
        load.animationDuration = 1.0
        load.startAnimating()
        
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
