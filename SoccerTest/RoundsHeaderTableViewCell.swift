//
//  RoundsHeaderTableViewCell.swift
//  GamebasicsTest
//
//  Created by Vass, Gabor on 20/09/15.
//  Copyright © 2015 Gabor, Vass. All rights reserved.
//

import UIKit

class RoundsHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var bgImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
