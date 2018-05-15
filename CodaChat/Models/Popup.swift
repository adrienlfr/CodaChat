//
//  Popup.swift
//  CodaChat
//
//  Created by Adrien Lefaure on 07/05/2018.
//  Copyright © 2018 Adrien Lefaure. All rights reserved.
//

import UIKit

class Popup {
    
    static let montrer = Popup()
    
    func camera(controller: UIViewController, picker: UIImagePickerController) {
        let popup = UIAlertController(title: "Que voulez-vous utiliser?", message: nil, preferredStyle: .alert)
        let photo = UIAlertAction(title: "Appareil photo", style: .default) { (action) in
            picker.sourceType = .camera
            controller.present(picker, animated: true, completion: nil)
        }
        let gallerie = UIAlertAction(title: "Gallerie de photos", style: .default) { (action) in
            picker.sourceType = .photoLibrary
            controller.present(picker, animated: true, completion: nil)
        }
        let annuler = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        popup.addAction(photo)
        popup.addAction(gallerie)
        popup.addAction(annuler)
        controller.present(popup, animated: true, completion: nil)
    }
    
    func messageSimple(_ controller: UIViewController, message: String) {
        let popup = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        popup.addAction(ok)
        controller.present(popup, animated: true, completion: nil)
    }
    
}
