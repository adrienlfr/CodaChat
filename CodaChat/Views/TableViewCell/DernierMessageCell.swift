//
//  DernierMessageCell.swift
//  CodaChat
//
//  Created by Adrien Lefaure on 14/05/2018.
//  Copyright © 2018 Adrien Lefaure. All rights reserved.
//

import UIKit

class DernierMessageCell: UITableViewCell {

    @IBOutlet weak var photoDeProfil: ImageArrondie!
    @IBOutlet weak var prenomLable: UILabel!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var messageLable: UILabel!
    
    var dernier: DernierMessage!
    var controller: DerniersMessagesController?
    var monId: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configuration(monId: String, dernier: DernierMessage, controller: DerniersMessagesController) {
        self.dernier = dernier
        self.controller = controller
        self.monId = monId
        photoDeProfil.telecharger(self.dernier.utilisateur.imageUrl)
        prenomLable.text = self.dernier.utilisateur.prenom
        dateLable.text = self.dernier.date.dateLisiblePourMessage()
        if let message = self.dernier.texte, !message.isEmpty {
            messageLable.text = message
        } else {
            messageLable.text = "Image envoyée"
        }
        Donnees().obtenirChangementDeMessage(from: monId, to: self.dernier.utilisateur.id) { (key, value) -> (Void) in
            if let cle = key, let valeur = value {
                self.dernier.miseAJour(cle: cle, valeur: valeur)
                controller.reaorganiserEtMaj()
            }
        }
    }
    
}
