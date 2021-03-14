//
//  GameOverScene.swift
//  disappearing-discs
//
//  Created by Rick Brown on 14/03/2021.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
  let playClickSound = SKAction.playSoundFileNamed("Click.wav", waitForCompletion: false)
  
  override func didMove(to view: SKView) {
    let background = SKSpriteNode(imageNamed: "DiscsBackground")
    background.size = self.size
    background.zPosition = ZPosition.background
    background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    self.addChild(background)
    
    let gameOverLabel = CustomLabelNode("Game Over", size: 140, percentageFromTop: 25)
    self.addChild(gameOverLabel)
    
    let finalScoreLabel = CustomLabelNode("Score: \(scoreNumber)", size: 70, percentageFromTop: 40)
    self.addChild(finalScoreLabel)
    
    // create an instance of UserDefaults
    let defaults = UserDefaults()
    // retrieve any existing high score (this will return zero, if there isnt an entry already)
    var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
    // if the most recent score is higher than the current highest score, set the new high score
    if scoreNumber > highScoreNumber {
      highScoreNumber = scoreNumber
      defaults.set(highScoreNumber, forKey: "highScoreSaved")
    }
    
    let highScoreLabel = SKLabelNode(fontNamed: customFont)
    highScoreLabel.text = "Highest Score: \(highScoreNumber)"
    highScoreLabel.fontSize = 70
    highScoreLabel.fontColor = .white
    highScoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    highScoreLabel.zPosition = ZPosition.label
    self.addChild(highScoreLabel)
    
    let restartLabel = CustomLabelNode("Restart", size: 75, percentageFromTop: 70)
    restartLabel.name = "restart button"
    self.addChild(restartLabel)

    let exitLabel = SKLabelNode(fontNamed: customFont)
    exitLabel.text = "Exit"
    exitLabel.fontSize = 75
    exitLabel.fontColor = .white
    exitLabel.zPosition = ZPosition.label
    exitLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.2)
    exitLabel.name = "exit button"
    self.addChild(exitLabel)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch: AnyObject in touches {
      let pointOfTouch = touch.location(in: self)
      let tappedNode = atPoint(pointOfTouch)
      let tappedNodeName = tappedNode.name
      
      if tappedNodeName == "restart button" {
        self.run(playClickSound)
        let sceneToMoveTo = GameScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let sceneTransition = SKTransition.fade(withDuration: 0.2)
        self.view!.presentScene(sceneToMoveTo, transition: sceneTransition)
      }
      
      if tappedNodeName == "exit button" {
        self.run(playClickSound)
        let sceneToMoveTo = MainMenuScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let sceneTransition = SKTransition.fade(withDuration: 0.2)
        self.view!.presentScene(sceneToMoveTo, transition: sceneTransition)
      }
    }
  }
}
