//
//  BoutonArrondieAvecOmbre.swift
//  CodaChat
//
//  Created by Adrien Lefaure on 07/05/2018.
//  Copyright © 2018 Adrien Lefaure. All rights reserved.
//

import UIKit

class BoutonArrondieAvecOmbre: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        miseEnPlaceUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        miseEnPlaceUI()
    }
    
    func miseEnPlaceUI() {
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.shadowOpacity = 0.75
    }
}
