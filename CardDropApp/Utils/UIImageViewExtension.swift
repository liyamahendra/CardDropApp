//
//  UIImageViewExtension.swift
//  CardDropApp
//
//  Created by Mahendra Liya on 01/09/20.
//  Copyright © 2020 Varm Yoga. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {    
    func imageURL(_ url: String) {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.center = CGPoint(x: self.frame.size.width  / 2, y: self.frame.size.height / 2)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(activityIndicator)
                
//        self.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder.png"), options: .highPriority, completed: { (image, error, cacheType, url) in
//                activityIndicator.stopAnimating()
//        })
        
        self.sd_setImage(with: URL(string: url)) { (image, error, cacheType, url) in
            activityIndicator.stopAnimating()
        }
    }
}
