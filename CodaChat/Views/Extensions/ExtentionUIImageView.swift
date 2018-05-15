//
//  ExtentionUIImageView.swift
//  CodaChat
//
//  Created by Adrien Lefaure on 09/05/2018.
//  Copyright © 2018 Adrien Lefaure. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    func telecharger(_ urlString: String?) {
        image = #imageLiteral(resourceName: "photo_profil")
        guard let string = urlString else { return }
        guard let url = URL(string: string) else { return }
        sd_setImage(with: url, completed: nil)
    }
    
}
