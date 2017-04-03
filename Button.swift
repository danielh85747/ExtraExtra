//
//  SaveScoreButton.swift
//  ExtraExtra
//
//  Created by apple user on 2017-03-13.
//  Copyright © 2017 apple user. All rights reserved.
//

import SpriteKit

class Button: SKNode {
    
    
    var button: SKSpriteNode!
    var activeButton: SKSpriteNode!
    var action: () -> Void
    
    init(buttonUnpressedImage: String, buttonPressedImage: String, buttonAction: @escaping () -> Void) {
        
        button = SKSpriteNode(imageNamed: buttonUnpressedImage)
        activeButton = SKSpriteNode(imageNamed: buttonPressedImage)
        activeButton.isHidden = true
        action = buttonAction
        
        super.init()
        
        isUserInteractionEnabled = true
        addChild(button)
        addChild(activeButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeButton.isHidden = false
        button.isHidden = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject = touches.first!
        let touchLocation = touch.location(in: self)
        
        if button.contains(touchLocation) {
            activeButton.isHidden = false
            button.isHidden = true
        } else {
            activeButton.isHidden = true
            button.isHidden = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject = touches.first!
        let touchLocation = touch.location(in: self)
        
        if button.contains(touchLocation) {
         action()
        }
        
        activeButton.isHidden = true
        button.isHidden = false
        
    }
    
    
}
