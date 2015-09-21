//
//  ViewController.swift
//  GamebasicsTest
//
//  Created by Vass, Gabor on 17/09/15.
//  Copyright © 2015 Gabor, Vass. All rights reserved.
//

import UIKit

class StandingsTableViewController: UITableViewController, DrawViewControllerDelegate, ResultViewControllerDelegate {

    var gameEngine : GameEngine!

    var numOfSections : Int = 0

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var standingChangesContext = 0
    var match1_homeTeamScoresContext = 1
    var match1_awayTeamScoresContext = 2

    var match2_homeTeamScoresContext = 3
    var match2_awayTeamScoresContext = 4

    var match1_matchInProgress = 5
    var match2_matchInProgress = 6
    
    //MARK: view lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.gameEngine = appDelegate.gameEngine

        self.gameEngine.generateTeams()
        self.gameEngine.registerStandingsObserver(self)

        self.tableView.backgroundView = UIImageView(image: UIImage(named: "bg"))

        self.tableView.applyDefaultStyle()

        self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)

        self.numOfSections = 1
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.presentViewController("DrawViewController")
        //self.presentViewController("FinalResultViewController")


    }
    
    //MARK: UITableViewDataSource methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 4
        case 1: return 2
        case 2: return 2
        case 3: return 2
        default: return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell : StandingsTableViewCell = tableView.dequeueReusableCellWithIdentifier("standingsCell", forIndexPath: indexPath) as! StandingsTableViewCell

            let teamObject = self.gameEngine.teams[indexPath.row]
            
            cell.bgImage.applyBackgroundImageStyle(0.4)
            cell.applyDefaultStyle()
            
            self.fillStandingsData(indexPath.row + 1, teamObject: teamObject, cell: cell)
            
            return cell
        case 1,2,3:
            let cell : MatchTableViewCell = tableView.dequeueReusableCellWithIdentifier("matchCell", forIndexPath: indexPath) as! MatchTableViewCell
            cell.bgImage.applyBackgroundImageStyle(0.4)
            cell.applyDefaultStyle()
            
            let match = self.gameEngine.currentMatches![indexPath.row]
            
            self.fillMatchData(match, cell: cell)
            
            return cell
            
        default: return UITableViewCell()
        }
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.numOfSections
    }

    //MARK: UITableViewDelegate methods
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
            case 0 :
                let cell : StandingsTableViewCell = tableView.dequeueReusableCellWithIdentifier("standingsCell") as! StandingsTableViewCell
                cell.backgroundColor = UIColor.clearColor()
                cell.bgImage.applyBackgroundImageStyle(cell.bgImage.alpha)
                return cell
            default:
                let cell : RoundsHeaderTableViewCell = tableView.dequeueReusableCellWithIdentifier("roundsHeaderCell") as! RoundsHeaderTableViewCell
                cell.backgroundColor = UIColor.clearColor()
                cell.bgImage.applyBackgroundImageStyle(cell.bgImage.alpha)
                cell.roundLabel.text = "Round \(section)"
                return cell.contentView
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    //MARK: ResultViewControllerDelegate methods
    func replay() {
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }

    //MARK: DrawViewControllerDelegate methods
    func drawFinished() {
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.numOfSections = 1
            self.tableView.reloadData()
            self.performSelector("setupRounds", withObject: nil, afterDelay: 1.0)
        }
    }
    
    //MARK: gameplay methods
    func setupRounds() {
        if self.numOfSections < 4 {
            let indexSet : NSIndexSet = NSIndexSet(index: self.numOfSections)
            
            self.numOfSections++
            
            self.gameEngine.setupRound(self, roundNum: self.numOfSections - 1) { () -> Void in
                self.tableView.beginUpdates()
                self.tableView.insertSections(indexSet, withRowAnimation: UITableViewRowAnimation.Left)
                self.tableView.endUpdates()
                
                self.tableView.setNeedsDisplay()
                
                self.performSelector("playRounds", withObject: nil, afterDelay: 1.0)
                
            }
        }else{
            // simulation finished, show final result
            self.presentViewController("FinalResultViewController")
            
        }
    }
    
    func playRounds() {

        self.gameEngine.playRound(self.numOfSections - 1, completion: { () -> Void in
            self.performSelector("setupRounds", withObject: nil, afterDelay: 1.5)
        })
        
    }
    
    //MARK: View helper methods
    func presentViewController(name: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController : UIViewController?
        if name == "DrawViewController" {
            let drawVC = storyboard.instantiateViewControllerWithIdentifier(name) as! DrawViewController
            drawVC.delegate = self
            viewController = drawVC
        }else{
            let resultVC = storyboard.instantiateViewControllerWithIdentifier(name) as! ResultViewController
            resultVC.delegate = self
            viewController = resultVC
        }
        
        self.presentViewController(viewController!, animated: true) { () -> Void in
        }
    }
    
    func fillStandingsData(ranking: Int, teamObject: TeamObject, cell: StandingsTableViewCell) {
        cell.rankingLabel.text = "\(ranking)"
        cell.teamLabel.text = teamObject.teamName
        cell.gamesPlayedLabel.text = "\(teamObject.gamesPlayed)"
        cell.winLabel.text = "\(teamObject.won)"
        cell.drawnLabel.text = "\(teamObject.drawn)"
        cell.lostLabel.text = "\(teamObject.lost)"
        cell.goalForLabel.text = "\(teamObject.goalsFor)"
        cell.goalAgainstLabel.text = "\(teamObject.goalsAgainst)"
        if teamObject.goalDiff == 0 {
            cell.goalDiffLabel.text = "0"
        }else {
            cell.goalDiffLabel.text = teamObject.goalDiff < 0 ? "\(teamObject.goalDiff)" : "+\(teamObject.goalDiff)"
        }
        cell.pointsLabel.text = "\(teamObject.points)"
    }
    
    func fillMatchData(match: MatchObject, cell: MatchTableViewCell) {
        let homeTeam = match.homeTeam
        let awayTeam = match.awayTeam
        
        cell.homeFlag.image = UIImage(named: homeTeam.teamFlagName)
        cell.awayFlag.image = UIImage(named: awayTeam.teamFlagName)
        
        cell.homeTeamNameLabel.text = homeTeam.teamName
        cell.awayTeamNameLabel.text = awayTeam.teamName
        cell.homeTeamGoals.text = "\(match.homeTeamGoals)"
        cell.awayTeamGoals.text = "\(match.awayTeamGoals)"
    }
    
    //MARK: KVO methods
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &standingChangesContext {
            if let newValue : Int = change?[NSKeyValueChangeNewKey] as? Int{
                let oldValue : Int = change?[NSKeyValueChangeOldKey] as! Int
                
                self.tableView.beginUpdates()
                if oldValue != newValue {
                    self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: oldValue, inSection: 0), NSIndexPath(forRow: newValue, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Right)
                    self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: oldValue, inSection: 0), NSIndexPath(forRow: newValue, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Left)
                }else {
                    self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: oldValue, inSection: 0), NSIndexPath(forRow: newValue, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
                }
                self.tableView.endUpdates()
            }else{
                super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            }
        } else if context == &self.match1_homeTeamScoresContext{
            // home team scored in match1
            if let newValue : Int = change?[NSKeyValueChangeNewKey] as? Int{
                let oldValue : Int = change?[NSKeyValueChangeOldKey] as! Int
                if newValue == oldValue { return }
                let matchCell : MatchTableViewCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: self.numOfSections-1)) as! MatchTableViewCell
                matchCell.homeTeamGoals.text = "\(newValue)"
                
            }
        } else if context == &self.match1_awayTeamScoresContext{
            // away team scored in match1
            if let newValue : Int = change?[NSKeyValueChangeNewKey] as? Int{
                let oldValue : Int = change?[NSKeyValueChangeOldKey] as! Int
                if newValue == oldValue { return }
                let matchCell : MatchTableViewCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: self.numOfSections-1)) as! MatchTableViewCell
                matchCell.awayTeamGoals.text = "\(newValue)"
                
            }
            
        } else if context == &self.match2_homeTeamScoresContext{
            // home team scored in match2
            if let newValue : Int = change?[NSKeyValueChangeNewKey] as? Int{
                let oldValue : Int = change?[NSKeyValueChangeOldKey] as! Int
                if newValue == oldValue { return }
                let matchCell : MatchTableViewCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: self.numOfSections-1)) as! MatchTableViewCell
                
                matchCell.homeTeamGoals.text = "\(newValue)"
                
            }
            
        } else if context == &self.match2_awayTeamScoresContext{
            // away team scored in match2
            if let newValue : Int = change?[NSKeyValueChangeNewKey] as? Int{
                let oldValue : Int = change?[NSKeyValueChangeOldKey] as! Int
                if newValue == oldValue { return }
                let matchCell : MatchTableViewCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: self.numOfSections-1)) as! MatchTableViewCell
                matchCell.awayTeamGoals.text = "\(newValue)"
                
            }
        } else if context == &self.match1_matchInProgress {
            if let newValue : Bool = change?[NSKeyValueChangeNewKey] as? Bool{
                let matchCell : MatchTableViewCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: self.numOfSections-1)) as! MatchTableViewCell
                matchCell.progressIndicator.hidden = !newValue
            }
        } else if context == &self.match2_matchInProgress {
            if let newValue : Bool = change?[NSKeyValueChangeNewKey] as? Bool{
                let matchCell : MatchTableViewCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: self.numOfSections-1)) as! MatchTableViewCell
                matchCell.progressIndicator.hidden = !newValue
            }
        }
    }
    
}

