//
//  TeamObject.swift
//  GamebasicsTest
//
//  Created by Vass, Gabor on 17/09/15.
//  Copyright © 2015 Gabor, Vass. All rights reserved.
//

import Foundation

class TeamObject : NSObject, TeamDelegateProtocol, MatchEventDelegate{
 
    var teamName : String
    var worldRanking : Int
    var teamFlagName : String
    
    var gamesPlayed : Int
    var won : Int
    var drawn : Int
    var lost: Int
    
    var goalsFor : Int
    var goalsAgainst : Int
    var goalDiff : Int {
        get{
            return self.goalsFor - self.goalsAgainst
        }
    }
    
    var points : Int {
        get{
            return self.won * 3 + self.drawn
        }
    }

    dynamic var currentPosition : Int
    
    var goalKeeper: Goalkeeper!
    var defenders: Array<Defender>!
    var midfielders : Array<Midfielder>!
    var strikers : Array<Striker>!
    
    var playerWithBall : PlayerObject!
    
    private var nextPlayer: PlayerObject!
    
    var positionEquals : Bool?
    var positionInMiniTable : Int = 0

    init(teamName: String, flagName: String, worldRanking: Int, position: Int){
        
        self.teamName = teamName
        self.teamFlagName = flagName
        self.worldRanking = worldRanking
        self.currentPosition = position
                
        self.gamesPlayed = 0
        self.won = 0
        self.drawn = 0
        self.lost = 0
        self.goalsFor = 0
        self.goalsAgainst = 0
     
    }

    func scores() {
        self.celebrateGoal()
    }

    func consedes() {
        self.mournGoal()
    }

    func takesBall() {
        self.playerWithBall = self.goalKeeper
    }
    
    func move() -> PlayerActionResult{
        let retValue = self.playerWithBall!.move()
        if retValue == PlayerActionResult.BALL_KEPT {
            self.playerWithBall = self.nextPlayer
        }
        return retValue
    }
    
    func celebrateGoal() {
        self.changeEnergyLevel("celebrateGoal")
    }
    
    func mournGoal() {
        self.changeEnergyLevel("mournGoal")
    }
    
    func celebrateWon() {
        self.changeEnergyLevel("celebrateMatchWon")
    }
    
    func mournMatchLost() {
        self.changeEnergyLevel("mournMatchLost")
    }
    
    private func changeEnergyLevel(selectorStr : String) {
        self.goalKeeper.performSelector(Selector(selectorStr))
        for player in self.defenders {
            player.performSelector(Selector(selectorStr))
        }
        for player in self.midfielders {
            player.performSelector(Selector(selectorStr))
        }
        for player in self.strikers {
            player.performSelector(Selector(selectorStr))
        }
    }

    func selectTeamMemberToPassTo() -> PlayerObject {
        switch self.playerWithBall {
        // goalkeeper can pass to one of the defenders
        case is Goalkeeper:
            let random : Int = Int(arc4random_uniform(4))
            self.nextPlayer = self.defenders![random]
        case is Defender:
            let random : Int = Int(arc4random_uniform(4))
            self.nextPlayer = self.midfielders![random]
        case is Midfielder:
            let random : Int = Int(arc4random_uniform(2))
            self.nextPlayer = self.strikers![random]
        default:
            break
        }
        return self.nextPlayer!
        
    }
    
    //XXX: add some randomness
    func challengeForBall(otherTeamPlayer: FieldPlayerObject) -> PlayerActionResult {
        let ownPlayer : FieldPlayerObject
        switch otherTeamPlayer{
        case is Defender:
            let random : Int = Int(arc4random_uniform(2))
            ownPlayer = self.strikers![random]
        case is Midfielder:
            let random : Int = Int(arc4random_uniform(4))
            ownPlayer = self.midfielders![random]
        case is Striker:
            let random : Int = Int(arc4random_uniform(4))
            ownPlayer = self.midfielders![random]
        default: return PlayerActionResult.BALL_KEPT
        }
        
        if otherTeamPlayer.currentAttackingSkill >= ownPlayer.currentDefendingSkill {
            return PlayerActionResult.BALL_KEPT
        }else {
            return PlayerActionResult.BALL_LOST
        }
    
    }
    
    //XXX: add some randomness
    func shotsOnGoal(otherTeamPlayer: FieldPlayerObject) -> PlayerActionResult {
        if self.goalKeeper.currentKeepingSkill >= otherTeamPlayer.currentAttackingSkill {
            return PlayerActionResult.BALL_LOST
        }else {
            return PlayerActionResult.SCORED
        }
    }

    
}