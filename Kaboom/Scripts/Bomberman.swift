//
//  Bomberman.swift
//  Kaboom
//
//  Created by Alumne on 13/5/21.
//

import Foundation
import SpriteKit

class Bomberman: SKSpriteNode {
    
    private let bomb: Bomb
    
    private var moveDuration: Double = 0.5
    public var desiredPosition: CGPoint

    init() {

        desiredPosition = CGPoint(x: 0, y: GameConfiguration.gameHeight / 2  - 300)
        bomb = Bomb(inititalPosition: CGPoint(x: 0, y: -40))

        super.init(texture: SKTexture(imageNamed: "bomberman"), color: .clear, size: CGSize(width: 60, height: 116))
        
        position = desiredPosition
        
        self.addChild(bomb)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Bomb: SKSpriteNode {
    
    init(inititalPosition: CGPoint) {

        super.init(texture: SKTexture(imageNamed: "bomb_3"), color: .clear, size: CGSize(width: 40, height: 45))
        
        position = inititalPosition
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
