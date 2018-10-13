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
import MBProgressHUD

class HomeViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating{
    
    @IBOutlet weak var itemsTableView: UITableView!
    
    var items: [NSManagedObject] = []
    var filteredItems: [NSManagedObject] = []
    let searchController = UISearchController(searchResultsController: nil)
    var managedContext = CommonMethods.getManagedContext()
    var selectedItem: NSManagedObject?
    //var currentProgressHUD: MBProgressHUD?
    
    //change status bar color to white
    override var preferredStatusBarStyle: UIStatusBarStyle { // this should ne there to make status bar light when searching is active
        return .lightContent
    }
    
    //MARK: - Override Methods
    
    override func viewDidLoad() {
        
        if self.loadItems().count == 0{
            //get items
            self.getItems()
        }else{
            self.items = loadItems()
        }
        
        self.managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        //search controller
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        self.searchController.searchBar.tintColor = UIColor.white
        self.searchController.searchBar.placeholder = "Search by Title"
        self.navigationItem.searchController = self.searchController
        
        self.itemsTableView.decelerationRate = .fast // reduce table view scrolling speed.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "homeViewToDetailsViewSegue"{ // pasing selected item to details view controller
            let detailsViewController = segue.destination as? DetailsViewController
            detailsViewController?.selectedItem = self.selectedItem
        }
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
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        self.selectedItem = self.items[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Items with description"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ItemsTableViewCell
        
        var item: NSManagedObject?
        
        if self.searchController.isActive && self.searchController.searchBar.text != ""{
            item = self.filteredItems[indexPath.row]
        }else{
            item = self.items[indexPath.row]
        }
        
        cell?.titleLabel.text = item?.value(forKey: "title") as? String
        cell?.descriptionLabel.text = item?.value(forKey: "desc") as? String
        
        if item?.value(forKey: "image_thumbnail_data") == nil{ //if thumbnail has not been set
            cell?.thumbnailImageView.image = UIImage(named: "defualtThumbnail")
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                if item?.value(forKey: "image_thumbnail_data") != nil{ // if thumbnail has been set
                    DispatchQueue.main.async {
                        cell?.thumbnailImageView.image = UIImage(data:item?.value(forKey: "image_thumbnail_data") as! Data)
                    }
                }else{
                    
                    DispatchQueue.main.async {
                        CommonMethods.hideProgress(view: self.view) // hide progress
                        CommonMethods.showProgress(view: self.view, description: "") // Showing progress
                    }
                    
                    if
                        let imageURLString = item?.value(forKey: "image_url") as? String,
                        let imageURL = URL(string: imageURLString),
                        let imageData = NSData(contentsOf: imageURL),
                        let originalImage = UIImage(data: imageData as Data)
                    {
                        
                        let thumbnail = CommonMethods.generateItemThumbnail(image: originalImage)
                        let thumbnailData = thumbnail.pngData()
                        
                        DispatchQueue.main.async {
                            item?.setValue(thumbnailData, forKey: "image_thumbnail_data") // this is inside main queue because all the same persistant storage stuff shoul be in one thread
                            if let item = item{
                                self.items[indexPath.row] = item //update item in array
                            }
                            cell?.thumbnailImageView.image = thumbnail
                            CommonMethods.hideProgress(view: self.view)
                        }
                    }
                }
            }
            
        }else{ // if thumbnail has been set alrady
            cell?.thumbnailImageView.image = UIImage(data: item?.value(forKey: "image_thumbnail_data") as! Data)
        }
        return cell!
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchText = searchController.searchBar.text!
        
        self.filteredItems = self.items.filter { item in
            return ((item.value(forKey: "title") as! String).lowercased().contains(searchText.lowercased()))
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
                        
                        for (index,item) in dictionaryArray .enumerated(){
                            
                            if
                                let imageURL = item["image"] as? String,
                                let title = item["title"] as? String,
                                let description = item["description"] as? String{
                                
                                let itemID = Int16(index)
                            
                                self.saveItem(id: itemID, title: title, description: description, imageURL: imageURL, imageThumbnailData: nil) // save item to coredata/persistent storage
                            }
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
    
    func saveItem(id: Int16, title: String, description: String, imageURL: String, imageThumbnailData: NSData?){
        
        // save core data
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: self.managedContext)!
        let item = NSManagedObject(entity: entity, insertInto: self.managedContext)
        
        item.setValue(id, forKey: "id")
        item.setValue(title, forKey: "title")
        item.setValue(description, forKey: "desc")
        item.setValue(imageURL, forKey: "image_url")
        item.setValue(imageThumbnailData, forKey: "image_thumbnail_data")

        do{
            try self.managedContext.save()
            self.items.append(item) // append item to items array
        }catch let error{
            print(error.localizedDescription)
        }
    }

    func loadItems() -> [NSManagedObject]{
     
        var items: [NSManagedObject] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        do{
            if let fetchResults = try self.managedContext.fetch(fetchRequest) as? [NSManagedObject]{
                items = fetchResults
            }
        }catch let error{
            print(error.localizedDescription)
        }
        
        return items
    }
}
