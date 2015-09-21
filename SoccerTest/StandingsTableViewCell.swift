//
//  StandingsTableViewCell.swift
//  GamebasicsTest
//
//  Created by Vass, Gabor on 18/09/15.
//  Copyright © 2015 Gabor, Vass. All rights reserved.
//

import UIKit

class StandingsTableViewCell: UITableViewCell {

    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var drawnLabel: UILabel!
    @IBOutlet weak var gamesPlayedLabel: UILabel!
    @IBOutlet weak var lostLabel: UILabel!
    @IBOutlet weak var goalForLabel: UILabel!
    @IBOutlet weak var goalAgainstLabel: UILabel!
    @IBOutlet weak var goalDiffLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
