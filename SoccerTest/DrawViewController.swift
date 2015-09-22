//
//  DrawTableViewController.swift
//  GamebasicsTest
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
    var gameEngine : GameEngine!
    var timer : NSTimer!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var tableView: UITableView!

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
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: "addRow", userInfo: nil, repeats: true)
    }
    
    // MARK: UITableViewDataSource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numOfRows
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : DrawTableViewCell = tableView.dequeueReusableCellWithIdentifier("drawCell", forIndexPath: indexPath) as! DrawTableViewCell
        
        cell.applyDefaultStyle()
        cell.bg.applyBackgroundImageStyle(0.7)
        
        let team : TeamObject = self.gameEngine.teams[indexPath.row]
        
        cell.teamFlag.image = UIImage(named: team.teamFlagName)
        cell.teamLabel.text = team.teamName
        
        return cell
    }
    
    //MARK: UITableViewDelegate methods
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell : DrawTableViewCell = tableView.dequeueReusableCellWithIdentifier("drawCellHeader") as! DrawTableViewCell

        cell.applyDefaultStyle()
        cell.bg.applyBackgroundImageStyle(0.8)

        return cell.contentView
    }

    //MARK: View logic methods
    func callDelegate() {
        self.delegate.drawFinished()
    }
    
    func addRow() {
        if self.numOfRows == 3 {
            self.timer.invalidate()
            self.performSelector("callDelegate", withObject: nil, afterDelay: 1.0)
        }
        
        self.tableView.beginUpdates()
        
        let path = NSIndexPath(forRow: self.numOfRows, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([path], withRowAnimation: UITableViewRowAnimation.Left)
        self.numOfRows++
        
        self.tableView.endUpdates()
    }
    

}
