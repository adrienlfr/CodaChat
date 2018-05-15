//
//  ImageArrondie.swift
//  CodaChat
//
//  Created by Adrien Lefaure on 09/05/2018.
//  Copyright © 2018 Adrien Lefaure. All rights reserved.
//

import UIKit

class ImageArrondie: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        arrondirImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        arrondirImage()
    }
    
    func arrondirImage() {
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
        contentMode = .scaleAspectFill
    }

}
