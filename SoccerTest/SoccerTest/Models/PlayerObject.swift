//
//  PlayerObject.swift
//  
//
//  Created by Vass, Gabor on 17/09/15.
//  Copyright © 2015 Gabor, Vass. All rights reserved.
//

import Foundation

// defines result types of an action
enum PlayerActionResult {
    case ballLost
    case ballKept
    case shot
    case scored
}

/**
Protocol selecting other player from the team
*/
protocol TeamDelegateProtocol {

    /**
    called when player with the ball wants to pass it to a team member
    :returns: team member to pass the ball to
    */

    func selectTeamMemberToPassTo() -> PlayerObject
}

// Player base class
class PlayerObject {

    // Player's name
    var name : String
    
    // Player's age
    var age : Int
    
    // Player's energy level, 1-100
    internal var energy : Int
    
    // Player's passing skill, 1-100
    internal var passingSkill : Int

    /**
    Returns player's current passing skill, which is calculated using current energy level
    :returns: current value, 1-100
    */
    var currentPassingSkill : Int {
        get {
            return (self.passingSkill * self.energy / 100)
        }
    }
    
    // team delegate in which the player is playing
    var teamDelegate : TeamDelegateProtocol?
    
    /**
    Inits a new player object
    :param: name            player's name
    :param: age             player's age
    :param: passingSkill    passing skill starting value
    */
    init(name: String, age: Int, passingSkill: Int) {
        self.name = name
        self.age = age
        self.passingSkill = passingSkill
        self.energy = 100
    }
    
    /**
    Tries to pass the ball to a team member
    :param: to     another player
    :returns: result of passing, BALL_KEPT if it succeded, or BALL_LOST, if it failed
    */
    private func pass(to: PlayerObject) -> PlayerActionResult {
        var retValue: PlayerActionResult = PlayerActionResult.ballLost
        let random : Int = Int(arc4random_uniform(100))
        if random >= 100 - self.currentPassingSkill {
            retValue = PlayerActionResult.ballKept
        }
        return retValue
    }
    
    /**
    Celebrate when player's team scores a goal
    Energy level is up by one
    */
    func celebrateGoal() {
        if self.energy < 100 {
            self.energy += 1
        }
    }
    
    /**
    Celebrate when player's team wins a match
    Energy level is up by 10
    */
    func celebrateMatchWon() {
        if self.energy < 90 {
            self.energy += 10
        }
    }
    
    /**
    Mourn when player's team gets a goal
    Energy level is down by one
    */
    func mournGoal() {
        if self.energy > 0 {
            self.energy -= 1
        }
    }
    
    /**
    Mourn when player's team loose a match
    Energy level is down by 5
    */
    func mournMatchLost() {
        if self.energy > 5 {
            self.energy -= 5
        }
    }
    
    /**
    Player's energy gets down by a calculated value based on player's age
    **/
    private func fatigue() {
        if self.energy - (1 - self.age / 100 ) > 0 {
            self.energy = self.energy - (1 - self.age / 100 )
        }
    }
    
    /**
    Calculates the movement of the player
    Currently every player tries to pass, except the strikers, who shoot on goal
    :returns: result of the movement
    **/
    func move() -> PlayerActionResult{
        var result : PlayerActionResult
        switch self {
        case is Striker:
            // a bit dummy, striker always shoots
            let striker : Striker = self as! Striker
            result = striker.shoot()
        default: result = self.pass(to: self.teamDelegate!.selectTeamMemberToPassTo())
        }
        // decrease energy level after each move
        self.fatigue()
        return result
    }
    
}

/**
Defines Goalkeeper class, extending PlayerObject
*/
class Goalkeeper : PlayerObject {
    
    /**
    Goalkeeper's keeping skill
    :returns: keeping skill, 1-100
    */
    private var keepingSkill : Int
    
    /**
    Returns current keeping skill, which is calculated using current energy level
    :returns: current keeping level
    **/
    var currentKeepingSkill : Int {
        get {
            return (self.keepingSkill * self.energy / 100)
        }
    }
    
    /**
    Inits a new goal keeper object
    :param: name            player's name
    :param: age             player's age
    :param: passingSkill    passing skill starting value
    :param: keepingSkill    keeping skill starting value
    */
    init(name: String, age : Int, passingSkill: Int, keepingSkill : Int) {
        self.keepingSkill = keepingSkill
        super.init(name: name, age: age, passingSkill: passingSkill)
    }
    
}

/**
Defines FieldPlayer class, extending PlayerObject
*/
class FieldPlayerObject : PlayerObject{

    /**
    Player's defending skill
    :returns: defending skill, 1-100
    */
    private var defendingSkill : Int
    
    /**
    Player's attacking skill
    :returns: attacking skill, 1-100
    */
    private var attackingSkill : Int
    
    /**
    Returns current defending skill, which is calculated using current energy level
    :returns: current defending level
    **/
    var currentDefendingSkill : Int {
        get {
            return (self.defendingSkill * self.energy / 100)
        }
    }

    /**
    Returns current attacking skill, which is calculated using current energy level
    :returns: current attacking level
    **/
    var currentAttackingSkill : Int {
        get {
            return (self.attackingSkill * self.energy / 100)
        }
    }
    
    /**
    Inits a new field player object
    :param: name            player's name
    :param: age             player's age
    :param: passingSkill    passing skill starting value
    :param: defendingSkill    defending skill starting value
    :param: attackingSkill    attacking skill starting value
    */
    init(name : String, age : Int, passingSkill: Int, defendingSkill : Int, attackingSkill : Int) {
        self.defendingSkill = defendingSkill
        self.attackingSkill  = attackingSkill
        super.init(name: name, age: age, passingSkill: passingSkill)
    }
    
    /**
    Shots ball to score
    :returns: .SHOT
    */
    func shoot() -> PlayerActionResult {
        return PlayerActionResult.shot
        
    }

}

/**
Defines Defender class, extending FieldPlayerObject
*/
class Defender : FieldPlayerObject {
    // no special skills right now
}

/**
Defines Midfielder class, extending FieldPlayerObject
*/
class Midfielder : FieldPlayerObject {
    // no special skills right now
}

/**
Defines Striker class, extending FieldPlayerObject
*/
class Striker : FieldPlayerObject {
    // no special skills right now
}
