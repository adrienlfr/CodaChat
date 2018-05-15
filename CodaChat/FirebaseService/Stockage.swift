//
//  Stockage.swift
//  CodaChat
//
//  Created by Adrien Lefaure on 07/05/2018.
//  Copyright © 2018 Adrien Lefaure. All rights reserved.
//

import UIKit
import FirebaseStorage

class Stockage {
    
    func sauvegarderProfile(image: UIImage?, id: String) {
        guard let monImage = image else { return }
        guard let imageTransformee = UIImageJPEGRepresentation(monImage, 0.1) else { return }
        let ref = Ref().stockageProfilSpecifique(id: id)
        ref.putData(imageTransformee, metadata: nil) { (meta, error) in
            if let erreur = error {
                print(erreur.localizedDescription)
            } else if let metaImageUrl = meta?.downloadURL()?.absoluteString {
                let ref = Ref().databaseUtilisateurSpecifique(id: id)
                ref.updateChildValues(["profilUrl": metaImageUrl])
            }
        }
    }
    
    func sauvegarderImageMessage(image: UIImage?, id: String, completion: ChangementMessageCompletion?) {
        if let monImage = image {
            let ref = Ref().stockageImageMessage(id: id)
            if let data = UIImageJPEGRepresentation(monImage, 0.25) {
                ref.child(UUID().uuidString).putData(data, metadata: nil) { (meta, error) in
                    if error != nil {
                        completion?("Erreur", nil)
                    } else if let url = meta?.downloadURL()?.absoluteString {
                        let dict: Dictionary<String, AnyObject> = [
                            "imageUrl": url as AnyObject,
                            "hauteur": monImage.size.height as AnyObject,
                            "largeur": monImage.size.width as AnyObject,
                            "texte": "" as AnyObject
                        ]
                        completion?(nil, dict as AnyObject)
                    } else {
                        completion?("Erreur", nil)
                    }
                }
            }
        } else {
            completion?("Erreur", nil)
        }
    }
}
