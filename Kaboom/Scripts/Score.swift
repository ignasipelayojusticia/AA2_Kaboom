//
//  Score.swift
//  Kaboom
//
//  Created by Alumne on 26/5/21.
//

import Foundation
import SpriteKit

class Score: SKLabelNode {

    private let scoreText: String = ""
    public var currentScore: Int = 0
    private var currentHundred: Int = 0

    override init() {

        super.init()

        fontName = "SlapAndCrumbly"
        position = CGPoint(x: 0, y: GameConfiguration.gameHeight / 2 - 100)
        horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        fontSize *= 3
        fontColor = SKColor.white

        text = scoreText + String(currentScore)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func addScore(scoreToAdd: Int) -> Bool {

        let actualScoreToAdd = scoreToAdd * difficulty.values().multiplier
        currentScore += actualScoreToAdd
        text = scoreText + String(currentScore)

        fontColor = SKColor.green
        let scoreMessage = ScoreMessage(position: CGPoint(x: GameConfiguration.gameWidth / 8, y: 40),
                                        points: actualScoreToAdd, color: SKColor.green)
        addChild(scoreMessage)

        if Int(currentScore / 100) > currentHundred && actualScoreToAdd < 100 {
            currentHundred = Int(currentScore / 100)
            return true
        }

        return false
    }

    public func substractScore(scoreToSubstract: Int) {

        var actualScoreToSubstract = scoreToSubstract
        if currentScore < actualScoreToSubstract {
            actualScoreToSubstract = currentScore
        }
        currentScore -= actualScoreToSubstract

        fontColor = SKColor.red
        text = scoreText + String(currentScore)
        let scoreMessage = ScoreMessage(position: CGPoint(x: GameConfiguration.gameWidth / 8, y: 40),
                                        points: -actualScoreToSubstract, color: SKColor.red)
        addChild(scoreMessage)
    }
}

class ScoreMessage: SKLabelNode {

    let animationDuration: Double = 0.75

    init(position: CGPoint, points: Int, color: SKColor) {

        super.init()

        fontName = "SlapAndCrumbly"
        self.position = position
        fontSize *= 1.3
        fontColor = color
        text = points > 0 ? "+" + String(points) : String(points)

        run(SKAction.fadeOut(withDuration: animationDuration))
        run(SKAction.move(by: CGVector(dx: 50, dy: 25), duration: animationDuration), completion: removeFromParent)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
