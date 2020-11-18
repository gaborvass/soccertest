//
//  DrawTableViewCell.swift
//  
//
//  Created by Vass, Gabor on 18/09/15.
//  Copyright © 2015 Gabor, Vass. All rights reserved.
//

import UIKit

class DrawTableViewCell: UITableViewCell {

    var teamFlag: UIImageView = UIImageView()
    var teamLabel: UILabel = UILabel()
    var bg: UIImageView = UIImageView()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(_ team: TeamObject) {
        let flagImage = UIImage(named: team.flagName)!
        self.teamFlag = UIImageView(image: flagImage)
        self.teamLabel.text = team.name
        self.bg = UIImageView(image: UIImage.init(named: "bg")!)
    }

    private func layout() {

        self.bg.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.bg)

        NSLayoutConstraint.activate([
            self.bg.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.bg.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.bg.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.bg.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])

        layoutFlag()
        layoutTeamName()

    }

    private func layoutFlag() {
        self.teamFlag.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.teamFlag)

        NSLayoutConstraint.activate([
            self.teamFlag.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.teamFlag.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.teamFlag.widthAnchor.constraint(equalToConstant: 40),
            self.teamFlag.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func layoutTeamName() {
        self.teamLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.teamLabel)

        NSLayoutConstraint.activate([
            self.teamLabel.leadingAnchor.constraint(equalTo: self.teamFlag.trailingAnchor, constant: 8),
            self.teamLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.teamLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8)
            //self.bg.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
