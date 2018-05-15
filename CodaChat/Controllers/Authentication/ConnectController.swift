//
//  ConnectController.swift
//  CodaChat
//
//  Created by Adrien Lefaure on 07/05/2018.
//  Copyright © 2018 Adrien Lefaure. All rights reserved.
//

import UIKit
import FirebaseAuth

class ConnectController: UIViewController {

    @IBOutlet weak var container: VueArrondieAvecOmbre!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var motDePasseTextField: UITextField!
    @IBOutlet weak var okButton: BoutonArrondieAvecOmbre!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        miseEnPlaceDuClavier()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        container.alpha = 0
        okButton.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let id = Auth.auth().currentUser?.uid {
            envoyerVersApp(id: id)
        } else {
            container.alpha = 1
            okButton.alpha = 1
        }
    }
    
    func uneErreur(msg: String) {
        view.supprimmerActivity()
        Popup.montrer.messageSimple(self, message: msg)
    }
    
    func identification() {
        guard let mail = mailTextField.text, mail != "" else {
            uneErreur(msg: "Veuillez entrer une adresse mail")
            return
        }
        guard let motDePasse = motDePasseTextField.text, motDePasse != "" else {
            uneErreur(msg: "Veuillez entrer un mot de passe")
            return
        }
        Auth.auth().signIn(withEmail: mail, password: motDePasse) { (user, error) in
            if let erreur = error {
                self.uneErreur(msg: erreur.convertirErreurFirbaseEnString())
            } else if let id = user?.uid {
                self.view.supprimmerActivity()
                self.envoyerVersApp(id: id)
            } else {
                self.uneErreur(msg: "Veuillez réessayer plus tard")
            }
        }
    }
    
    @IBAction func okButtonAction(_ sender: Any) {
        view.endEditing(true)
        view.creerActivity()
        self.identification()
    }
    
    func envoyerVersApp(id: String) {
        let tab = MTab()
        tab.setup(id: id)
        Donnees().statut(bool: true)
        self.present(tab, animated: true, completion: nil)
    }
    
    @IBAction func creerCompteAction(_ sender: Any) {
        self.present(CreerCompteController(), animated: true, completion: nil)
    }
}
