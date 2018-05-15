//
//  ExtensionUIViewController.swift
//  CodaChat
//
//  Created by Adrien Lefaure on 07/05/2018.
//  Copyright © 2018 Adrien Lefaure. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func miseEnPlaceDuClavier() {
        NotificationCenter.default.addObserver(self, selector: #selector(clavierSorti), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clavierRentre), name: Notification.Name.UIKeyboardWillHide, object: nil)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rangerClavier)))
    }
    
    @objc func clavierSorti(notification: Notification) {
        if let rectDeMonClavier = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, view.frame.minY == 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.view.frame.origin.y -= rectDeMonClavier.height
            })
        }
    }
    
    @objc func clavierRentre(notification: Notification) {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            })
    }
    
    @objc func rangerClavier() {
        view.endEditing(true)
    }
    
}
