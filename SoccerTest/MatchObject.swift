//
//  MatchObject.swift
//  GamebasicsTest
//
//  Created by Vass, Gabor on 17/09/15.
//  Copyright © 2015 Gabor, Vass. All rights reserved.
//

import Foundation

protocol MatchEventDelegate {
    func challengeForBall(otherTeamPlayer: FieldPlayerObject) -> PlayerActionResult
    func shotsOnGoal(otherTeamPlayer: FieldPlayerObject) -> PlayerActionResult
}

class MatchObject : NSObject{

    var matchCompletionBlock : (() -> Void)?
    
    var homeTeam : TeamObject
    var awayTeam : TeamObject
    
    private var teamWithBall : TeamObject!
    private var teamWithoutBall : TeamObject!
    
    dynamic var homeTeamGoals : Int
    dynamic var awayTeamGoals : Int
    
    private var timeIsUp : Bool = false
    private var timer : NSTimer!
    
    dynamic var matchInProgress : Bool
    
    init(homeTeam : TeamObject, awayTeam: TeamObject){
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam

        self.homeTeamGoals = 0
        self.awayTeamGoals = 0
        
        self.matchInProgress = false
    }
    
    
    func playGame(completion: (() -> Void)) {
        
        self.matchCompletionBlock = completion
        self.matchInProgress = true
        
        self.awayTeam.takesBall()
        self.teamWithBall = self.awayTeam
        self.teamWithoutBall = self.homeTeam

        self.timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "endGame", userInfo: nil, repeats: false)
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.playGame()
        }
    }
    
    func endGame() {
        self.timeIsUp = true
        self.matchInProgress = false
        
        self.homeTeam.gamesPlayed += 1
        self.awayTeam.gamesPlayed += 1
        
        self.homeTeam.goalsAgainst += self.awayTeamGoals
        self.awayTeam.goalsAgainst += self.homeTeamGoals
        
        self.homeTeam.goalsFor += self.homeTeamGoals
        self.awayTeam.goalsFor += self.awayTeamGoals
        
        if self.homeTeamGoals == self.awayTeamGoals {
            self.homeTeam.drawn += 1
            self.awayTeam.drawn += 1
        }else if self.homeTeamGoals > self.awayTeamGoals {
            self.homeTeam.won += 1
            self.awayTeam.lost += 1
        }else {
            self.homeTeam.lost += 1
            self.awayTeam.won += 1
        }
        
    }
    
    func playGame() {
        var resultOfMove : PlayerActionResult = PlayerActionResult.BALL_KEPT
        while resultOfMove == PlayerActionResult.BALL_KEPT && !self.timeIsUp{
            let random : Int = Int(arc4random_uniform(UInt32(100)))
            if random % 4 == 0 && self.teamWithBall.playerWithBall is FieldPlayerObject{
                resultOfMove = self.teamWithoutBall.challengeForBall(self.teamWithBall.playerWithBall as! FieldPlayerObject)
            }else{
                resultOfMove = self.teamWithBall!.move()
            }
        }
        if resultOfMove == PlayerActionResult.SHOT {
            resultOfMove = self.teamWithoutBall.shotsOnGoal(self.teamWithBall.playerWithBall as! FieldPlayerObject)
        }
        if resultOfMove == PlayerActionResult.SCORED {
            self.teamWithBall.scores()
            self.teamWithoutBall.consedes()
            if self.teamWithBall.teamName == self.homeTeam.teamName {
                self.homeTeamGoals++
            }else {
                self.awayTeamGoals++
            }
        }
        if !self.timeIsUp {
            let temp = self.teamWithBall
            self.teamWithBall = self.teamWithoutBall
            self.teamWithBall.takesBall()
            self.teamWithoutBall = temp
          
            self.performSelector("playGame", withObject: nil, afterDelay: 0.1)
        } else {
            //print("match finished, result: \(self.homeTeam.teamName) \(self.homeTeamGoals) : \(self.awayTeamGoals) \(self.awayTeam.teamName)")
            self.matchCompletionBlock!()

        }
        
    
    }
    
}