//
//  GameScene.swift
//  ExtraExtra
//
//  Created by apple user on 2017-03-09.
//  Copyright © 2017 apple user. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit
import Firebase
import GoogleMobileAds
// Credit for sound effects go to http://www.freesfx.co.uk
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate, UITextFieldDelegate, GKGameCenterControllerDelegate, GADBannerViewDelegate {
    
    var gameAudio = AVAudioPlayer()
    
    var gameSounds = ["shattering", "throwing"]
    
    var paper = SKSpriteNode()
    
    var back = SKSpriteNode()
    
    var mainTitle = SKSpriteNode()
    
    var instructions = SKSpriteNode()
    
    var instructions2 = SKSpriteNode()
    
    var gameOverLabel = SKSpriteNode()
    
    var playAgain = SKSpriteNode()
    
    var scoreLabel = SKLabelNode()
    
    var highScoreLabel = SKLabelNode()
    
    let gameDefaults = UserDefaults.standard
    
    var sounds: Button!
    
    var howTo: Button!
    
    var enterScore: Button!
    
    var quitGameButton: Button!
    
    var soundOff = false
    
    var gameOver = false
    
    var paperClock = Timer()
    
    var window = SKSpriteNode()
    
    var adBanner: GADBannerView?
    
    override init(size: CGSize) {
        super.init(size: size)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func makeWindows() {
        
        let moveGlass = SKAction.move(by: CGVector(dx: 0, dy: -4 * self.frame.height) , duration: TimeInterval(self.frame.height / 100))
        let removeGlass = SKAction.removeFromParent()
        let moveAndRemoveGlass = SKAction.sequence([moveGlass, removeGlass])
        
        let windowText = SKTexture(imageNamed: "Window.png")
        
        window = SKSpriteNode(texture: windowText)
        
        let glassPositions = arc4random() % UInt32(self.frame.width)
        let glassPoint = CGFloat(glassPositions) - self.frame.width / 2
        
        window.position = CGPoint(x: self.frame.midX / 2 - windowText.size().width / 2 + glassPoint, y: self.frame.midY + self.frame.height / 2 + glassPoint)
        
        window.zPosition = -1
        
        window.run(moveAndRemoveGlass)
        
        window.physicsBody = SKPhysicsBody(circleOfRadius: windowText.size().height / 32)
        window.physicsBody?.isDynamic = false
        
        window.physicsBody?.contactTestBitMask = Contact.Paper.rawValue
        window.physicsBody?.categoryBitMask = Contact.Window.rawValue
        window.physicsBody?.collisionBitMask = Contact.Paper.rawValue
        
        self.addChild(window)
        
        
    }
    
    enum Contact: UInt32 {
        
        case Paper = 1
        case Window = 3
        case Object = 4
        
    }
    
    func soundControl() { 
        
        if soundOff == false {
            soundOff = true
            gameDefaults.set(soundOff, forKey: "sound")
        } else {
            soundOff = false
            gameDefaults.set(soundOff, forKey: "sound")
        }
        
    }
    
    
    
    func setGame() {
        
        
        paperClock = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(makeWindows), userInfo: nil, repeats: true)
        
        // The background of the game
        let background = SKTexture(imageNamed: "Background.png")
        
        mainTitle = SKSpriteNode(imageNamed: "ExtraExtra.png")
        
        mainTitle.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 160)
        
        soundOff = gameDefaults.bool(forKey: "sound")
        
        if soundOff == false {
            sounds = Button(buttonUnpressedImage: "Sound-on.png", buttonPressedImage: "Sound-off.png", buttonAction: soundControl)
        } else {
            sounds = Button(buttonUnpressedImage: "Sound-off.png", buttonPressedImage: "Sound-on.png", buttonAction: soundControl)
        }
        sounds.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 240)
        
        sounds.zPosition = 1
        
        howTo = Button(buttonUnpressedImage: "instructions.png", buttonPressedImage: "instructions.png", buttonAction: insruct)
        howTo.position = CGPoint(x: self.frame.midX + 170, y: self.frame.midY - 275)
        
        self.addChild(sounds)
        
        self.addChild(howTo)
        
        self.addChild(mainTitle)
        
        // The background animation
        let moveBGAnimation = SKAction.move(by: CGVector(dx: 0, dy: -background.size().height), duration: 8)
        let shiftBackground = SKAction.move(by: CGVector(dx: 0, dy: background.size().height), duration: 0)
        let moveBGForever = SKAction.repeatForever(SKAction.sequence([moveBGAnimation, shiftBackground]))
        
        var i: CGFloat = 0
        
        // Creates a loop for the background animation to continue
        while i < 300 {
            
            back = SKSpriteNode(texture: background)
            
            back.run(moveBGForever)
            
            back.position = CGPoint(x: self.frame.midX, y: background.size().height * i)
            back.zPosition = -2
            
            back.size.width = self.frame.width
            
            self.addChild(back)
            
            i += 1
            
        }
        
        let paperText = SKTexture(imageNamed: "newspaper.png")
        
        paper = SKSpriteNode(texture: paperText)
        
        paper.physicsBody = SKPhysicsBody(rectangleOf: paperText.size())
        
        paper.physicsBody?.isDynamic = false
        
        
        
        paper.physicsBody?.contactTestBitMask = Contact.Window.rawValue
        paper.physicsBody?.categoryBitMask = Contact.Paper.rawValue
        paper.physicsBody?.collisionBitMask = Contact.Window.rawValue
        
        paper.position = CGPoint(x: self.frame.midX, y: self.frame.midY - paperText.size().height - 20)
        
        self.addChild(paper)
        
        let ground = SKNode()
        
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        
        ground.physicsBody?.isDynamic = false
        
        ground.physicsBody?.contactTestBitMask = Contact.Paper.rawValue
        ground.physicsBody?.categoryBitMask = Contact.Object.rawValue
        ground.physicsBody?.collisionBitMask = Contact.Paper.rawValue
        
        self.addChild(ground)
        
        scoreLabel.fontName = "PingFang TC Ultralight"
        
        scoreLabel.fontSize = 30
        
        scoreLabel.fontColor = SKColor.blue
        
        scoreLabel.text = "0"
        
        scoreLabel.position = CGPoint(x: self.frame.midX - 120, y: self.frame.midY + 240)
        
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        
        self.addChild(scoreLabel)

        
        initializeBanner()
        
        adBanner?.isHidden = false
        
        
    }
    
    override func didMove(to view: SKView) {
        
        setGame()
        
        self.physicsWorld.contactDelegate = self
        
        initializeBanner()
        
        adBanner?.isHidden = false
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if gameOver == false {
            
            if contact.bodyA.collisionBitMask == Contact.Window.rawValue {
                
                let shatter = Bundle.main.path(forResource: gameSounds[0], ofType: "mp3")
                
                if soundOff == false {
                    do {
                        try gameAudio = AVAudioPlayer(contentsOf: URL(fileURLWithPath: shatter!))
                        gameAudio.play()
                    } catch {
                        print("No shattering!")
                    }
                }
                
                window.removeFromParent()
                
                Handler.shared.score += 25
                
                scoreLabel.text = "\(Handler.shared.score)"
                
            }
            

                
                if paper.position.x > self.frame.midX + 80 || paper.position.x < -80 || paper.position.y < self.frame.midY - 60 {
                    
                    gameOver = true
                    
                    paperClock.invalidate()
                    
                    saveScoreData()
                    
                    highScoreLabel.fontName = "PingFang TC Ultralight"
                    
                    highScoreLabel.fontSize = 30
                    
                    highScoreLabel.fontColor = SKColor.blue

                    highScoreLabel.text = "Best Score: \(Handler.shared.highScore)"
                    
                    highScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 180)
                    
                    gameOverLabel = SKSpriteNode(imageNamed: "Game-Over.png")
                    
                    gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 60)
                    
                    
                    quitGameButton = Button(buttonUnpressedImage: "Leaderboard.png", buttonPressedImage: "Leaderboard.png", buttonAction: leaderBoards)
                    
                    quitGameButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 20)
                    
                    playAgain = SKSpriteNode(imageNamed: "Tap-to-play-again.png")
                    
                    playAgain.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 120)
                    
                    self.addChild(highScoreLabel)
                    
                    self.addChild(playAgain)
                    
                    self.addChild(quitGameButton)
                    
                    self.addChild(gameOverLabel)
                    
                    
                }
                
            
            
            
            
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    func leaderBoards() {
        let viewControllerVar = self.view?.window?.rootViewController
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = "grp.com.demo.ExtraExtra"
        viewControllerVar?.present(gcVC, animated: true, completion: nil)

        
    }
    
    func initializeBanner() {
        
        let gameView = self.view?.window?.rootViewController
        
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        adBanner = GADBannerView(frame: CGRect(x: 0, y: 0, width: (self.view?.frame.size.width)!, height: 50))
        adBanner?.delegate = self
        adBanner?.adUnitID = "ca-app-pub-9526056729068340/5802794719"
        adBanner?.isHidden = false
        adBanner?.rootViewController = gameView
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID, "e683584f2085bb1bd316175befd3ef8b"]
        
        adBanner?.load(request)
        view?.addSubview(adBanner!)
        
        
    }
    
    
    
    func insruct() {
        
        mainTitle.removeFromParent()
        
        instructions = SKSpriteNode(imageNamed: "Tap-to-throw-newspaper-a.png")
        
        instructions.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 50)
        
        instructions2 = SKSpriteNode(imageNamed: "Do-your-best-to-avoid-go.png")
        
        instructions2.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 60)
        
        self.addChild(instructions2)
        
        self.addChild(instructions)
    }
    
    
    
    func saveScoreData() {
        
      Handler.shared.saveStats()
        
    }
    
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameOver == false {
            
            mainTitle.removeFromParent()
            howTo.removeFromParent()
            instructions.removeFromParent()
            instructions2.removeFromParent()
            
            if soundOff == false {
                let paperThrow = Bundle.main.path(forResource: gameSounds[1], ofType: "mp3")
                do{
                    try gameAudio = AVAudioPlayer(contentsOf: URL(fileURLWithPath: paperThrow!))
                    gameAudio.play()
                }catch {
                    print("No throwing!")
                }
            } 
            
            paper.physicsBody?.isDynamic = true
            paper.physicsBody?.velocity = CGVector(dx: 0, dy: 60)
            paper.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 600))
            
            let paperSpin = SKAction.rotate(byAngle: 9, duration: 2)
            let moveSpin = SKAction.repeatForever(paperSpin)
            paper.run(moveSpin)
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeGame(gesture:)))
            swipeLeft.direction = UISwipeGestureRecognizerDirection.left
            self.view?.addGestureRecognizer(swipeLeft)
            
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeGame(gesture:)))
            swipeRight.direction = UISwipeGestureRecognizerDirection.right
            self.view?.addGestureRecognizer(swipeRight)
            
        } else {
            
            gameOver = false
            
            Handler.shared.score = 0
            
            self.removeAllChildren()
            
            setGame()
    
            
            mainTitle.removeFromParent()
            howTo.removeFromParent()
            instructions.removeFromParent()
            
            
        }
        
        
    }
    
    
    
    func swipeGame(gesture: UIGestureRecognizer) {
        
        if let gameGest = gesture as? UISwipeGestureRecognizer {
            
            switch gameGest.direction {
            case UISwipeGestureRecognizerDirection.right:
                
                if soundOff == false {
                    let paperThrow = Bundle.main.path(forResource: gameSounds[1], ofType: "mp3")
                    do{
                        try gameAudio = AVAudioPlayer(contentsOf: URL(fileURLWithPath: paperThrow!))
                        gameAudio.play()
                    }catch {
                        print("No throwing!")
                    }
                }
                
                paper.physicsBody?.isDynamic = true
                paper.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                paper.physicsBody?.applyImpulse(CGVector(dx: 1000, dy: 0))
                
                let paperSpin = SKAction.rotate(byAngle: 9, duration: 2)
                 let moveSpin = SKAction.repeatForever(paperSpin)
                 paper.run(moveSpin)
                
            case UISwipeGestureRecognizerDirection.left:
                
                if soundOff == false {
                    let paperThrow = Bundle.main.path(forResource: gameSounds[1], ofType: "mp3")
                    do{
                        try gameAudio = AVAudioPlayer(contentsOf: URL(fileURLWithPath: paperThrow!))
                        gameAudio.play()
                    }catch {
                        print("No throwing!")
                    }
                }
                
                paper.physicsBody?.isDynamic = true
                paper.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                paper.physicsBody?.applyImpulse(CGVector(dx: -1000, dy: 0))
                
                let paperSpin = SKAction.rotate(byAngle: -9, duration: 2)
                 let moveSpin = SKAction.repeatForever(paperSpin)
                 paper.run(moveSpin)
            default:
                break
            }
            
        }
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    /**/
}

extension Notification.Name {
    static let showBannerAd = Notification.Name(rawValue: "ExtraExtra Promo")
}

