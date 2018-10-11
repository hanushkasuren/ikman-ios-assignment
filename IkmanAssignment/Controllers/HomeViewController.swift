//
//  HomeViewController.swift
//  IkmanAssignment
//
//  Created by Hanushka Suren on 10/11/18.
//  Copyright © 2018 Hanushka Suren. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class HomeViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating{
    
    @IBOutlet weak var itemsTableView: UITableView!
    
    var items = [Item]()
    var filteredItems = [Item]()
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        
        //get items
        self.getItems()
        
        //search controller
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        //self.itemsTableView.tableHeaderView = searchController.searchBar
    }
    
    //MARK: - Delegate & DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive && self.searchController.searchBar.text != ""{
            return filteredItems.count
        }
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // to remove selection color of the row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ItemsTableViewCell
        
        var item = Item()
        
        if self.searchController.isActive && self.searchController.searchBar.text != ""{
            item = self.filteredItems[indexPath.row]
        }else{
            item = self.items[indexPath.row]
        }
        
        var thumbnail = UIImage(named: "defualtThumbnail")
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            //set image thumbnail in background thread/queue
            if let imageURLString = item.imageURL, let imageURL = URL(string: imageURLString), let imageData = NSData(contentsOf: imageURL){
                let originalImage = UIImage(data: imageData as Data, scale: 0.1)
                
                let cellImageViewWidth: CGFloat = 70 * 0.8
                let cellIMageViewHeight = cellImageViewWidth
                
                let originalImageWidth = originalImage?.size.width
                let originalImageHeight = originalImage?.size.height
                let isImageLandscape = originalImageWidth! > originalImageHeight!
                var thumbnailSize:CGSize?
                
                if isImageLandscape{
                    
                    let originalImageWidthHeightRatio = originalImageWidth! / originalImageHeight!
                    let thumbnailWidth = originalImageWidthHeightRatio * cellIMageViewHeight
                    thumbnailSize = CGSize(width: thumbnailWidth, height: cellIMageViewHeight)
                    
                }else{
                    
                    let originalImageHeightWidthRatio = originalImageHeight! / originalImageWidth!
                    let thumbnailHeight = originalImageHeightWidthRatio * cellImageViewWidth
                    thumbnailSize = CGSize(width: cellImageViewWidth, height: thumbnailHeight)
                }
                
                thumbnail = originalImage?.scaleTosize(thumbnailSize!)
                
            }else{
                thumbnail = UIImage(named: "defualtThumbnail")
            }
            
            
            DispatchQueue.main.async{
                //cell?.imageView?.image = thumbnail
            }
            
        }
        
        cell?.titleLabel.text = item.title
        cell?.descriptionLabel.text = item.title
        
        return cell!
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchText = searchController.searchBar.text!
        
        self.filteredItems = self.items.filter { item in
            return (item.title?.lowercased().contains(searchText.lowercased()))!
        }
        self.itemsTableView.reloadData()
    }
    
    //MARK: - Developer Methods
    
    func getItems(){
        
        // Checking if internet connection is there
        guard CommonMethods.isConnectedToInternet() else{
            CommonMethods.alert(title: "Unable to Retrieve data", description: "Check your connection and try again.")
            return
        }
        
        CommonMethods.showProgress(view: self.view, description: "") // Showing progress
        
        // Retrieving items from the server
        Alamofire.request(CommonAttributes.JSON_URL).responseJSON { response in
            
            if response.error != nil { // Checking for server errors
                print(response.error!)
                CommonMethods.alert(title: "Error Occured!", description: "Error occurred while retrieving data from the server")
                CommonMethods.hideProgress(view: self.view) // Hidding progress
                return
            }else{
                
                do{
                    if let dictionaryArray = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [[String: Any]]{ // Converting json data into a dictionary
                        
                        for item in dictionaryArray{
                            
                            let imageURL = item["image"] as? String
                            let title = item["title"] as? String
                            let description = item["description"] as? String
                            
                            self.items.append(Item(imageURL: imageURL, title: title, description: description))
                        }
                    }
                    
                }catch let error  { // Error while converting json data
                    print(error.localizedDescription)
                    CommonMethods.alert(title: "Error Occured!", description: "Error occurred while reading data")
                    CommonMethods.hideProgress(view: self.view) // Hidding progress
                    return
                }
            }
            
            self.itemsTableView.reloadData() // Reloading data in the table view
            CommonMethods.hideProgress(view: self.view) // Hidding progress
        }
    }
}
