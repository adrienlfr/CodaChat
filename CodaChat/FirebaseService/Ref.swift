//
//  Ref.swift
//  CodaChat
//
//  Created by Adrien Lefaure on 07/05/2018.
//  Copyright © 2018 Adrien Lefaure. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class Ref {
    
    // DATABASE
    let databaseBase = Database.database().reference()
    
    var databaseUtilisateurs: DatabaseReference {
        return databaseBase.child("utilisateurs")
    }
    
    func databaseUtilisateurSpecifique(id: String) -> DatabaseReference {
        return databaseUtilisateurs.child(id)
    }
    
    func databaseStatut(id: String) -> DatabaseReference {
        return databaseUtilisateurs.child(id).child("statut")
    }
    
    var databaseMessage: DatabaseReference {
        return databaseBase.child("messages")
    }
    
    func databaseMessageEnvoi(from: String, to: String) -> DatabaseReference {
        return databaseMessage.child(from).child(to)
    }
    
    var databaseAmis: DatabaseReference {
        return databaseBase.child("amis")
    }
    
    func databaseMesAmis(id: String) -> DatabaseReference {
        return databaseAmis.child(id)
    }
    
    func databaseAmisSpécifique(from: String, to: String) -> DatabaseReference {
        return databaseAmis.child(from).child(to)
    }
    
    // STOCKAGE
    let stockageBase = Storage.storage().reference()
    
    var stockageProfil: StorageReference {
        return stockageBase.child("profil")
    }
    
    func stockageProfilSpecifique(id: String) -> StorageReference {
        return stockageProfil.child(id)
    }
    
    var stockageMessage: StorageReference {
        return stockageBase.child("message")
    }
    
    func stockageImageMessage(id: String) -> StorageReference {
        return stockageMessage.child(id)
    }
    
}
