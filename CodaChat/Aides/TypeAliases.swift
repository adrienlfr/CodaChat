//
//  TypeAliases.swift
//  CodaChat
//
//  Created by Adrien Lefaure on 09/05/2018.
//  Copyright © 2018 Adrien Lefaure. All rights reserved.
//

import Foundation

typealias UtilisateurCompletion = (_ utilisateur: Utilisateur?) -> (Void)
typealias ChangementCompletion = (_ cle: String?, _ valeur: String?) -> (Void)
typealias MessageCompletion = (_ message: Message?) -> (Void)
typealias DernierMessageCompletion = (_ dernier: DernierMessage?) -> (Void)
typealias ChangementMessageCompletion = (_ cle: String?, _ value: AnyObject?) -> (Void)
