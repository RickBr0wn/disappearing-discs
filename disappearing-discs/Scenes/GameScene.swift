//
//  GameScene.swift
//  disappearing-discs
//
//  Created by Rick Brown on 14/03/2021.
//

import SpriteKit
import GameplayKit

// MARK: ZPostion
struct ZPosition {
  static let background: CGFloat = 0.0
  static let label: CGFloat = 1.0
  static let disc: CGFloat = 2.0
  static let blank_2: CGFloat = 3.0
  static let blank_3: CGFloat = 4.0
}

// MARK: Name
struct Name {
  static let disc: String = "discObject"
  static let blank: String = ""
}

class GameScene: SKScene {
  // MARK: global variables
  var scoreNumber: Int = 0
  var scoreLabel = SKLabelNode(fontNamed: "Pusab")
  let playCorrectSoundEffect = SKAction.playSoundFileNamed("Correct.wav", waitForCompletion: false)
  let playClickSoundEffect = SKAction.playSoundFileNamed("Click.wav", waitForCompletion: false)
  let gameArea: CGRect
  
  override init(size: CGSize) {
    let maxAspectRatio: CGFloat = 16.0 / 9.0
    let playableWidth = size.height / maxAspectRatio
    let gameAreaMargin = (size.width - playableWidth) / 2
    gameArea = CGRect(x: gameAreaMargin, y: 0, width: playableWidth, height: size.height)
    super.init(size: size)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: random
  func random() -> CGFloat {
    CGFloat(Float(arc4random()) / Float(0xFFFFFFFF))
  }
  
  func random(min: CGFloat, max: CGFloat) -> CGFloat {
    random() * (max - min) + min
  }
  
  // MARK: didMove(to view: )
  override func didMove(to view: SKView) {
    // MARK: background
    let background = SKSpriteNode(imageNamed: "DiscsBackground")
    background.size = self.size
    background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    background.zPosition = ZPosition.background
    self.addChild(background)
    
    // MARK: disc
    let disc = SKSpriteNode(imageNamed: "Disc2")
    disc.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    disc.zPosition = ZPosition.disc
    disc.name = Name.disc
    self.addChild(disc)
    
    // MARK: score
    scoreLabel.fontSize = 250
    scoreLabel.text = "0"
    scoreLabel.fontColor = .white
    scoreLabel.zPosition = ZPosition.label
    scoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.85)
    self.addChild(scoreLabel)
  }
  
  // MARK: spawnNewDisc
  func spawnNewDisc() -> Void {
    var randomImageNumber = arc4random()%4
    randomImageNumber += 1
    
    let disc = SKSpriteNode(imageNamed: "Disc\(randomImageNumber)")
    disc.zPosition = ZPosition.disc
    disc.name = Name.disc
    
    let randomX = random(
      min: gameArea.minX + (disc.size.width / 2),
      max: gameArea.maxX - (disc.size.width / 2)
    )
    let randomY = random(
      min: gameArea.minY + (disc.size.height / 2),
      max: gameArea.maxY - (disc.size.height / 2)
    )
    disc.position = CGPoint(x: randomX, y: randomY)
    
    self.addChild(disc)
  }
  
  // MARK: touchesBegan
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch: AnyObject in touches {
      // where the screen was touched
      let positionOfTouch = touch.location(in: self)
      // was an object touched
      let tappedNode = atPoint(positionOfTouch)
      // get the nodes 'name'
      let nameOfTappedNode = tappedNode.name
      // conditional on name to check for disc
      if nameOfTappedNode == Name.disc {
        // this closure runs when a disc has been touched
        // set the name to blank, preventing multiple clicks of the same node
        tappedNode.name = Name.blank
        // run the remove sequence
        tappedNode.run(SKAction.sequence([
          SKAction.fadeOut(withDuration: 0.1),
          SKAction.removeFromParent()
        ]))
        // play the 'correct' sound effect
        self.run(playCorrectSoundEffectl)
        // Spawn a new disc
        spawnNewDisc()
        // increment the score
        scoreNumber += 1
        // update the score label
        scoreLabel.text = "\(scoreNumber)"
        // Increment number of discs on the screen at any one time, with basic level system
        if scoreNumber == 10 ||
            scoreNumber == 50 ||
            scoreNumber == 125 ||
            scoreNumber == 200 ||
            scoreNumber == 300 ||
            scoreNumber == 500 {
          spawnNewDisc()
        }
      }
    }
  }
}
