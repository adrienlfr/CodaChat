//
//  DerniersMessagesController.swift
//  CodaChat
//
//  Created by Adrien Lefaure on 07/05/2018.
//  Copyright © 2018 Adrien Lefaure. All rights reserved.
//

import UIKit

class DerniersMessagesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var monId: String!
    var derniersMessages = [DernierMessage]()
    let cellId = "DernierMessageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "DernierMessageCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        title = "Mes messages"
        
        observe()
    }
    
    func observe() {
        Donnees().dernierMessages(id: monId) { (dernier) -> (Void) in
            if let dernierMessage = dernier, !self.derniersMessages.contains(where: {$0.utilisateur.id == dernierMessage.utilisateur.id}) {
                self.derniersMessages.append(dernierMessage)
                self.reaorganiserEtMaj()
            }
        } 
    }
    
    func reaorganiserEtMaj() {
        derniersMessages = derniersMessages.sorted(by: {$0.date > $1.date})
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! DernierMessageCell
        cell.configuration(monId: monId, dernier: derniersMessages[indexPath.row], controller: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return derniersMessages.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DernierMessageCell
        let controller = ChatController()
        controller.miseEnPlace(id: monId, utilisateur: derniersMessages[indexPath.row].utilisateur, image: cell.photoDeProfil.image)
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
