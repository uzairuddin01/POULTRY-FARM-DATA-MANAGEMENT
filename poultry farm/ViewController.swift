//
//  ViewController.swift
//  poultry farm
//
//  Created by Apple on 18/06/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var eggoutlet: UIControl!
    @IBOutlet weak var birdsoutlet: UIControl!
    @IBOutlet weak var feedoutlet: UIControl!
    @IBOutlet weak var mortalityoutlet: UIControl!
    @IBOutlet weak var inventoryoutlet: UIControl!
    @IBOutlet weak var otheroutlet: UIControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        birdsoutlet.layer.borderWidth = 2
        birdsoutlet.layer.borderColor = UIColor.black.cgColor
        birdsoutlet.layer.cornerRadius = 15
        
        
        
        
        otheroutlet.layer.borderColor = UIColor.black.cgColor
        otheroutlet.layer.cornerRadius = 15
        otheroutlet.layer.borderWidth = 2
        
        
        
        inventoryoutlet.layer.borderColor = UIColor.black.cgColor
        inventoryoutlet.layer.cornerRadius = 15
        inventoryoutlet.layer.borderWidth = 2
        
        
        
        feedoutlet.layer.borderColor = UIColor.black.cgColor
        feedoutlet.layer.cornerRadius = 15
        feedoutlet.layer.borderWidth = 2
       
        
        
        mortalityoutlet.layer.borderColor = UIColor.black.cgColor
        mortalityoutlet.layer.cornerRadius = 15
        mortalityoutlet.layer.borderWidth = 2
        
        
        
        eggoutlet.layer.borderColor = UIColor.black.cgColor
        eggoutlet.layer.borderWidth = 2
        eggoutlet.layer.cornerRadius = 15
        
        
        
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func eggs(_ sender: Any) {
        performSegue(withIdentifier: "eggproduced", sender: self)
    }
    
    @IBAction func birds(_ sender: Any) {
        performSegue(withIdentifier: "eggrate", sender: self)
    }
    @IBAction func feed(_ sender: Any) {
        performSegue(withIdentifier: "feed", sender: self)
    }
    @IBAction func inventory(_ sender: Any) {
        performSegue(withIdentifier: "inv", sender: self)
    }
    @IBAction func mortality(_ sender: Any) {
        performSegue(withIdentifier: "mortality", sender: self)
    }
    @IBAction func otherexpenses(_ sender: Any) {
        performSegue(withIdentifier: "feedback", sender: self)
    }
    
}

