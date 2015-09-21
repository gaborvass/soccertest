//
//  UIHelperClass.swift
//  GamebasicsTest
//
//  Created by Vass, Gabor on 21/09/15.
//  Copyright © 2015 Gabor, Vass. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    func applyDefaultStyle() {
        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
        self.backgroundColor = UIColor.clearColor()
    }
}

extension UIImageView {
    func applyBackgroundImageStyle(alpha : CGFloat) {
        self.layer.cornerRadius = 2
        self.clipsToBounds = true
        self.alpha = alpha
    }
}

extension UITableView {
    func applyDefaultStyle() {
        self.backgroundColor = UIColor.clearColor()
        self.separatorColor = UIColor.clearColor()
    }
}