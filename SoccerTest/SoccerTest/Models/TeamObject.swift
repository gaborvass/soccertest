//
//  TeamObject.swift
//  
//
//  Created by Vass, Gabor on 17/09/15.
//  Copyright © 2015 Gabor, Vass. All rights reserved.
//

import Foundation

/**
Team object.
Currently all teams play in 4-4-2 format
*/
class TeamObject: TeamDelegateProtocol, MatchEventDelegate{
 
    // team's name
    var name : String
    
    // world ranking
    var worldRanking : Int
    
    // team's flag name
    var flagName : String
    
    // games played
    var gamesPlayed : Int
    
    // won
    var won : Int
    
    // drawn
    var drawn : Int
    
    // lost
    var lost: Int
    
    // goals scored
    var goalsFor : Int
    
    // goals scored against
    var goalsAgainst : Int
    
    // goal difference
    var goalDiff : Int {
        get{
            return self.goalsFor - self.goalsAgainst
        }
    }
    
    // points
    var points : Int {
        get{
            return self.won * 3 + self.drawn
        }
    }

    // current position in group phase
    dynamic var currentPosition : Int
    
    // goalkepper
    var goalKeeper: Goalkeeper!
    
    // defenders
    var defenders: Array<Defender>!
    
    // midfielders
    var midfielders : Array<Midfielder>!
    
    // strikers
    var strikers : Array<Striker>!
    
    // player in the team, who has the ball
    var playerWithBall : PlayerObject!
    
    // selected player to pass the ball to
    private var nextPlayer: PlayerObject!
    
    // is position equals after round 3 with an other team
    var positionEquals : Bool?
    
    // if there are team's with the same points, goal against, etc, the correct order calculated based on the mini tables
    var positionInMiniTable : Int = 0

    /**
    Initializes a new team object
    :param: teamName
    :param: flagName
    :param: worldRanking
    :param: starting position in the group
    */
    init(teamName: String, flagName: String, worldRanking: Int, position: Int){
        
        self.name = teamName
        self.flagName = flagName
        self.worldRanking = worldRanking
        self.currentPosition = position
                
        self.gamesPlayed = 0
        self.won = 0
        self.drawn = 0
        self.lost = 0
        self.goalsFor = 0
        self.goalsAgainst = 0
     
    }

    /**
    Team scores a goal, and celebrates it
    */
    func scores() {
        self.celebrateGoal()
    }

    /**
    Team consedes a goal, and mourns it
    */
    func consedes() {
        self.mournGoal()
    }

    /**
    Team takes ball
    Currently always the goalkeeper gets it
    */
    func takesBall() {
        self.playerWithBall = self.goalKeeper
    }
    
    /**
    Player's move in each round
    :returns result of movement
    */
    func move() -> PlayerActionResult{
        let retValue = self.playerWithBall!.move()
        if retValue == PlayerActionResult.ballKept {
            self.playerWithBall = self.nextPlayer
        }
        return retValue
    }
    
    /**
    Celebrates goal
    */
    func celebrateGoal() {
        self.changeEnergyLevel(event: "celebrateGoal")
    }
    
    /**
    Mourns goal
    */
    func mournGoal() {
        self.changeEnergyLevel(event: "mournGoal")
    }
    
    /**
    Celebrate match won
    */
    func celebrateWon() {
        self.changeEnergyLevel(event: "celebrateMatchWon")
    }
    
    /**
    Mourn match lost
    */
    func mournMatchLost() {
        self.changeEnergyLevel(event: "mournMatchLost")
    }
    
    /**
    Changes the player's energy level using different events
    :param: selectorStr : selector which changes the energy level
    */
    private func changeEnergyLevel(event selectorStr : String) {
        //self.goalKeeper.performSelector(Selector(selectorStr))
        for player in self.defenders {
            //player.performSelector(Selector(selectorStr))
        }
        for player in self.midfielders {
            //player.performSelector(Selector(selectorStr))
        }
        for player in self.strikers {
            //player.performSelector(Selector(selectorStr))
        }
    }

    //MARK: TeamDelegateProtocol methods

    /**
    Selects a team member who will receive the ball
    :returns: playerObject
    */
    func selectTeamMemberToPassTo() -> PlayerObject {
        switch self.playerWithBall {
        // goalkeeper can pass to one of the defenders
        case is Goalkeeper:
            let random : Int = Int(arc4random_uniform(4))
            self.nextPlayer = self.defenders![random]
        // defender can pass to one of the midfielders
        case is Defender:
            let random : Int = Int(arc4random_uniform(4))
            self.nextPlayer = self.midfielders![random]
        // midfielder can pass to one of the strikers
        case is Midfielder:
            let random : Int = Int(arc4random_uniform(2))
            self.nextPlayer = self.strikers![random]
        default:
            break
        }
        return self.nextPlayer!
        
    }

    // MARK: MatchEventDelegate methods
    
    /**
    Player with ball offers it for challenge
    Logic is simple : defenders challenge against strikers
    midfielders challenge against midfielders
    striker challenge against defenders
    :param: otherTeamPlayer player from the other team
    :returns: playerActionResult - BALL_KEPT or BALL_LOST
    */
    func challengeForBall(against otherTeamPlayer: FieldPlayerObject) -> PlayerActionResult {
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
        default: return PlayerActionResult.ballKept
        }
        
        if otherTeamPlayer.currentAttackingSkill >= ownPlayer.currentDefendingSkill {
            return PlayerActionResult.ballKept
        }else {
            return PlayerActionResult.ballLost
        }
    
    }
    
    /**
    Player shoots on goal
    If striker shooting skill > keeper.keeping skill -> goal, if not, ball lost
    :param: striker of the other team, who shoots on goal
    :returns: action result
    */
    func shotsOnGoal(against otherTeamPlayer: FieldPlayerObject) -> PlayerActionResult {
        if self.goalKeeper.currentKeepingSkill >= otherTeamPlayer.currentAttackingSkill {
            return PlayerActionResult.ballLost
        }else {
            return PlayerActionResult.scored
        }
    }

    
}
