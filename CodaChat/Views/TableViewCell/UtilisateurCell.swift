//
//  UtilisateurCell.swift
//  CodaChat
//
//  Created by Adrien Lefaure on 09/05/2018.
//  Copyright © 2018 Adrien Lefaure. All rights reserved.
//

import UIKit

class UtilisateurCell: UITableViewCell {

    @IBOutlet weak var photo: ImageArrondie!
    @IBOutlet weak var nomLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var utilisateur : Utilisateur!
    var controller : RechercheController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configuration(_ utilisateur: Utilisateur, controller : RechercheController) {
        self.utilisateur = utilisateur
        self.controller = controller
        self.photo.telecharger(self.utilisateur.imageUrl)
        self.nomLabel.text = self.utilisateur.prenom + " " + self.utilisateur.nom
        self.messageLabel.text = self.utilisateur.accueil
        Donnees().obtenirChangementUtilisateur(id: self.utilisateur.id) { (key, value) -> (Void) in
            if let cle = key, let valeur = value {
                self.utilisateur.miseAJour(cle: cle, valeur: valeur)
                controller.tableView.reloadData()
            }
        }
    }
    
}
