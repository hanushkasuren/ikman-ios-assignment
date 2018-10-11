//
//  CommonMethods.swift
//  IkmanAssignment
//
//  Created by Hanushka Suren on 10/11/18.
//  Copyright © 2018 Hanushka Suren. All rights reserved.
//

import Foundation
import Alamofire
import MBProgressHUD
import CoreData

struct CommonMethods {
    
    // MARK: - ProgressHUD
    private static func createHUD(view: UIView, description: String?) -> MBProgressHUD{
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.bezelView.style = .solidColor
        hud.bezelView.color = UIColor(netHex: 0x343434, alpha: 0.8)
        hud.contentColor = UIColor.white
        
        if description != nil{
            hud.label.text = description
            hud.label.frame.origin.y = 30
        }
        
        return hud
    }
    
    static func showProgress(view: UIView, description: String? = nil){
        
        let hud = self.createHUD(view: view, description: description)
        hud.show(animated: true)
    }
    
    static func hideProgress(view: UIView){
        
        MBProgressHUD.hide(for: view, animated: true)
        
    }
    
    // MARK: - Internet
    static func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    // MARK: - Core Data
    
    static func getManagedContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Dialog Boxes
    static var alertViewController: AlertViewController?
    
    static func alert(title: String, description: String, hasBlurEffect: Bool = false, okButtonAction: ((Bool) -> Void)? = nil){
        
        let window: UIView? = UIApplication.shared.keyWindow
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        self.alertViewController = storyboard.instantiateViewController(withIdentifier: "alertViewController") as?  AlertViewController
        self.alertViewController?.headerText = title
        self.alertViewController?.descriptionText = description
        self.alertViewController?.okButtonAction = okButtonAction
        self.alertViewController?.hasBlurEffect = hasBlurEffect
        window?.addSubview(self.alertViewController!.view)
    }
}
