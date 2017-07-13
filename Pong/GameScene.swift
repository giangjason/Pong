//
//  GameScene.swift
//  Pong
//
//  Created by Jason Giang on 11/8/16.
//  Copyright © 2016 Jason Giang. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    
    // Creates referance variables of all items on screen
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var main = SKSpriteNode()
    
    var score = [Int]()
    
    var mainLbl = SKLabelNode()
    var enemyLbl = SKLabelNode()
    
    var Soundplayer = AVAudioPlayer()
    
    
    override func didMove(to view: SKView) {
        
        startGame()
        
        do {
            Soundplayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "pong", ofType: "wav")!))
            Soundplayer.prepareToPlay()
        }
        catch {
            print(error)
        }

        
        mainLbl = self.childNode(withName: "mainLabel") as! SKLabelNode
        enemyLbl = self.childNode(withName: "enemyLabel") as! SKLabelNode
        
        ball = self.childNode(withName: "ball") as! SKSpriteNode        //Initializes all items as
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode      // SKSpriteNodes
        main = self.childNode(withName: "main") as! SKSpriteNode
        
        
        
        ball.physicsBody?.applyImpulse(CGVector(dx: 20, dy: 20))        //Launces the ball at start
        
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)            //Initializes border object
        
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
    }
    
    
    func startGame() {
        score = [0,0]
        mainLbl.text = "\(score[0])"                                    // Displays 0-0 at start, fails to do that
        enemyLbl.text = "\(score[1])"
        
    
        
    }
    
    func addSCore(playerWhoWon: SKSpriteNode) {
        
        ball.position = CGPoint(x: 0, y: 0)                             // Resets the ball to the middle
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)             // Resets the velocity of the ball
        
        if playerWhoWon == main {
            score[0] += 1                                               // Adds 1 to player score
            if score[0] % 2 == 0 {
                ball.physicsBody?.applyImpulse(CGVector(dx: 20, dy: 20))// Shoots ball towards enemy
            }
            else if score[0] % 2 != 0 {
                ball.physicsBody?.applyImpulse(CGVector(dx: -20, dy: 20))               }
            
            
        }
        else if playerWhoWon == enemy {
            score[1] += 1                                               // Adds 1 to enemy score
            if score[1] % 2 == 0 {
                ball.physicsBody?.applyImpulse(CGVector(dx: -20, dy: -20))  // Shoots ball towards player
            }
            else if score[1] % 2 != 0 {
                ball.physicsBody?.applyImpulse(CGVector(dx: 20, dy: -20))
            }
        }
        
        mainLbl.text = "\(score[0])"                                    // Updates score
        enemyLbl.text = "\(score[1])"
    }
    
    
    func randomNumGenerator (firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    
    
    
    // Touch function. Need to review, comment out this block of code to allow autoplay
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            main.run(SKAction.moveTo(x: location.x, duration: 0.2))
        }
    
    }
    
    
    // Touch function, need to review
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            main.run(SKAction.moveTo(x: location.x, duration: 0.2))
        }
    }
 
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
         /* Uncomment to allow autoplay
        let enemyDelay = randomNumGenerator(firstNum: 0.1, secondNum: 1.0)
        let mainDelay = randomNumGenerator(firstNum: 0.1, secondNum: 1.0)
        enemy.run(SKAction.moveTo(x: ball.position.x, duration: TimeInterval(enemyDelay)))
        main.run(SKAction.moveTo(x: ball.position.x, duration: TimeInterval(mainDelay)))
        */
 
        
        enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.2))
        
        if ball.position.y <= main.position.y - 70 {                    // Determines win conditions
            addSCore(playerWhoWon: enemy)
        }
        else if ball.position.y >= enemy.position.y + 70 {
            addSCore(playerWhoWon: main)
        }
        
        if ball.position.y == main.position.y && ball.position.x == main.position.x {
            Soundplayer.play()
            print("sound")
        }
        else if ball.position.y == enemy.position.y && ball.position.x == enemy.position.x {
            Soundplayer.play()
            print("sound")
        }

    }
}


