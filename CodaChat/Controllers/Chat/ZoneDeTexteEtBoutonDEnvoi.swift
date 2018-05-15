//
//  ZoneDeTexteEtBoutonDEnvoi.swift
//  CodaChat
//
//  Created by Adrien Lefaure on 09/05/2018.
//  Copyright © 2018 Adrien Lefaure. All rights reserved.
//

import UIKit

extension ChatController: UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if let texte = textView.text {
            changerTailleDeZoneDeSaisie(string: texte)
        } else {
            changerTailleDeZoneDeSaisie(string: "")
        }
        
        if !enTrainDEcrire {
            Donnees().ecrit(from: monId, to: partenaire.id)
            enTrainDEcrire = true
        } else {
            timer.invalidate()
        }
        timerEcriture()
    }
    
    func timerEcriture() {
        timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: { (t) in
            Donnees().ecrit(from: self.monId, to: "")
            self.enTrainDEcrire = false
        })
    }
    
    func changerTailleDeZoneDeSaisie(string: String) {
        if string != "", zoneDeTexteGaucheContrainte.constant == 90 {
            miseAJourContrainte(contrainte: zoneDeTexteGaucheContrainte, constante: 8)
            cacherBouton(true)
        }
        
        if string.isEmpty, zoneDeTexteGaucheContrainte.constant != 90 {
            miseAJourContrainte(contrainte: zoneDeTexteGaucheContrainte, constante: 90)
            cacherBouton(false)
        }
        
        let hauteur = string.hauteur(largeur: zoneDeText.frame.width, font: UIFont.systemFont(ofSize: 17))
        if hauteur + 16 > 50 {
            miseAJourContrainte(contrainte: zoneDeSaisieHauteurContrainte, constante: hauteur + 16)
            miseAJourContrainte(contrainte: zoneDeTexteHauteurContrainte, constante: hauteur)
        } else {
            miseAJourContrainte(contrainte: zoneDeSaisieHauteurContrainte, constante: 50)
            miseAJourContrainte(contrainte: zoneDeTexteHauteurContrainte, constante: 34)
        }
    }
    
    func cacherBouton(_ boolean: Bool) {
        appareilBouton.isHidden = boolean
        gallerieBouton.isHidden = boolean
    }
    
    func miseAJourContrainte(contrainte: NSLayoutConstraint, constante: CGFloat) {
        UIView.animate(withDuration: 0.35) {
            contrainte.constant = constante
        }
    }
    
    func envoyerSurFirebase(dict: Dictionary<String, AnyObject>) {
        let date: Double = Date().timeIntervalSince1970
        var valeurs = dict
        valeurs["from"] = monId as AnyObject
        valeurs["to"] = partenaire.id as AnyObject
        valeurs["date"] = date as AnyObject
        Donnees().envoyerMessage(from: monId, to: partenaire.id, valeurs: valeurs)
    }
    
    @IBAction func okBoutonAction(_ sender: Any) {
        if let texte = zoneDeText.text, !texte.isEmpty {
            zoneDeText.text = ""
            envoyerSurFirebase(dict: ["texte": texte as AnyObject])
        }
    }
    @IBAction func gallerieBoutonAction(_ sender: Any) {
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    @IBAction func appareilBoutonAction(_ sender: Any) {
        picker.sourceType = .camera
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image: UIImage?
        if let original = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = original
        } else if let edited = info[UIImagePickerControllerEditedImage] as? UIImage {
            image = edited
        }
        picker.dismiss(animated: true, completion: nil)
        view.creerActivity()
        Stockage().sauvegarderImageMessage(image: image, id: monId) { (string, any) -> (Void) in
            self.view.supprimmerActivity()
            if let erreur = string {
                
            }
            if let dict = any as? Dictionary<String, AnyObject> {
                self.envoyerSurFirebase(dict: dict)
            }
        }
    }
}
