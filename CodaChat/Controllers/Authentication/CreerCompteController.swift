//
//  CreerCompteController.swift
//  CodaChat
//
//  Created by Adrien Lefaure on 07/05/2018.
//  Copyright © 2018 Adrien Lefaure. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreerCompteController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var prenomTextField: UITextField!
    @IBOutlet weak var nomTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var motDePasseTextField: UITextField!
    @IBOutlet weak var confirmerTextField: UITextField!
    
    var picker = UIImagePickerController()
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        miseEnPlaceDuClavier()
        picker.delegate = self
        picker.allowsEditing = true
        photo.isUserInteractionEnabled = true
        photo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(demanderPhoto)))
        prenomTextField.delegate = self
        nomTextField.delegate = self
        mailTextField.delegate = self
        motDePasseTextField.delegate = self
        confirmerTextField.delegate = self
    }
    
    @objc func demanderPhoto() {
        Popup.montrer.camera(controller: self, picker: picker)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageChangee = info[UIImagePickerControllerEditedImage] as? UIImage {
            image = imageChangee
            photo.image = imageChangee
        }
        if let imageOriginale = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = imageOriginale
            photo.image = imageOriginale
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func uneErreur(msg: String) {
        view.supprimmerActivity()
        Popup.montrer.messageSimple(self, message: msg)
    }
    
    func enregistrer() {
        guard let prenom = prenomTextField.text, prenom != "" else {
            uneErreur(msg: "Prénom vide")
            return
        }
        guard let nom = nomTextField.text, nom != "" else {
            uneErreur(msg: "Nom vide")
            return
        }
        guard let mail = mailTextField.text, mail != "" else {
            uneErreur(msg: "Mail vide")
            return
        }
        guard let motDePasse = motDePasseTextField.text, motDePasse != "" else {
            uneErreur(msg: "Mot de passe vide")
            return
        }
        guard let confirmer = confirmerTextField.text, confirmer != "" else {
            uneErreur(msg: "Confirmation vide")
            return
        }
        guard motDePasse == confirmer else {
            uneErreur(msg: "Les mots de passes doivent être identiques")
            return
        }
        
        // Auth
        
        Auth.auth().createUser(withEmail: mail, password: motDePasse) { (user, erreur) in
            if let err = erreur {
                self.uneErreur(msg: err.convertirErreurFirbaseEnString())
            } else {
                if let id = user?.uid {
                    let dict: Dictionary<String, AnyObject> = [
                        "prenom": prenom as AnyObject,
                        "nom": nom as AnyObject,
                        "mail": mail as AnyObject,
                        "accueil": "C'est pas faux" as AnyObject
                    ]
                    let ref = Ref().databaseUtilisateurSpecifique(id: id)
                    ref.updateChildValues(dict, withCompletionBlock: { (error, reference) in
                        if let erreur = error {
                            self.uneErreur(msg: erreur.convertirErreurFirbaseEnString())
                        } else {
                            Stockage().sauvegarderProfile(image: self.image, id: id)
                            let tab = MTab()
                            tab.setup(id: id)
                            self.view.supprimmerActivity()
                            Donnees().statut(bool: true)
                            self.present(tab, animated: true, completion: nil)
                        }
                    })
                } else {
                    self.uneErreur(msg: "Veuiller réessayer plus tard")
                }
            }
        }
    }
    
    @IBAction func okButtonAction(_ sender: Any) {
        view.creerActivity()
        view.endEditing(true)
        Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { (time) in
            self.enregistrer()
        }
    }
    
    @IBAction func retourAction(_ sender: Any) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
