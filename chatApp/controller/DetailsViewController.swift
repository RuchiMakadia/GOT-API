//
//  DetailsViewController.swift
//  chatApp
//
//  Created by eHeuristic on 28/03/19.
//  Copyright © 2019 eHeuristic. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData


class DetailsViewController: UIViewController {
    
    @IBOutlet weak var lblStarName: UILabel!
    @IBOutlet weak var lblHouse: UILabel!
    @IBOutlet weak var imgStar: UIImageView!
    @IBOutlet weak var lblSlug: UILabel!
    @IBOutlet weak var lblBook: UILabel!
    @IBOutlet weak var lblTitles: UILabel!
    @IBOutlet weak var btnfavoourite: UIButton!
    @IBOutlet weak var lblactorname: UILabel!
    @IBOutlet weak var lblapperances: UILabel!
    @IBOutlet weak var lblsibling: UILabel!
    @IBOutlet weak var lblApprences: UILabel!
    
    var comefrom: String?
    var starname: String?
    var starimg:UIImage?
    var house:String?
    var slug:String?
    var book:[String]?
    var Titles:[String]?
    var starImageURL:String?
    var starid:Int?
    var arrName = [NSManagedObject]()
    var CharacterarrayList:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(CharacterarrayList)
  
        
        if comefrom == "Show House"
        {
            lblStarName.text = CharacterarrayList?.value(forKey: "name") as! String
            imgStar.sd_setImage(with: URL(string: CharacterarrayList?.value(forKey: "logoURL") as? String ?? "download"), completed: nil)
            lblHouse.text = "SIGIL" + "   "  + "\(CharacterarrayList?.value(forKey: "sigil") as! String)"
            lblSlug.text = "WORDS :" + "   " + "\(CharacterarrayList?.value(forKey: "words") as! String)"
            let sibling = CharacterarrayList?.value(forKey: "allegiance") as! [String]
            lblBook.text =  sibling.joined(separator: "\n")
        }
        else if comefrom == "Show Character"
        {
            lblStarName.text = CharacterarrayList?.value(forKey: "name") as! String
            imgStar.sd_setImage(with: URL(string: CharacterarrayList?.value(forKey: "image") as? String ?? "download"), completed: nil)
            lblHouse.text = "HOUSE" + "   "  + "\(CharacterarrayList?.value(forKey: "house") as! String)"
            lblSlug.text = "SLUG :" + "   " + "\(CharacterarrayList?.value(forKey: "slug") as! String)"
            let sibling = CharacterarrayList?.value(forKey: "siblings") as! [String]
            lblBook.text =  sibling.joined(separator: "\n")
            let titlearray = CharacterarrayList?.value(forKey: "titles") as! [String]
            lblTitles.text = titlearray.joined(separator: "\n")
            lblactorname.text = "ACTOR NAME" + "   " + "\(CharacterarrayList?.value(forKey: "actor") as! String)"
           // let appeance = CharacterarrayList?.value(forKey: "appearances") as! [String]
           // lblapperances.text = appeance.joined(separator: "\n")
            lblApprences.text = ""
            lblapperances.text = ""
        }
        else if comefrom == "Book Character"
        {
            lblStarName.text = CharacterarrayList?.value(forKey: "name") as? String ?? ""
            imgStar.sd_setImage(with: URL(string: CharacterarrayList?.value(forKey: "image") as? String ?? "download"), completed: nil)
            lblHouse.text = "HOUSE" + "   "  + "\(CharacterarrayList?.value(forKey: "house") as? String ?? "")"
            lblSlug.text = "SLUG :" + "   " + "\(CharacterarrayList?.value(forKey: "slug") as? String ?? "")"
            let sibling = CharacterarrayList?.value(forKey: "books") as! [String]
            lblBook.text =  sibling.joined(separator: "\n")
            lblsibling.text = "BOOKS"
            let titlearray = CharacterarrayList?.value(forKey: "titles") as! [String]
            lblTitles.text = titlearray.joined(separator: "\n")
            lblactorname.text = ""//"ACTOR NAME" + "   " + "\(CharacterarrayList?.value(forKey: "actor") as! String)"
            let appeance = CharacterarrayList?.value(forKey: "allegiance") as! [String]
            lblapperances.text = appeance.joined(separator: "\n")
            lblApprences.text =  "ALLEGIANCE"
        }
        else if comefrom == "Book House"
        {
            lblStarName.text = CharacterarrayList?.value(forKey: "name") as! String
            imgStar.sd_setImage(with: URL(string: CharacterarrayList?.value(forKey: "image") as? String ?? "download"), completed: nil)
            lblHouse.text = "REGION" + "   "  + "\(CharacterarrayList?.value(forKey: "region") as! String)"
            lblSlug.text = "SEAT :" + "   " + "\(CharacterarrayList?.value(forKey: "seat") as! String)"
            let sibling = CharacterarrayList?.value(forKey: "overlords") as! [String]
            lblsibling.text = "OVERLOADS"
            lblBook.text =  sibling.joined(separator: "\n")
            let titlearray = CharacterarrayList?.value(forKey: "titles") as! [String]
            lblTitles.text = titlearray.joined(separator: "\n")
            //lblactorname.text = "ACTOR NAME" + "   " + "\(CharacterarrayList?.value(forKey: "actor") as! String)"
            let appeance = CharacterarrayList?.value(forKey: "coatOfArms") as! String
            lblapperances.text = appeance
            lblApprences.text = "COAT OF ARMS: "
            lblactorname.text = ""
        }
        
        fetchdata()
        btnfavoourite.setImage(#imageLiteral(resourceName: "heart_icon"), for: UIControl.State.selected)
        
        for person in arrName
        {
            let name = person.value(forKey: "name") as? String
            if name == lblStarName.text!
            {
                btnfavoourite.isSelected = true
                btnfavoourite.setImage(#imageLiteral(resourceName: "heart_icon_filled"), for: UIControl.State.selected)
                return
            }
        }
    }
    
    @IBAction func btnFavouriteSelected(_ sender: UIButton) {
        if btnfavoourite.isSelected
        {
            btnfavoourite.setImage(#imageLiteral(resourceName: "heart_icon"), for: UIControl.State.normal)
            btnfavoourite.isSelected = false
            RemoveToFav(withID: CharacterarrayList?.value(forKey: "name") as! String)
            
        }
        else
        {
            btnfavoourite.setImage(#imageLiteral(resourceName: "heart_icon_filled"), for: UIControl.State.selected)
            btnfavoourite.isSelected = true
            print(starImageURL)
            addTofav(name: lblStarName.text ?? "",
                     image: CharacterarrayList?.value(forKey: "image") as? String ?? "",
                     sibling: CharacterarrayList?.value(forKey: "siblings") as? [String] ?? [""],
                     title: CharacterarrayList?.value(forKey: "titles") as? [String] ?? [""],
                     house: lblHouse.text ?? "",
                     slug: lblSlug.text ?? "",
                     id:  CharacterarrayList?.value(forKey: "id") as! String,
                     apperance: CharacterarrayList?.value(forKey: "appearances") as? [String] ?? [""],
                     actorname: lblactorname.text ?? "")
        }
    }

    @IBAction func btnshareselcted(_ sender: Any) {
        
        UIImageWriteToSavedPhotosAlbum(imgStar.image!, self, #selector(imageSaved(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
   @objc func imageSaved(image: UIImage!, didFinishSavingWithError error: NSError?, contextInfo: AnyObject?) {
        if (error != nil) {
           
        } else {
           let alert = UIAlertController(title: "SAVE", message: "Picture Save Successfully", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func RemoveToFav(withID: String?)
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
         let fetchRequest: NSFetchRequest<Character> = Character.fetchRequest()
         fetchRequest.predicate = NSPredicate(format: "name = %@", withID!) //NSPredicate.init(format: "name==\(withID!)")
        
        
         do {
            let objects = try managedContext.fetch(fetchRequest)
            for object in objects {
                managedContext.delete(object)
            }
            try managedContext.save()
        } catch _ {
            
        }
    }
    
    func addTofav(name:String?, image:String?, sibling: [String]?, title: [String]?, house: String?, slug: String?, id: String?, apperance: [String]?, actorname: String?)
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
            let entity =
                NSEntityDescription.entity(forEntityName: "Character",
                                           in: managedContext)!
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            // 3
            person.setValue(name, forKeyPath: "name")
            person.setValue(image, forKey: "img")
            person.setValue(title?.joined(separator: ","), forKey: "title")
            person.setValue(house, forKey: "house")
            person.setValue(slug, forKey: "slug")
            person.setValue(sibling?.joined(separator: ","), forKey: "sibling")
            person.setValue(id, forKey: "id")
            person.setValue(apperance?.joined(separator: ","), forKey: "apperances")
            person.setValue(actorname, forKey: "actorname")
            // 4
            do {
                try managedContext.save()
            } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
