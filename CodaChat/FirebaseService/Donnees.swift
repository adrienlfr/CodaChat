//
//  Donnees.swift
//  CodaChat
//
//  Created by Adrien Lefaure on 09/05/2018.
//  Copyright © 2018 Adrien Lefaure. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class Donnees {
    
    func obtenirUtilisateurSpecifique(id: String, completion: UtilisateurCompletion?) {
        let ref = Ref().databaseUtilisateurSpecifique(id: id)
        ref.observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, AnyObject> {
                let utilisateur = self.convertirDictEnUser(cle: snapshot.key, dict: dict)
                completion?(utilisateur)
            } else {
                completion?(nil)
            }
        })
    }
    
    func obtenirTous(id: String, completion: UtilisateurCompletion?) {
        let ref = Ref().databaseUtilisateurs
        ref.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, AnyObject>, snapshot.key != id {
                let utilisateur = self.convertirDictEnUser(cle: snapshot.key, dict: dict)
                completion?(utilisateur)
            } else {
                completion?(nil)
            }
        }
    }
    
    func obtenirChangementUtilisateur(id: String, completion: ChangementCompletion?) {
        let ref = Ref().databaseUtilisateurSpecifique(id: id)
        ref.observe(.childChanged) { (snapshot) in
            if let valeur = snapshot.value as? String {
                completion?(snapshot.key, valeur)
            } else {
                completion?(nil, nil)
            }
        }
    }
    
    func convertirDictEnUser(cle: String, dict: Dictionary<String, AnyObject>) -> Utilisateur? {
        guard let prenom = dict["prenom"] as? String else { return nil }
        guard let nom = dict["nom"] as? String else { return nil }
        guard let accueil = dict["accueil"] as? String else { return nil }
        let mail = dict["mail"] as? String
        let imageUrl = dict["profilUrl"] as? String
        return Utilisateur(id: cle, prenom: prenom, nom: nom, mail: mail, imageUrl: imageUrl, accueil: accueil)
    }
    
    func convertirDictEnMessage(cle: String, dict: Dictionary<String, AnyObject>) -> Message? {
        guard let from = dict["from"] as? String else { return nil }
        guard let to = dict["to"] as? String else { return nil }
        guard let date = dict["date"] as? Double else { return nil }
        let texte = dict["texte"] as? String
        let imageUrl = dict["imageUrl"] as? String
        let hauteur = dict["hauteur"] as? Double
        let largeur = dict["largeur"] as? Double
        let message = Message(id: cle, from: from, to: to, date: date, texte: texte, imageUrl: imageUrl, hauteur: hauteur, largeur: largeur)
        return message
    }
    
    func envoyerMessage(from: String, to: String, valeurs: Dictionary<String, AnyObject>) {
        let ref = Ref().databaseMessageEnvoi(from: from, to: to)
        ref.childByAutoId().updateChildValues(valeurs)
        
        let refFrom = Ref().databaseAmisSpécifique(from: from, to: to)
        refFrom.updateChildValues(valeurs)
        
        let refTo = Ref().databaseAmisSpécifique(from: to, to: from)
        refTo.updateChildValues(valeurs)
    }
    
    func recevoirMessage(from: String, to: String, completion: MessageCompletion?) {
        let ref = Ref().databaseMessageEnvoi(from: from, to: to)
        ref.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, AnyObject> {
                completion?(self.convertirDictEnMessage(cle: snapshot.key, dict: dict))
            }
        }
    }
    
    func dernierMessages(id: String, completion: DernierMessageCompletion?) {
        let ref = Ref().databaseMesAmis(id: id)
        ref.observe(.childAdded) { (snapshot) in
            guard let dict = snapshot.value as? Dictionary<String, AnyObject> else { return }
            guard let date = dict["date"] as? Double else { return }
            let texte = dict["texte"] as? String
            self.obtenirUtilisateurSpecifique(id: snapshot.key, completion: { (user) -> (Void) in
                if let utilisateur = user {
                    completion?(DernierMessage(date: date, texte: texte, utilisateur: utilisateur))
                } else {
                    completion?(nil)
                }
            })
        }
    }
    
    func obtenirChangementDeMessage(from: String, to: String, completion: ChangementMessageCompletion?) {
        let ref = Ref().databaseAmisSpécifique(from: from, to: to)
        ref.observe(.childChanged) { (snapshot) in
            if let valeur = snapshot.value as? AnyObject {
                completion?(snapshot.key, valeur)
            }
        }
    }
    
    func statut(bool: Bool) {
        if let id = Auth.auth().currentUser?.uid {
            let ref = Ref().databaseStatut(id: id)
            let dict: Dictionary<String, AnyObject> = [
                "online": bool as AnyObject,
                "dernier": Date().timeIntervalSince1970 as AnyObject
            ]
            ref.updateChildValues(dict)
        }
    }
    
    func ecrit(from: String, to: String) {
        let ref = Ref().databaseStatut(id: from)
        let dict: Dictionary<String, AnyObject> = [
            "ecrit": to as AnyObject
        ]
        ref.updateChildValues(dict)
    }
    
}
