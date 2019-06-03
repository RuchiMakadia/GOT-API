//
//  QuizViewController.swift
//  chatApp
//
//  Created by eHeuristic on 22/04/19.
//  Copyright © 2019 eHeuristic. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    

    var arryList:[[String:Any]] = [[:]]
    
    
    @IBOutlet weak var imgstar: UIImageView!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    var answer = ""
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var actyvityImage: UIActivityIndicatorView!
    
    var counter = 0
    var questionCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APICALL(url: "https://api.got.show/api/show/characters")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activity.isHidden = false
        activity.startAnimating()
        activity.style =  UIActivityIndicatorView.Style.whiteLarge
        actyvityImage.startAnimating()
        actyvityImage.style = UIActivityIndicatorView.Style.whiteLarge
    }
    
   func Quiz()
   {
    
    if questionCounter == 20
    {
        questionCounter = 0
        let alert = UIAlertController(title: "Result", message: "Your result is" + "\(counter)", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        counter = 0

    }
    
    questionCounter = questionCounter + 1
    self.arryList = self.arryList.shuffled()
    let first = self.arryList[0]
    let second = self.arryList[1]
    let third = self.arryList[2]
    let fourth = self.arryList[3]
    
    
    imgstar.sd_setImage(with: URL(string: first["image"] as? String ?? ""), completed: nil)
    answer = first["name"] as? String ?? ""
    
    var ansarray = [String]()
    ansarray.append(first["name"] as? String ?? "")
    ansarray.append(second["name"] as? String ?? "")
    ansarray.append(third["name"] as? String ?? "")
    ansarray.append(fourth["name"] as? String ?? "")
    
    ansarray = ansarray.shuffled()
    btn1.setTitle(ansarray[0], for: UIControl.State.normal)
    btn2.setTitle(ansarray[1], for: UIControl.State.normal)
    btn3.setTitle(ansarray[2], for: UIControl.State.normal)
    btn4.setTitle(ansarray[3], for: UIControl.State.normal)
    
    }
    
    @IBAction func btn1selected(_ sender: UIButton) {
        if sender.titleLabel?.text == answer
        {
            
            print("true")
            counter = counter + 1
        }
        else
        {
           
            print("false")
        }
        Quiz()
        incrementcounter()
    }
    
    @IBAction func btn2Selected(_ sender: UIButton) {
        if sender.titleLabel?.text == answer
        {
            
            print("true")
             counter = counter + 1
        }
        else
        {
            
            print("false")
        }
        Quiz()
        incrementcounter()
    }
    
    @IBAction func btn3Selected(_ sender: UIButton) {
        if sender.titleLabel?.text == answer
        {
            
            print("true")
             counter = counter + 1
        }
        else
        {
           
            print("false")
        }
        Quiz()
        incrementcounter()
        
    }
    @IBAction func btn4Selected(_ sender: UIButton) {
        if sender.titleLabel?.text == answer
        {
           
            print("true")
            counter = counter + 1
        }
        else
        {
            print("false")
        }
        Quiz()
        incrementcounter()
    }
    
    func incrementcounter()
    {
        total.text = "\(counter)" + "/" + "20"
    }
    
    func APICALL(url: String)
    {
        let headers = [
            "cache-control": "no-cache",
            "Postman-Token": "e9ce3d67-39e9-4f95-b36d-533fea5aa878"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                let endDate = Date()
                
                if data != nil {
                    do {
                        let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String:Any]] ?? [["Error":"Cannot convert to structure"]]
                        print("==============================")
                        print("Response")
                      
                       for res in result
                       {
                            if let img = res["image"]
                            {
                                self.arryList.append(res)
                            }
                            else
                            {
                              print("not add")
                            }
                        }
                        self.activity.isHidden = true
                         self.Quiz()
                        print("==============================")
                    }
                    catch let error {
                        print(error.localizedDescription)
                    }
                }
                else {
                    print(error?.localizedDescription ?? "Something Went Wrong")
                }
            }
        })
        task.resume()
    }

}
