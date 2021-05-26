//
//  Score.swift
//  Kaboom
//
//  Created by Alumne on 26/5/21.
//

import Foundation
import SpriteKit

class Score: SKLabelNode {

    private let scoreText: String = "SCORE: "
    private var currentScore: Int = 0

    override init() {

        super.init()

        position = CGPoint(x: 0, y: GameConfiguration.gameHeight / 2 - 100)
        horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        fontSize *= 2
        addScore(scoreToAdd: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addScore(scoreToAdd: Int) {

        currentScore += scoreToAdd
        text = scoreText + String(currentScore)
    }
}