//
//  MTab.swift
//  CodaChat
//
//  Created by Adrien Lefaure on 07/05/2018.
//  Copyright © 2018 Adrien Lefaure. All rights reserved.
//

import UIKit

class MTab: UITabBarController {

    var id: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setup(id: String) {
        self.id = id
        
        let dernier = DerniersMessagesController()
        dernier.monId = id
        let dernierNav = UINavigationController(rootViewController: dernier)
        dernierNav.title = "Messages"
        dernierNav.tabBarItem.image = #imageLiteral(resourceName: "messages")
        
        let recherche = RechercheController()
        recherche.monId = id
        let rechercheNav = UINavigationController(rootViewController: recherche)
        rechercheNav.title = "Rechercher"
        rechercheNav.tabBarItem.image = #imageLiteral(resourceName: "recherche")
        
        let profil = ProfilController()
        profil.monId = id
        let profilNav = UINavigationController(rootViewController: profil)
        profilNav.title = "Profil"
        profilNav.tabBarItem.image = #imageLiteral(resourceName: "profil")
        
        viewControllers = [dernierNav, rechercheNav, profilNav]
        tabBar.clipsToBounds = true
    }
}
