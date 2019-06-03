//
//  FavViewController.swift
//  chatApp
//
//  Created by eHeuristic on 22/04/19.
//  Copyright © 2019 eHeuristic. All rights reserved.
//

import UIKit
import CoreData

class FavViewController: UIViewController {
    
    var arrName = [NSManagedObject]()
    var dicarr = ["name": "","img": ""]
    var mainarr:[[String:String]] = []

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchdata()
        print(arrName.count)
        for data in arrName
        {
            let name = data.value(forKey: "name") as? String ?? ""
            let image = data.value(forKey: "img") as? String ?? ""
            dicarr["name"] = name
            dicarr["img"] = image
            print(dicarr)
            mainarr.append(dicarr)
        }
        
        
    }
    
    func fetchdata()
    {
        var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Model")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error {
                    fatalError("Unresolved error, \((error as NSError).userInfo)")
                }
            })
            return container
        }()
        
        let managedContext =  persistentContainer.viewContext
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Character")
        //3
        do {
            arrName = try managedContext.fetch(fetchRequest)
            tableview.reloadData()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}

extension FavViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainarr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavTableViewCell
        let dic = mainarr[indexPath.row]
        if  dic["img"] != ""
        {
            cell.imgbackground.sd_setImage(with: URL(string: dic["img"] ?? ""), completed: nil)
        }
        else
        {
            cell.imgbackground.image = UIImage(named: "download")
        }
        cell.lblName.text = dic["name"]
        return  cell
    }
    
    
}
