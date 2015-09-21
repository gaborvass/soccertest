//
//  ResultTableViewCell.swift
//  GamebasicsTest
//
//  Created by Vass, Gabor on 21/09/15.
//  Copyright © 2015 Gabor, Vass. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var bg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
