//
//  Utilisateur.swift
//  CodaChat
//
//  Created by Adrien Lefaure on 09/05/2018.
//  Copyright © 2018 Adrien Lefaure. All rights reserved.
//

import UIKit

class Utilisateur {
    
    private var _id: String!
    private var _prenom: String!
    private var _nom: String!
    private var _mail: String?
    private var _imageUrl: String?
    private var _accueil: String!
    
    var id: String {
        return _id
    }
    var prenom: String {
        return _prenom
    }
    var nom: String {
        return _nom
    }
    var mail: String? {
        return _mail
    }
    var imageUrl: String? {
        return _imageUrl
    }
    var accueil: String {
        return _accueil
    }
    
    init(id: String, prenom: String, nom: String, mail: String?, imageUrl: String?, accueil: String){
        self._id = id
        self._prenom = prenom
        self._nom = nom
        self._mail = mail
        self._imageUrl = imageUrl
        self._accueil = accueil
    }
    
    func miseAJour(cle: String, valeur: String) {
        switch cle {
            case "prenom": self._prenom = valeur
            case "nom": self._nom = valeur
            case "accueil": self._accueil = valeur
            case "profilUrl": self._imageUrl = valeur
            default: break
        }
    }
    
}
