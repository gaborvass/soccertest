//
//  MatchObject.swift
//  
//
//  Created by Vass, Gabor on 17/09/15.
//  Copyright © 2015 Gabor, Vass. All rights reserved.
//

import Foundation

/**
Defines protocol to handle match related events
*/
protocol MatchEventDelegate {
    
    /**
    Player offers ball for challenge
    :param: otherTeamPlayer
    :returns: action result
    */
    func challengeForBall(against: FieldPlayerObject) -> PlayerActionResult
    
    /**
    Player shots on goal
    :param: otherTeamPlayer
    :returns: action result
    */
    func shotsOnGoal(against: FieldPlayerObject) -> PlayerActionResult
}

/**
MatchObject
*/
class MatchObject {

    //Block to call when match finished
    var matchCompletionBlock : (() -> Void)?
    
    // home team
    var homeTeam : TeamObject
    
    // away team
    var awayTeam : TeamObject
    
    // team with ball
    private var teamWithBall : TeamObject!

    // team without ball
    private var teamWithoutBall : TeamObject!
    
    // home team goals
    dynamic var homeTeamGoals : Int
    
    // away team goals
    dynamic var awayTeamGoals : Int
    
    // match runs for 2 seconds, flag to see if time is up
    private var timeIsUp : Bool = false
    
    // timer to measure match time
    private var timer : Timer!
    
    // shows if match started and not finished
    dynamic var matchInProgress : Bool
    
    /**
    Initializes match object
    :param: home team
    :param: away team
    */
    init(homeTeam : TeamObject, awayTeam: TeamObject){
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam

        self.homeTeamGoals = 0
        self.awayTeamGoals = 0
        
        self.matchInProgress = false
    }
    
    /**
    Plays a game
    :param: completion - called when match is ended
    */
    func playGame(completion: @escaping (() -> Void)) {
        
        self.matchCompletionBlock = completion
        self.matchInProgress = true
        
        // away team takes the ball
        self.awayTeam.takesBall()
        self.teamWithBall = self.awayTeam
        self.teamWithoutBall = self.homeTeam

        // start timer
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval.init(2.0), target: self, selector: #selector(endGame), userInfo: nil, repeats: false)

        DispatchQueue.main.async {
            self.internalPlayGame()
        }
    }
    
    /**
    Called by the timer, when match time is up
    */
    @objc
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
            // match drawn
            self.homeTeam.drawn += 1
            self.awayTeam.drawn += 1
        }else if self.homeTeamGoals > self.awayTeamGoals {
            // home team won, away team lost
            self.homeTeam.won += 1
            self.awayTeam.lost += 1
        }else {
            // away team won, home team lost
            self.homeTeam.lost += 1
            self.awayTeam.won += 1
        }
        
    }
    
    /**
    Plays the game
    */
    @objc
    func internalPlayGame() {
        var resultOfMove : PlayerActionResult = PlayerActionResult.ballKept
        // calls move() until result is BALL_KEPT
        while resultOfMove == PlayerActionResult.ballKept && !self.timeIsUp{
            let random : Int = Int(arc4random_uniform(UInt32(100)))
            if random % 4 == 0 && self.teamWithBall.playerWithBall is FieldPlayerObject{
                resultOfMove = self.teamWithoutBall.challengeForBall(against: self.teamWithBall.playerWithBall as! FieldPlayerObject)
            }else{
                resultOfMove = self.teamWithBall!.move()
            }
        }
        // if result is SHOT, then check if succeeds
        if resultOfMove == PlayerActionResult.shot {
            resultOfMove = self.teamWithoutBall.shotsOnGoal(against: self.teamWithBall.playerWithBall as! FieldPlayerObject)
        }
        // if player scored
        if resultOfMove == PlayerActionResult.scored {
            self.teamWithBall.scores()
            self.teamWithoutBall.consedes()
            if self.teamWithBall.name == self.homeTeam.name {
                self.homeTeamGoals += 1
            }else {
                self.awayTeamGoals += 1
            }
        }
        // if BALL_LOST, and match is in progress, other team gets the ball
        if !self.timeIsUp {
            let temp = self.teamWithBall
            self.teamWithBall = self.teamWithoutBall
            self.teamWithBall.takesBall()
            self.teamWithoutBall = temp

            NSObject.perform(#selector(internalPlayGame), with: nil, afterDelay: 0.1)
        } else {
            //print("match finished, result: \(self.homeTeam.teamName) \(self.homeTeamGoals) : \(self.awayTeamGoals) \(self.awayTeam.teamName)")
            self.matchCompletionBlock!()

        }
        
    
    }
    
}
