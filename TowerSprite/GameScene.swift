//
//  GameScene.swift
//  TowerSprite
//
//  Created by Student User on 10/23/20.
//  Copyright © 2020 Student User. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var bigBlock = SKSpriteNode()
    var mediumBlock = SKSpriteNode()
    var smallBlock = SKSpriteNode()
    
    var touchedNode: SKNode?
    
    var movesMenu = SKLabelNode()
    var winLabel = SKLabelNode()
    var warningLabel = SKLabelNode()
    var numMovesLabel = SKLabelNode()
    
    let model = TowerModel()
    
    var previousLocation: CGPoint = CGPoint(x: 0, y: 0)
    
    override func didMove(to view: SKView) {
        bigBlock = self.childNode(withName: "bigBlock") as! SKSpriteNode
        mediumBlock = self.childNode(withName: "mediumBlock") as! SKSpriteNode
        smallBlock = self.childNode(withName: "smallBlock") as! SKSpriteNode
        movesMenu = self.childNode(withName: "movesMenu") as! SKLabelNode
        winLabel = self.childNode(withName: "winLabel") as! SKLabelNode
        warningLabel = self.childNode(withName: "warningLabel") as! SKLabelNode
        numMovesLabel = self.childNode(withName: "numMovesLabel") as! SKLabelNode
        
        numMovesLabel.isHidden = true
        warningLabel.isHidden = true
        winLabel.isHidden = true
        winLabel.text = "YOU WON"
        warningLabel.text = "Try Again!"
        movesMenu.text = "Moves: 0"
        
        self.backgroundColor = .black
        self.scaleMode = .aspectFit
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        physicsWorld.gravity = CGVector(dx: 0, dy: -1.62)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            touchedNode = atPoint(location)
            previousLocation = location
            if [bigBlock, mediumBlock, smallBlock].contains(touchedNode) {
                guard var block = [smallBlock, mediumBlock, bigBlock].firstIndex(of: touchedNode)
                    else { return print("UNEXPECTED: TouchedNode not in list")}
                block += 1
                let tower = Int((location.x + 640) / 1280 * 3)
                if block == model.peek(tower) { //did they touch the top block?
                    model.pickUp(tower)
                    movesMenu.text = "Moves: \(model.getMoves()+1)"
                    warningLabel.isHidden = true
                } else {
                    touchedNode = nil
                }
            } else {
                touchedNode = nil
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            touchedNode?.position = location
            let tower = Int((location.x + 640) / 1280 * 3)
            print(tower)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let tower = Int((location.x + 640) / 1280 * 3)
            model.dropDown(tower)
            if model.getIllegalMove() {
                warningLabel.isHidden = false
                touchedNode?.position = previousLocation
                model.addMoves()
            }
            print(model.showData())
            touchedNode = nil
        }
    }
    override func update(_ currentTime: TimeInterval) {
        model.checkWin()
        if model.getWinState() {
            movesMenu.isHidden = true
            numMovesLabel.isHidden = false
            winLabel.isHidden = false
            numMovesLabel.text = "In \(model.getMoves()) moves!"
        }
    }
}
