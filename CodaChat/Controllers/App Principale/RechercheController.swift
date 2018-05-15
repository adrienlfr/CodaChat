//
//  RechercheController.swift
//  CodaChat
//
//  Created by Adrien Lefaure on 07/05/2018.
//  Copyright © 2018 Adrien Lefaure. All rights reserved.
//

import UIKit

class RechercheController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var monId: String!
    var utilisateurs = [Utilisateur]()
    var utilisateursFiltres = [Utilisateur]()
    let cellId = "UtilisateurCell"
    var enRecherche = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recherche"
        search.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "UtilisateurCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        observer()
    }
    
    func observer() {
        Donnees().obtenirTous(id: monId) { (utilisateur) -> (Void) in
            if let user = utilisateur {
                self.utilisateurs.append(user)
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if enRecherche {
            return utilisateursFiltres.count
        }
        return utilisateurs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! UtilisateurCell
        if enRecherche {
            cell.configuration(utilisateursFiltres[indexPath.row], controller: self)
        } else {
            cell.configuration(utilisateurs[indexPath.row], controller: self)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UtilisateurCell
        let controller = ChatController()
        if enRecherche {
            controller.miseEnPlace(id: monId, utilisateur: utilisateursFiltres[indexPath.row], image: cell.photo.image)
        } else {
            controller.miseEnPlace(id: monId, utilisateur: utilisateurs[indexPath.row], image: cell.photo.image)
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            enRecherche = false
            view.endEditing(true)
        } else {
            enRecherche = true
            let minuscule = searchBar.text!.lowercased()
            utilisateursFiltres = utilisateurs.filter {
                return $0.nom.lowercased().range(of: minuscule) != nil || $0.prenom.lowercased().range(of: minuscule) != nil
            }
        }
        tableView.reloadData()
    }
}
