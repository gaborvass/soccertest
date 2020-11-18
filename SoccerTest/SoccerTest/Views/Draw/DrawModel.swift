//
//  DrawModel.swift
//  SoccerTest
//
//  Created by Gábor Vass on 18/11/2020.
//

import Foundation

class DrawModel {

    var teams: [TeamObject] = []
    var onTeamGenerated: ((TeamObject, Int) -> Void)?

    func startDraw() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            if self.teams.count == 4 {
                timer.invalidate()
                return
            }
            self.generateTeam(self.teams.count)
        })
    }

    private func generateTeam(_ teamIndex: Int) {
        var generatedTeam: TeamObject?
        switch teamIndex {
        case 0:
            generatedTeam = TeamObject(teamName: "Spain", flagName: "spain", worldRanking: 99, position: teamIndex)
        case 1:
            generatedTeam = TeamObject(teamName: "Netherlands", flagName: "netherlands", worldRanking: 99, position: teamIndex)
        case 2:
            generatedTeam = TeamObject(teamName: "Chile", flagName: "chile", worldRanking: 99, position: teamIndex)
        case 3:
            generatedTeam = TeamObject(teamName: "Australia", flagName: "australia", worldRanking: 99, position: teamIndex)
        default:
            break
        }
        if let team = generatedTeam {
            self.teams.append(team)
            self.onTeamGenerated?(team, (self.teams.count - 1))
        }
    }
}
