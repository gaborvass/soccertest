//
//  DrawTableViewController.swift
//  
//
//  Created by Vass, Gabor on 18/09/15.
//  Copyright © 2015 Gabor, Vass. All rights reserved.
//

import UIKit

/**
**/
protocol DrawViewControllerDelegate {
    func drawFinished()
}

class DrawViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var numOfRows : Int = 0
    var delegate : DrawViewControllerDelegate!
    var model = DrawModel()

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var tableView: UITableView = UITableView()

    //MARK: view lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = .red
        self.tableView.register(DrawTableViewCell.self, forCellReuseIdentifier: "drawCell")
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.tableView.applyDefaultStyle()

        self.model.onTeamGenerated = { team, index in
            let index = IndexPath.init(row: index, section: 0)
            self.tableView.insertRows(at: [index], with: .left)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.model.startDraw()

    }
    
    // MARK: UITableViewDataSource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.teams.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DrawTableViewCell = tableView.dequeueReusableCell(withIdentifier: "drawCell", for: indexPath) as! DrawTableViewCell
        
        cell.applyDefaultStyle()
        cell.bg.applyBackgroundImageStyle(alpha: 0.7)
        
        let team : TeamObject = self.model.teams[indexPath.row]
        cell.update(team)
        
        return cell
    }
    
    //MARK: UITableViewDelegate methods
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell : DrawTableViewCell = tableView.dequeueReusableCell(withIdentifier: "drawCellHeader") as! DrawTableViewCell
//
//        cell.applyDefaultStyle()
//        cell.bg.applyBackgroundImageStyle(alpha: 0.8)
//
//        return cell.contentView
//    }

    //MARK: View logic methods
    func callDelegate() {
        self.delegate.drawFinished()
    }

}
