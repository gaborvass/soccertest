//
//  GamebasicsTestTests.swift
//  GamebasicsTestTests
//
//  Created by Vass, Gabor on 17/09/15.
//  Copyright © 2015 Gabor, Vass. All rights reserved.
//

import XCTest


class UnitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        
    }
    
    func testCalculateOrder() {
        let ge = GameEngine()
        
        let team1 = TeamObject(teamName: "ES", flagName:"", worldRanking: 1, position: 0)
        let team2 = TeamObject(teamName: "NL", flagName:"", worldRanking: 1, position: 0)
        let team3 = TeamObject(teamName: "CL", flagName:"", worldRanking: 1, position: 0)
        let team4 = TeamObject(teamName: "AUS", flagName:"", worldRanking: 1, position: 0)
        
        ge.teams.append(team1)
        ge.teams.append(team2)
        ge.teams.append(team3)
        ge.teams.append(team4)
        
        let match1 = MatchObject(homeTeam: team1, awayTeam: team2)
        match1.homeTeamGoals = 0
        match1.awayTeamGoals = 0
        match1.endGame()
        
        let match2 = MatchObject(homeTeam: team3, awayTeam: team4)
        match2.homeTeamGoals = 1
        match2.awayTeamGoals = 0
        match2.endGame()
        
        let match3 = MatchObject(homeTeam: team1, awayTeam: team3)
        match3.homeTeamGoals = 0
        match3.awayTeamGoals = 0
        match3.endGame()

        let match4 = MatchObject(homeTeam: team2, awayTeam: team4)
        match4.homeTeamGoals = 2
        match4.awayTeamGoals = 0
        match4.endGame()

        let match5 = MatchObject(homeTeam: team4, awayTeam: team1)
        match5.homeTeamGoals = 0
        match5.awayTeamGoals = 2
        match5.endGame()

        let match6 = MatchObject(homeTeam: team3, awayTeam: team2)
        match6.homeTeamGoals = 0
        match6.awayTeamGoals = 0
        match6.endGame()

        ge.matches.append(match1)
        ge.matches.append(match2)
        ge.matches.append(match3)
        ge.matches.append(match4)
        ge.matches.append(match5)
        ge.matches.append(match6)
        
        print("Before sort")
        for team in ge.teams {
            print("\(team.teamName) w:\(team.won) d:\(team.drawn) l:\(team.lost) gf:\(team.goalsFor) ga:\(team.goalsAgainst) gd:\(team.goalDiff) pts:\(team.points) pos:\(team.currentPosition)")
        }
        
        print("After sort")
        ge.calculateOrder(3)

        for team in ge.teams {
            print("\(team.teamName) w:\(team.won) d:\(team.drawn) l:\(team.lost) gf:\(team.goalsFor) ga:\(team.goalsAgainst) gd:\(team.goalDiff) pts:\(team.points) pos:\(team.currentPosition)")
        }

    }
    
    
}
