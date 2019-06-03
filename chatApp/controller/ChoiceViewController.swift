//
//  ChoiceViewController.swift
//  chatApp
//
//  Created by eHeuristic on 19/04/19.
//  Copyright © 2019 eHeuristic. All rights reserved.
//

import UIKit

class ChoiceViewController: UIViewController {
    
    var types = ["Book Character","Book House", "Show Character", "Show House"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func btnfavSelected(sender: UIButton)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavoutiteViewController") as! FavoutiteViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnFirst(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.comefrom = "Book Character"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnsecond(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.comefrom = "Book House"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnthird(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.comefrom = "Show Character"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnfourth(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.comefrom = "Show House"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnfifth(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuizViewController") as! QuizViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnsix(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavViewController") as! FavViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


