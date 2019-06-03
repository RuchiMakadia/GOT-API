//
//  FavoutiteViewController.swift
//  chatApp
//
//  Created by eHeuristic on 29/03/19.
//  Copyright © 2019 eHeuristic. All rights reserved.
//

import UIKit
import CoreData

protocol FlowLayout: class {
    
    func cellDidMovedUp(_ cell: UICollectionViewCell?, indexPath: IndexPath?)
    //... call when cell move left
    func cellDidMovedLeft(_ cell: UICollectionViewCell?, indexPath: IndexPath?)
    //... call when cell move right
    func cellDidMovedRight(_ cell: UICollectionViewCell?, indexPath: IndexPath?)
    //... call when cell not move
    func cellDidNotMoved(_ cell: UICollectionViewCell?, indexPath: IndexPath?)
    //... check cell should move up or not
    func shouldCellMoveUp(for indexpath: IndexPath?) -> Bool
    
}

class FavoutiteViewController: UIViewController, FlowLayout {
   

    @IBOutlet weak var collectionview: UICollectionView!
    
     var arrName = [NSManagedObject]()
     var dic = [String:String]()
     var array:[String:String]?
    
    var dicarr = ["name": "","img": ""]
    var mainarr:[[String:String]] = []
    
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
        
        
        print(mainarr)
        let xibname = UINib(nibName: "FavouriteActionCollectionViewCell", bundle: nil)
        collectionview.register(xibname, forCellWithReuseIdentifier: "FavouriteActionCollectionViewCell")
        
        let cLayout = CustomFlowLayout()
        cLayout.delegate = self;
        collectionview.setCollectionViewLayout(cLayout, animated: false)
        
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
            collectionview.reloadData()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func cellDidMovedUp(_ cell: UICollectionViewCell?, indexPath: IndexPath?) {
        
        mainarr.remove(at: indexPath?.row ?? 0)
        collectionview.reloadData()
    }
    
    func cellDidMovedLeft(_ cell: UICollectionViewCell?, indexPath: IndexPath?) {
        print("move left")
    }
    
    func cellDidMovedRight(_ cell: UICollectionViewCell?, indexPath: IndexPath?) {
        /*PhotoCollectionViewCell *cellPhoto = (PhotoCollectionViewCell *) [collCoverFlow cellForItemAtIndexPath:indexPath];
        cellPhoto.imgLikeUnLike.hidden = false;
        cellPhoto.imgLikeUnLike.image = [UIImage imageNamed:@"unlike"];*/
        
      /*  let favcell = FavouriteActionCollectionViewCell()
        collectionview.indexPath(for: favcell) */
        
        
    }
    
    func cellDidNotMoved(_ cell: UICollectionViewCell?, indexPath: IndexPath?) {
         print("move not")
    }
    
    func shouldCellMoveUp(for indexpath: IndexPath?) -> Bool {
        return mainarr.count != 0;
    }
}

extension FavoutiteViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainarr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteActionCollectionViewCell", for: indexPath) as! FavouriteActionCollectionViewCell
        let dic = mainarr[indexPath.row]
         cell.lblStarName.text = dic["name"]
        if  dic["img"] != ""
        {
         cell.imgStar.sd_setImage(with: URL(string: dic["img"] ?? ""), completed: nil)
        }
        else
        {
          cell.imgStar.image = UIImage(named: "download")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = UIScreen.main.bounds.size.width * 304/375;
        return CGSize(width: size, height: size)
        
    }
    
}
