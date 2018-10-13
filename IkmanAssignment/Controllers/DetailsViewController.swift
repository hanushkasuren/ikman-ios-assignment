//
//  DetailsViewController.swift
//  IkmanAssignment
//
//  Created by Hanushka Suren on 10/12/18.
//  Copyright © 2018 Hanushka Suren. All rights reserved.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedItem: NSManagedObject?
    
    //change status bar color to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedItem = self.selectedItem{

            self.navigationItem.title = selectedItem.value(forKey: "title") as? String
            
                if
                    let urlString = selectedItem.value(forKey: "image_url") as? String,
                    let url = URL(string: urlString)
                {
                    
                    DispatchQueue.global(qos: .userInteractive).async { // priority is higher than userInitaited,background,utility queues
                        
                        if
                            let data = NSData(contentsOf: url),
                            let image = UIImage(data: data as Data)
                        {
                            
                            DispatchQueue.main.async {
                                self.imageView.image = image
                                self.activityIndicator.stopAnimating()
                            }
                        }
                    }
                }
            
            self.textView.text = selectedItem.value(forKey: "desc") as? String
        }
    }
}
