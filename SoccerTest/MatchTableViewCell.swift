//
//  MatchTableViewCell.swift
//  GamebasicsTest
//
//  Created by Vass, Gabor on 19/09/15.
//  Copyright © 2015 Gabor, Vass. All rights reserved.
//

import UIKit

class MatchTableViewCell: UITableViewCell {
    @IBOutlet weak var homeFlag: UIImageView!
    @IBOutlet weak var awayFlag: UIImageView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamGoals: UILabel!
    @IBOutlet weak var homeTeamGoals: UILabel!
    @IBOutlet weak var progressIndicator: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
