//
//  ChatController.swift
//  CodaChat
//
//  Created by Adrien Lefaure on 09/05/2018.
//  Copyright © 2018 Adrien Lefaure. All rights reserved.
//

import UIKit

class ChatController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var zoneDeSaisie: UIView!
    @IBOutlet weak var zoneDeText: UITextView!
    @IBOutlet weak var appareilBouton: UIButton!
    @IBOutlet weak var gallerieBouton: UIButton!
    @IBOutlet weak var zoneDeTexteGaucheContrainte: NSLayoutConstraint!
    @IBOutlet weak var zoneDeTexteHauteurContrainte: NSLayoutConstraint!
    @IBOutlet weak var zoneDeSaisieHauteurContrainte: NSLayoutConstraint!
    
    var monId: String!
    var partenaire: Utilisateur!
    var imagePartenaire: UIImage?
    var picker = UIImagePickerController()
    var messages = [Message]()
    var cellId = "MessageCell"
    
    var vueBackground: UIView?
    var frameDeDepart: CGRect?
    var imageZoom: UIImageView?
    
    var estActif = false
    var enTrainDEcrire = false
    var derniereFoisEnLigne = ""
    var timer = Timer()
    
    var topLable = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        miseEnPlaceDuClavier()
        zoneDeText.layer.cornerRadius = 15
        zoneDeText.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "MessageCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellId)
        collectionView.keyboardDismissMode = .interactive
        observerMessages()
        picker.delegate = self
        picker.allowsEditing = true
        
        topLable.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        topLable.textAlignment = .center
        topLable.numberOfLines = 0
        self.navigationItem.titleView = topLable
        
        let retourBouton = UIBarButtonItem()
        retourBouton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = retourBouton
        observerActiviter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func miseEnPlace(id: String, utilisateur: Utilisateur, image: UIImage?) {
        self.monId = id
        self.partenaire = utilisateur
        self.imagePartenaire = image
        title = partenaire.prenom
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        cell.configurer(id: monId, message: messages[indexPath.row], image: imagePartenaire, controller: self)
        return cell
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var hauteur: CGFloat = 60
        let largeur = collectionView.frame.width
        
        let message = messages[indexPath.row]
        if let texte = message.texte, !texte.isEmpty {
            hauteur += texte.hauteur(largeur: largeur, font: UIFont.systemFont(ofSize: 17))
        }
        
        if let haut = message.hauteur, let large = message.largeur {
            hauteur += CGFloat(haut / large * 250)
        }
        
        return CGSize(width: largeur, height: hauteur)
    }
    
    func observerMessages() {
        Donnees().recevoirMessage(from: monId, to: partenaire.id) { (msg) -> (Void) in
            if let message = msg {
                self.messages.append(message)
                self.trierMessages()
            }
        }
        Donnees().recevoirMessage(from: partenaire.id, to: monId) { (msg) -> (Void) in
            if let message = msg {
                self.messages.append(message)
                self.trierMessages()
            }
        }
    }
    
    func trierMessages() {
        messages = messages.sorted(by: { $0.date < $1.date })
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func zoomIn(imageView: UIImageView) {
        frameDeDepart = imageView.superview?.convert(imageView.frame, to: nil)
        if let frame = frameDeDepart {
            self.navigationController?.navigationBar.isHidden = true
            imageZoom = UIImageView(frame: frame)
            imageZoom?.image = imageView.image
            imageZoom?.isUserInteractionEnabled = true
            imageZoom?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
            imageZoom?.layer.cornerRadius = BULLE_RADIUS
            imageZoom?.clipsToBounds = true
            imageZoom?.contentMode = .scaleAspectFill
            
            vueBackground = UIView(frame: self.view.bounds)
            vueBackground?.backgroundColor = .white
            
            view.addSubview(vueBackground!)
            view.addSubview(imageZoom!)
            
            UIView.animate(withDuration: 0.5) {
                let hauteur = frame.height / frame.width * self.view.frame.width
                self.imageZoom?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: hauteur)
                self.imageZoom?.center = self.view.center
                self.imageZoom?.layer.cornerRadius = 0
            }
        }
    }
    
    @objc func zoomOut() {
        self.navigationController?.navigationBar.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            if let frame = self.frameDeDepart {
                self.imageZoom?.frame = frame
                self.imageZoom?.layer.cornerRadius = BULLE_RADIUS
            }
        }) { (success) in
            self.imageZoom?.removeFromSuperview()
            self.imageZoom = nil
            self.vueBackground?.removeFromSuperview()
            self.vueBackground = nil
        }
    }
    
    func observerActiviter() {
        let ref = Ref().databaseStatut(id: partenaire.id)
        ref.observe(.value) { (snapshot) in
            if let snap = snapshot.value as? Dictionary<String, AnyObject> {
                if let actif = snap["online"] as? Bool, let date = snap["dernier"] as? Double {
                    self.estActif = actif
                    self.derniereFoisEnLigne = date.dateLisiblePourMessage()
                    if let ecritA = snap["ecrit"] as? String, ecritA == self.monId {
                        self.miseAJourTopLable(bool: true)
                    } else {
                        self.miseAJourTopLable(bool: false)
                    }
                }
            }
        }
    }
    
    func miseAJourTopLable(bool: Bool) {
        var secondeLigne = ""
        var couleur: UIColor = .darkGray
        if bool {
            secondeLigne = "Ecrit..."
        } else if estActif {
            secondeLigne = "Actif"
            couleur = .green
        } else {
            secondeLigne = "Vu " + derniereFoisEnLigne
            couleur = .red
        }
        
        let attributed = NSMutableAttributedString(string: partenaire.prenom + "\n", attributes: [.font: UIFont.systemFont(ofSize: 17), .foregroundColor:UIColor.black])
        attributed.append(NSAttributedString(string: secondeLigne, attributes: [.font: UIFont.systemFont(ofSize: 13), .foregroundColor:couleur]))
        
        topLable.attributedText = attributed
    }
}
