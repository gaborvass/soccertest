//
//  GameMotor.swift
//  GamebasicsTest
//
//  Created by Vass, Gabor on 18/09/15.
//  Copyright © 2015 Gabor, Vass. All rights reserved.
//

import Foundation

class GameEngine : NSObject{

    private static let SPAIN        = "Spain"
    private static let NETHERLANDS  = "Netherlands"
    private static let CHILE        = "Chile"
    private static let AUSTRALIA    = "Australia"
    
    private static var ROUND_1 : Array<String> =  [SPAIN, NETHERLANDS, CHILE, AUSTRALIA]
    private static var ROUND_2 : Array<String> =  [SPAIN, CHILE, AUSTRALIA, NETHERLANDS]
    private static var ROUND_3 : Array<String> =  [AUSTRALIA, SPAIN, CHILE, NETHERLANDS]
    
    var teams : Array<TeamObject> = Array<TeamObject>()
    var currentMatches : Array<MatchObject>!

    var matchObserver : StandingsTableViewController!
    
    private var rounds : Dictionary<String, Array<String>> = ["ROUND1" : ROUND_1,"ROUND2" : ROUND_2, "ROUND3" : ROUND_3]

    func generateTeams() {
        self.teams.append(self.generateTeam(GameEngine.SPAIN, flagName: GameEngine.SPAIN.lowercaseString, worldRanking: 1, position: 0))
        self.teams.append(self.generateTeam(GameEngine.NETHERLANDS, flagName: GameEngine.NETHERLANDS.lowercaseString, worldRanking: 4, position: 1))
        self.teams.append(self.generateTeam(GameEngine.CHILE, flagName: GameEngine.CHILE.lowercaseString, worldRanking: 32, position: 2))
        self.teams.append(self.generateTeam(GameEngine.AUSTRALIA, flagName: GameEngine.AUSTRALIA.lowercaseString, worldRanking: 65, position: 3))
        
    }
    
    func registerStandingsObserver(observer: StandingsTableViewController){
        for team in self.teams {
            team.addObserver(observer, forKeyPath: "currentPosition", options: NSKeyValueObservingOptions([.New, .Old]), context: &observer.standingChangesContext)
        }
    }
    
    func setupRound(matchObserver: StandingsTableViewController, roundNum: Int, completion: (() -> Void)) {
        self.matchObserver = matchObserver
        self.setupRound(roundNum, completion: completion)
    }
    
    private func playMatch(match: MatchObject, completion: (() -> Void)){
        // add observer
        match.playGame { () -> Void in
            match.removeObserver(self.matchObserver, forKeyPath: "homeTeamGoals")
            match.removeObserver(self.matchObserver, forKeyPath: "awayTeamGoals")
            match.removeObserver(self.matchObserver, forKeyPath: "matchInProgress")
            completion()
        }
    }
    
    private func setupRound(roundNum : Int, completion: (() -> Void)) {
        var roundMatches : Array<String> = self.rounds["ROUND\(roundNum)"] as Array<String>!
        
        let team1 = self.teams.findTeam(roundMatches[0]) as! TeamObject
        let team2 = self.teams.findTeam(roundMatches[1]) as! TeamObject
        let team3 = self.teams.findTeam(roundMatches[2]) as! TeamObject
        let team4 = self.teams.findTeam(roundMatches[3]) as! TeamObject
        
        let match1 : MatchObject = MatchObject(homeTeam: team1, awayTeam: team2)
        match1.addObserver(self.matchObserver, forKeyPath: "homeTeamGoals", options: NSKeyValueObservingOptions([.New, .Old]), context: &self.matchObserver.match1_homeTeamScoresContext)
        match1.addObserver(self.matchObserver, forKeyPath: "awayTeamGoals", options: NSKeyValueObservingOptions([.New, .Old]), context: &self.matchObserver.match1_awayTeamScoresContext)
        match1.addObserver(self.matchObserver, forKeyPath: "matchInProgress", options: NSKeyValueObservingOptions([.New, .Old]), context: &self.matchObserver.match1_matchInProgress)
        
        let match2 : MatchObject = MatchObject(homeTeam: team3, awayTeam: team4)
        match2.addObserver(self.matchObserver, forKeyPath: "homeTeamGoals", options: NSKeyValueObservingOptions([.New, .Old]), context: &self.matchObserver.match2_homeTeamScoresContext)
        match2.addObserver(self.matchObserver, forKeyPath: "awayTeamGoals", options: NSKeyValueObservingOptions([.New, .Old]), context: &self.matchObserver.match2_awayTeamScoresContext)
        match2.addObserver(self.matchObserver, forKeyPath: "matchInProgress", options: NSKeyValueObservingOptions([.New, .Old]), context: &self.matchObserver.match2_matchInProgress)
        
        self.currentMatches = [match1, match2]
        
        completion()
    }
    
    func playRound(roundNum : Int, completion: (() -> Void)) {
        //print("Playing round \(roundNum)")
        self.playMatch(self.currentMatches[0]) { () -> Void in
            self.playMatch(self.currentMatches[1], completion: { () -> Void in
                self.performSelector("calculateOrder:", withObject: roundNum, afterDelay: 0.5)
                completion()
            })
        }
        
    }
    
    private func generateAge() -> Int{
        return 16 + Int(arc4random_uniform(14))
    }
    
    private func generateSkill(worldRanking: Int) -> Int{
        let maxValue : Int = 70 - worldRanking
        return 30 + Int(arc4random_uniform(UInt32(maxValue)))
        //return 100
    }
    
/*
    1. greatest number of points obtained in all group matches;
    2. goal difference in all group matches;
    3. greatest number of goals scored in all group matches.
    
    If two or more teams are equal on the basis of the above three criteria, their rankings shall be determined as follows:
    greatest number of points obtained in the group matches between the teams concerned;
    goal difference resulting from the group matches between the teams concerned;
    greater number of goals scored in all group matches between the teams concerned;
    drawing of lots by the FIFA Organising Committee.
*/
    func calculateOrder(roundNum: Int){
        var hasEqualTeams : Bool = false
        self.teams = self.teams.sort({
            if $0.points == $1.points {
                if $0.goalDiff == $1.goalDiff {
                    if $0.goalsFor == $1.goalsFor {
                        if roundNum == 3 {
                            hasEqualTeams = true
                            $0.positionEquals = true
                            $1.positionEquals = true
                        }
                        return false
                    }else{
                        
                        return $0.goalsFor > $1.goalsFor
                    }
                }else {
                    return $0.goalDiff > $1.goalDiff
                }
            }else {
                return $0.points > $1.points
            }
        })
        
        if hasEqualTeams {
            var notEqualTeams : Array<String> = Array<String>()
            for team in self.teams {
                if team.positionEquals != true {
                    team.positionInMiniTable = 100
                    notEqualTeams.append(team.teamName)
                }
            }
            
            self.calculateMiniStandings(notEqualTeams)
            
            self.teams = self.teams.sort({
                return $0.positionInMiniTable < $1.positionInMiniTable
            })
        }
        for team in self.teams {
            team.currentPosition = self.teams.indexOf(team)!
        }
        
    }
    
    var matches : Array<MatchObject> = Array<MatchObject>()
    
    private func calculateMiniStandings(excludedTeamNames: Array<String>){
        var miniStandingsTable : Array<TeamObject> = Array<TeamObject>()
        for match in self.matches {
            if !excludedTeamNames.contains(match.homeTeam.teamName) && !excludedTeamNames.contains(match.awayTeam.teamName) {
                
                var homeTeam : TeamObject? = miniStandingsTable.findTeam(match.homeTeam.teamName) as? TeamObject
                if homeTeam == nil  {
                    homeTeam = TeamObject(teamName: match.homeTeam.teamName, flagName: "", worldRanking: 0, position: 0) as TeamObject
                    miniStandingsTable.append(homeTeam!)
                }
                
                var awayTeam : TeamObject? = miniStandingsTable.findTeam(match.awayTeam.teamName) as? TeamObject
                if awayTeam == nil {
                    awayTeam = TeamObject(teamName: match.awayTeam.teamName, flagName: "", worldRanking: 0, position: 0)
                    miniStandingsTable.append(awayTeam!)
                }
                
                homeTeam!.goalsAgainst += match.awayTeamGoals
                awayTeam!.goalsAgainst += match.homeTeamGoals
                
                homeTeam!.goalsFor += match.homeTeamGoals
                awayTeam!.goalsFor += match.awayTeamGoals
                
                if match.homeTeamGoals == match.awayTeamGoals {
                    homeTeam!.drawn += 1
                    awayTeam!.drawn += 1
                }else if match.homeTeamGoals > match.awayTeamGoals {
                    homeTeam!.won += 1
                    awayTeam!.lost += 1
                }else {
                    homeTeam!.lost += 1
                    awayTeam!.won += 1
                }
            }
        }
    
        miniStandingsTable = miniStandingsTable.sort({
            if $0.points == $1.points {
                if $0.goalDiff == $1.goalDiff {
                    if $0.goalsFor == $1.goalsFor {
                        let random : Int = Int(arc4random_uniform(UInt32(100)))
                        return (random % 2) == 0 ? true : false
                    }else {
                        return $0.goalsFor > $1.goalsFor
                    }
                }else {
                    return $0.goalDiff > $1.goalDiff
                }
            }else {
                return $0.points > $1.points
            }
        })
        
        for team in miniStandingsTable {
            //print("m \(team.teamName) w:\(team.won) d:\(team.drawn) l:\(team.lost) gf:\(team.goalsFor) ga:\(team.goalsAgainst) gd:\(team.goalDiff) pts:\(team.points) pos:\(team.currentPosition)")
            let originalTeam : TeamObject = self.teams.findTeam(team.teamName) as! TeamObject
            originalTeam.positionInMiniTable = miniStandingsTable.indexOf(team)!
        }
    }
    
    private func generateTeam(teamName: String, flagName: String, worldRanking: Int, position: Int ) -> TeamObject {
        
        let team : TeamObject = TeamObject(teamName: teamName, flagName: flagName, worldRanking: worldRanking, position: position)
        
        let keeper : Goalkeeper = Goalkeeper(name: "keeper", age: self.generateAge(), passingSkill: self.generateSkill(worldRanking), keepingSkill: self.generateSkill(worldRanking))
        keeper.teamDelegate = team
        
        team.goalKeeper = keeper
        
        var defenders : Array<Defender> = Array<Defender>()
        for var i = 0; i<4; ++i {
            let defender : Defender = Defender(name: "defender\(i)", age: self.generateAge(), passingSkill: self.generateSkill(worldRanking), defendingSkill: self.generateSkill(worldRanking), attackingSkill: self.generateSkill(worldRanking))
            defender.teamDelegate = team
            defenders.append(defender)
        }
        
        team.defenders = defenders
        
        var midfielders : Array<Midfielder> = Array<Midfielder>()
        for var i = 0; i<4; ++i {
            let midfielder : Midfielder = Midfielder(name: "mf\(i)", age: self.generateAge(), passingSkill: self.generateSkill(worldRanking), defendingSkill: self.generateSkill(worldRanking), attackingSkill: self.generateSkill(worldRanking))
            midfielder.teamDelegate = team
            midfielders.append(midfielder)
        }
        
        team.midfielders = midfielders
        
        var strikers : Array<Striker> = Array<Striker>()
        for var i = 0; i<2; ++i {
            let striker : Striker = Striker(name: "striker\(i)", age: self.generateAge(), passingSkill: self.generateSkill(worldRanking), defendingSkill: self.generateSkill(worldRanking), attackingSkill: self.generateSkill(worldRanking))
            striker.teamDelegate = team
            strikers.append(striker)
        }
        
        team.strikers = strikers
        
        return team
    }
    
    
}

private extension Array {
    func findTeam(name : String) -> Any? {
        for (_,element) in self.enumerate() {
            if let team = element as? TeamObject {
                if team.teamName == name {
                    return element
                }
            }
        }
        return nil
    }
}