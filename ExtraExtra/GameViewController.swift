//
//  GameViewController.swift
//  ExtraExtra
//
//  Created by apple user on 2017-03-09.
//  Copyright © 2017 apple user. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import GameplayKit
import GoogleMobileAds


class GameViewController: UIViewController, GADBannerViewDelegate {
    
    var adBanner: GADBannerView?
    
    var gcEnabled: Bool!
    
    var gcDefaultLeaderBoard: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
         let skView = self.view as! SKView
         
         let scene = GameScene(size: skView.bounds.size)
         scene.scaleMode = .aspectFit
         
         skView.presentScene(scene)
        
        /*if let view = self.view as! SKView? {
         // Load the SKScene from 'GameScene.sks'
         if let scene = SKScene(fileNamed: "GameScene") {
         // Set the scale mode to scale to fit the window
         scene.scaleMode = .aspectFill
         
         // Present the scene
         view.presentScene(scene)
         }
         
         view.ignoresSiblingOrder = true
         
         
         }*/
        
        authenticateLocalPlayer()
        
    }
    
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            
            } else {
                print((localPlayer.isAuthenticated))
            }
        }
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return .portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}


