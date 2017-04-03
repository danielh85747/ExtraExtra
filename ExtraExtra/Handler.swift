//
//  Handler.swift
//  ExtraExtra
//
//  Created by Daniel Stephenson on 2017-04-02.
//  Copyright © 2017 apple user. All rights reserved.
//

import Foundation
import GameKit

class Handler {
    
    var highScore: Int
    
    var score: Int
    
    class var shared: Handler {
        
        struct Singleton {
            
            static let instance = Handler()
            
        }
        
        return Singleton.instance
        
    }
    
    init() {
        
        highScore = 0
        score = 0
        
        let gameDefaults = UserDefaults.standard
        
        highScore = gameDefaults.integer(forKey: "highscore")
        
    }
    
    func saveStats() {
        
        let gameDefaults = UserDefaults.standard
        
        
        
    
            
        highScore = max(score, highScore)
        
        gameDefaults.set(highScore, forKey: "highscore")
        gameDefaults.synchronize()
        
        if GKLocalPlayer.localPlayer().isAuthenticated {
            // Submit score to GC leaderboard
            let bestScoreInt = GKScore(leaderboardIdentifier: "grp.com.demo.ExtraExtra")
            bestScoreInt.value = Int64(highScore)
            GKScore.report([bestScoreInt]) { (error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Best Score submitted to your Leaderboard!")
                }
            }
        }
        
        
    }
    
}
