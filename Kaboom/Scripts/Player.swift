//
//  Player.swift
//  Kaboom
//
//  Created by Alumne on 11/5/21.
//

import Foundation
import SpriteKit

class Player : SKNode {

    public var lives: [WoodenPanel]
    private let maximumLives: Int = 3

    override init() {

        lives = [WoodenPanel]()
        super.init()

        for number in 0...(maximumLives - 1){
            lives.append(WoodenPanel(playerReference: self, numberOnPlayer: number, image: "player"))
            self.addChild(lives[number])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WoodenPanel : SKSpriteNode {

    private var player: Player

    init(playerReference: Player, numberOnPlayer: Int, image: String) {
        
        player = playerReference
        
        let texture = SKTexture(imageNamed: image)
        
        super.init(texture: texture, color: .clear, size: CGSize(width: 98, height: 28))
        self.position = CGPoint(x: 0, y: 0 + numberOnPlayer * 45)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
