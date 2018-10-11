//
//  AlertViewController.swift
//  IkmanAssignment
//
//  Created by Hanushka Suren on 7/1/18.
//  Copyright © 2018 Hanushka Suren. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    
    @IBOutlet weak var headerLabelCenterYConstraint: NSLayoutConstraint!
    
    var headerText: String?
    var descriptionText: String?
    var okButtonAction: ((Bool) -> Void)?
    var hasBlurEffect = true
    var effect: UIVisualEffect!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !self.hasBlurEffect{
            self.visualEffectView.isHidden = true
        }
        
        self.headerLabel.text = headerText
        self.descriptionTextView.text = descriptionText
        self.descriptionTextView.sizeToFit()
    
        self.containerView.alpha = 0.0
        //self.view.alpha = 0.0
        
        self.effect = self.visualEffectView.effect
        self.visualEffectView.effect = nil
    }
    
    override func viewDidLayoutSubviews() {
        let maskLayer: CAShapeLayer? = CAShapeLayer()
        let maskPath: UIBezierPath? = UIBezierPath(roundedRect: self.containerView.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 20, height: 20))
        
        maskLayer!.frame = self.containerView.bounds
        maskLayer!.path  = maskPath!.cgPath
        
        self.containerView.layer.mask = maskLayer
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.containerView.transform = CGAffineTransform(translationX: 0, y: CommonAttributes.SCREEN_HEIGHT * 1.5)
        self.view.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.visualEffectView.effect = self.effect
            self.containerView.alpha = 1.0
            self.containerView.transform = CGAffineTransform.identity
            self.view.alpha = 1.0
        }
    }
    
    @IBAction func DismissBtnTap(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: -CommonAttributes.SCREEN_HEIGHT * 1.5)
            self.containerView.alpha = 0
            self.visualEffectView.effect = nil
            self.view.alpha = 0
        }) { (success:Bool) in
            if self.okButtonAction != nil{
                self.okButtonAction!(true)
            }
            self.view.removeFromSuperview()
        }
    }
}
