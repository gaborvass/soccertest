//
//  ResultViewController.swift
//  GamebasicsTest
//
//  Created by Vass, Gabor on 21/09/15.
//  Copyright © 2015 Gabor, Vass. All rights reserved.
//

import UIKit

protocol ResultViewControllerDelegate {
    func close()
}

class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate : ResultViewControllerDelegate!
    var gameEngine : GameEngine!
    var timer : NSTimer!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //MARK: view lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gameEngine = appDelegate.gameEngine
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.view.backgroundColor = UIColor.clearColor()
        
        self.tableView.applyDefaultStyle()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: UITableViewDataSource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : ResultTableViewCell = tableView.dequeueReusableCellWithIdentifier("resultCell", forIndexPath: indexPath) as! ResultTableViewCell
        
        cell.applyDefaultStyle()
        cell.bg.applyBackgroundImageStyle(0.9)
        
        
        let calculatedIndex = (indexPath.section * 2) + indexPath.row
        let team : TeamObject = self.gameEngine.teams[calculatedIndex]
        
        cell.flag.image = UIImage(named: team.teamFlagName)
        cell.teamName.text = team.teamName
        cell.positionLabel.text = "\(calculatedIndex + 1)."
        
        return cell
    }
    
    //MARK: UITableViewDelegate methods
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 30
        }
        return 0
    }

    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let cell : ResultBottomCell = self.tableView.dequeueReusableCellWithIdentifier("bottomCell") as! ResultBottomCell
            cell.replayButton.addTarget(self, action: "replayButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
            return cell.contentView
        }else {
            return UIView()
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell : ResultHeaderCell = tableView.dequeueReusableCellWithIdentifier("resultHeaderCell") as! ResultHeaderCell
        
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
