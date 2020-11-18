//
//  ResultViewController.swift
//  
//
//  Created by Vass, Gabor on 21/09/15.
//  Copyright © 2015 Gabor, Vass. All rights reserved.
//

import UIKit

protocol ResultViewControllerDelegate {
    func close()
}

class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView: UITableView = UITableView()
    
    var delegate : ResultViewControllerDelegate!
    var gameEngine : GameEngine!
    var timer : Timer!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: view lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gameEngine = appDelegate.gameEngine
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.view.backgroundColor = UIColor.clear
        
        self.tableView.applyDefaultStyle()
        
    }
    
    // MARK: UITableViewDataSource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! ResultTableViewCell
        
        cell.applyDefaultStyle()
        cell.bg.applyBackgroundImageStyle(alpha: 0.9)
        
        
        let calculatedIndex = (indexPath.section * 2) + indexPath.row
        let team : TeamObject = self.gameEngine.teams[calculatedIndex]
        
        cell.flag.image = UIImage(named: team.flagName)
        cell.teamName.text = team.name
        cell.positionLabel.text = "\(calculatedIndex + 1)."
        
        return cell
    }
    
    //MARK: UITableViewDelegate methods
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 30
        }
        return 0
    }

    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let cell : ResultBottomCell = self.tableView.dequeueReusableCell(withIdentifier: "bottomCell") as! ResultBottomCell
            cell.replayButton.addTarget(self, action: Selector("replayButtonClicked"), for: UIControl.Event.touchUpInside)
            return cell.contentView
        }else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell : ResultHeaderCell = tableView.dequeueReusableCell(withIdentifier: "resultHeaderCell") as! ResultHeaderCell
        
        cell.applyDefaultStyle()
        if section == 0 {
            cell.headerText.text = "Advance to knockout phase"
        }else {
            cell.headerText.text = "Eliminated"
        }
        
        return cell.contentView
    }
    
    //MARK: View logic methods
    func replayButtonClicked() {
        self.delegate.close()
    }
        
}
