//
//  ViewController.swift
//  chatApp
//
//  Created by eHeuristic on 28/03/19.
//  Copyright © 2019 eHeuristic. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UISearchControllerDelegate {

    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var activityIndi: UIActivityIndicatorView!
    
   // var mainarray:[[String:Any]]?
    
    var subarralist:[[String:Any]] = []
    {
        didSet
        {
            arrayList = subarralist
        }
    }
    var arrayList:[[String:Any]]? = []
    {
        didSet {
            collectionview.reloadData()
        }
    }
    
    

    var comefrom: String?
    
    var searchController = UISearchController(searchResultsController: nil)
    private lazy var searchTextField: UITextField? = { [unowned self] in
        var textField: UITextField?
        searchController.searchBar.subviews.forEach({ view in
            view.subviews.forEach({ view in
                if let view  = view as? UITextField {
                    textField = view
                    textField?.textColor = UIColor.white
                    
                }
            })
        })
        return textField
        }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        if let layout = collectionview?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            let size = CGSize(width:(collectionview!.bounds.width-30)/2, height: 250)
            layout.itemSize = size
        }
        
        
        // Declare the searchController
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Name"
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        
        if let bg = self.searchTextField?.subviews.first {
            bg.backgroundColor = UIColor.white
            bg.layer.cornerRadius = 10
            bg.clipsToBounds = true
        }
        self.navigationItem.searchController = searchController
        
      
        if comefrom == "Show House"
        {
            self.title = "Show House"
             APICALL(url: "https://api.got.show/api/show/houses")
        }
        else if comefrom == "Show Character"
        {
             self.title = "Show Character"
            APICALL(url: "https://api.got.show/api/show/characters")
        }
        else if comefrom == "Book Character"
        {
             self.title = "Book Character"
            APICALL(url: "https://api.got.show/api/book/characters")
        }
        else if comefrom == "Book House"
        {
             self.title = "Book House"
            APICALL(url: "https://api.got.show/api/book/houses")
        }
        
       // FILEDATA()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndi.isHidden = false
        activityIndi.startAnimating()
        activityIndi.style = UIActivityIndicatorView.Style.whiteLarge
        
    }
    
   /* func FILEDATA()
    {
        if let path = Bundle.main.path(forResource: "game-of-thrones", ofType: "json") {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
                if let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String:Any], let jsonDataArray = jsonResult?["data"] as? [[String:Any]] {
                    print(jsonDataArray)
                    mainarray = jsonDataArray
                }
            }
        }
    }*/
    
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
                        
                        if self.comefrom == "Show House"
                        {
                            for res in result
                            {
                                if let img = res["logoURL"]
                                {
                                     self.arrayList?.append(res)
                                }
                            }
                        }
                        else
                        {
                            for res in result
                            {
                                if let img = res["image"]
                                {
                                    self.arrayList?.append(res)
                                }
                            }
                        }
                       
                        print(self.arrayList)
                        
                        print(self.arrayList?.count)
                        self.activityIndi.isHidden = true
                        self.collectionview.reloadData()
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
    
    @objc func searchRestaurant(searchString:String) {
        let mainArray = subarralist
       collectionview.reloadData()
        
    }

}
extension ViewController: UISearchBarDelegate
{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.arrayList = subarralist
            collectionview.reloadData()
        }
        else {
            searchRestaurant(searchString: searchText)
        }
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      /*  let yourWidth = collectionView.bounds.width/2.0
        let yourHeight = yourWidth */
        
       // return CGSize(width: yourWidth, height: yourHeight)
        
         return CGSize(width: collectionView.frame.size.width * 0.49, height: collectionView.frame.size.height * 0.50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                cell.imgstar.transform = .init(scaleX: 0.80, y: 0.80)
                cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                cell.imgstar.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
   

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        let newone = arrayList?[indexPath.item] as! NSDictionary
        cell.lblStarName.text = newone.object(forKey: "name") as? String ?? ""
    
        if !cell.isanimated {
            
            UIView.animate(withDuration: 0.8, delay: 0.2 * Double(indexPath.row), usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: indexPath.row % 2 == 0 ? .transitionFlipFromLeft : .transitionFlipFromRight, animations: {
                
                if indexPath.row % 2 == 0 {
                    AnimationUtility.viewSlideInFromLeft(toRight: cell)
                    
                   // AnimationUtility.viewSlideInFromTop(toBottom: cell)
                }
                else {
                    AnimationUtility.viewSlideInFromRight(toLeft: cell)
                    
                   //AnimationUtility.viewSlideInFromBottom(toTop: cell)
                }
                
            }, completion: { (done) in
                cell.isanimated = true
            })
        }
    
        let points = [GradientPoint(location: 0.7, color: #colorLiteral(red: 0.1073596948, green: 0.1156472783, blue: 0.1281023116, alpha: 0.02660101232)), GradientPoint(location: 0.95, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))]
        UIImage(size: CGSize(width: 300, height: 300), gradientPoints: points)
        cell.imgstar.gradated(gradientPoints: points)
         cell.imgstar.image = UIImage(named: "download")
        if comefrom == "Show House"
        {
           cell.imgstar.sd_setImage(with: URL(string: newone.object(forKey: "logoURL") as? String ?? "download"), completed: nil)
        }
        else if comefrom == "Show Character"
        {
            cell.imgstar.sd_setImage(with: URL(string: newone.object(forKey: "image") as? String ?? "download"), completed: nil)
        }
        else if comefrom == "Book Character"
        {
            cell.imgstar.sd_setImage(with: URL(string: newone.object(forKey: "image") as? String ?? "download"), completed: nil)
        }
        else if comefrom == "Book House"
        {
            cell.imgstar.sd_setImage(with: URL(string: newone.object(forKey: "image") as? String ?? "download"), completed: nil)
        }
        else
        {
            cell.imgstar.image = UIImage(named: "download")
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        let newone = arrayList?[indexPath.item] as! NSDictionary
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        vc.CharacterarrayList = newone
        vc.comefrom = comefrom
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
        
class AnimationUtility: UIViewController, CAAnimationDelegate {
    
    static let kSlideAnimationDuration: CFTimeInterval = 0.85
    
    static func viewSlideInFromRight(toLeft views: UIView) {
        var transition: CATransition? = nil
        transition = CATransition.init()
        transition?.duration = kSlideAnimationDuration
        transition?.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition?.type = CATransitionType.push
        transition?.subtype = CATransitionSubtype.fromRight
        //        transition?.delegate = (self as! CAAnimationDelegate)
        views.layer.add(transition!, forKey: nil)
    }
    
    static func viewSlideInFromLeft(toRight views: UIView) {
        var transition: CATransition? = nil
        transition = CATransition.init()
        transition?.duration = kSlideAnimationDuration
        transition?.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition?.type = CATransitionType.push
        transition?.subtype = CATransitionSubtype.fromLeft
        //        transition?.delegate = (self as! CAAnimationDelegate)
        views.layer.add(transition!, forKey: nil)
    }
    
    static func viewSlideInFromTop(toBottom views: UIView) {
        var transition: CATransition? = nil
        transition = CATransition.init()
        transition?.duration = kSlideAnimationDuration
        transition?.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition?.type = CATransitionType.push
        transition?.subtype = CATransitionSubtype.fromBottom
        //        transition?.delegate = (self as! CAAnimationDelegate)
        views.layer.add(transition!, forKey: nil)
    }
    
    static func viewSlideInFromBottom(toTop views: UIView) {
        var transition: CATransition? = nil
        transition = CATransition.init()
        transition?.duration = kSlideAnimationDuration
        transition?.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition?.type = CATransitionType.push
        transition?.subtype = CATransitionSubtype.fromTop
        //        transition?.delegate = (self as! CAAnimationDelegate)
        views.layer.add(transition!, forKey: nil)
    }
    
   
}
        
