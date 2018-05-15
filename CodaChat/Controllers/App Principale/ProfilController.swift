//
//  ProfilController.swift
//  CodaChat
//
//  Created by Adrien Lefaure on 07/05/2018.
//  Copyright © 2018 Adrien Lefaure. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfilController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var prenomTextField: UITextField!
    @IBOutlet weak var nomTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    
    var monId: String!
    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profil"
        
        picker.delegate = self
        picker.allowsEditing = true
        
        photo.isUserInteractionEnabled = true
        photo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(camera)))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rangerClavier)))
        
        Donnees().obtenirUtilisateurSpecifique(id: monId) { (utilisateur) -> (Void) in
            if let user = utilisateur {
                self.prenomTextField.text = user.prenom
                self.nomTextField.text = user.nom
                self.messageTextField.text = user.accueil
                self.photo.telecharger(user.imageUrl)
            }
        }
    }
    
    @objc func camera() {
        Popup.montrer.camera(controller: self, picker: picker)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image: UIImage?
        if let original = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = original
        } else if let modifier = info[UIImagePickerControllerEditedImage] as? UIImage {
            image = modifier
        }
        picker.dismiss(animated: true, completion: nil)
        if let img = image {
            self.photo.image = img
            Stockage().sauvegarderProfile(image: img, id: monId)
        }
    }
    
    @IBAction func sauvegarder(_ sender: Any) {
        var dict = Dictionary<String, AnyObject>()
        if let prenom = prenomTextField.text, prenom != "" {
            dict["prenom"] = prenom as AnyObject
        }
        if let nom = nomTextField.text, nom != "" {
            dict["nom"] = nom as AnyObject
        }
        if let accueil = messageTextField.text, accueil != "" {
            dict["accueil"] = accueil as AnyObject
        }
        let ref = Ref().databaseUtilisateurSpecifique(id: monId)
        ref.updateChildValues(dict)
    }
    
    @IBAction func seDeconnecter(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            Popup.montrer.messageSimple(self, message: "Une erreur est apparue")
            return
        }
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
}
