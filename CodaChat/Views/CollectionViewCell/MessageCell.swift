//
//  MessageCell.swift
//  CodaChat
//
//  Created by Adrien Lefaure on 09/05/2018.
//  Copyright © 2018 Adrien Lefaure. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {

    @IBOutlet weak var imageProfile: ImageArrondie!
    @IBOutlet weak var bulle: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var texteLabel: UILabel!
    @IBOutlet weak var imageEnvoyer: UIImageView!
    
    @IBOutlet var largeurBulleContrainte: NSLayoutConstraint!
    @IBOutlet var bulleGaucheContrainte: NSLayoutConstraint!
    @IBOutlet var bulleDroiteContrainte: NSLayoutConstraint!
    
    var message: Message!
    var monId : String!
    var controller: ChatController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configurer(id: String, message: Message, image: UIImage?, controller: ChatController) {
        self.monId = id
        self.message = message
        self.controller = controller
        
        imageProfile.image = #imageLiteral(resourceName: "photo_profil")
        imageProfile.isHidden = false
        imageEnvoyer.isHidden = true
        imageEnvoyer.isUserInteractionEnabled = true
        imageEnvoyer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoom)))
        imageEnvoyer.layer.cornerRadius = BULLE_RADIUS
        imageEnvoyer.clipsToBounds = true
        imageEnvoyer.contentMode = .scaleAspectFill
        texteLabel.isHidden = true
        bulleGaucheContrainte.isActive = true
        bulleDroiteContrainte.isActive = true
        largeurBulleContrainte.constant = 200
        bulle.layer.cornerRadius = BULLE_RADIUS
        
        if self.monId == self.message.from {
            imageProfile.isHidden = true
            bulleGaucheContrainte.isActive = false
            bulle.backgroundColor = BULLE_BLEUE
        } else {
            bulleDroiteContrainte.isActive = false
            bulle.backgroundColor = BULLE_VERTE
            imageProfile.image = image
        }
        
        if let texte = self.message.texte, !texte.isEmpty {
            texteLabel.isHidden = false
            texteLabel.text = texte
            let largeurDeTexte = texte.largeur(largeur: UIScreen.main.bounds.width, font: UIFont.systemFont(ofSize: 17)) + 32
            if largeurDeTexte < 75 {
                largeurBulleContrainte.constant = 75
            } else {
                largeurBulleContrainte.constant = largeurDeTexte
            }
        } else if let image = self.message.imageUrl {
            imageEnvoyer.isHidden = false
            imageEnvoyer.telecharger(image)
            largeurBulleContrainte.constant = 250
        }
        
        dateLabel.text = message.date.dateLisiblePourMessage()
    }
    
    @objc func zoom() {
        controller?.zoomIn(imageView: imageEnvoyer)
    }
    
}
