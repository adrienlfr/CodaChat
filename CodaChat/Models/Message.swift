//
//  Message.swift
//  CodaChat
//
//  Created by Adrien Lefaure on 09/05/2018.
//  Copyright © 2018 Adrien Lefaure. All rights reserved.
//

import UIKit

class Message {
    
    private var _id: String!
    private var _from: String!
    private var _to: String!
    private var _date: Double!
    private var _texte: String?
    private var _imageUrl: String?
    private var _hauteur: Double?
    private var _largeur: Double?
    
    var from : String {
        return _from
    }
    var to : String {
        return _to
    }
    var date : Double {
        return _date
    }
    var texte : String? {
        return _texte
    }
    var imageUrl : String? {
        return _imageUrl
    }
    var hauteur : Double? {
        return _hauteur
    }
    var largeur : Double? {
        return _largeur
    }
    
    init(id: String, from: String, to: String, date: Double, texte: String?, imageUrl: String?, hauteur: Double?, largeur: Double?) {
        self._id = id
        self._from = from
        self._to = to
        self._date = date
        self._texte = texte
        self._imageUrl = imageUrl
        self._hauteur = hauteur
        self._largeur = largeur
    }
}
