//
//  DrawTableViewCell.swift
//  GamebasicsTest
//
//  Created by Vass, Gabor on 18/09/15.
//  Copyright © 2015 Gabor, Vass. All rights reserved.
//

import UIKit

class DrawTableViewCell: UITableViewCell {

    @IBOutlet weak var teamFlag: UIImageView!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var bg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
