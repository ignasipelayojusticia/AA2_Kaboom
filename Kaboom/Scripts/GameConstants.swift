//
//  GameConstants.swift
//  Kaboom
//
//  Created by Alumne on 20/5/21.
//

import Foundation
import SpriteKit

enum GameConfiguration {
    static let gameWidth: CGFloat = 750
    static let gameHeight: CGFloat = 1334
}

enum CategoryBitMasks {
    static let playerBitMask: UInt32 = UInt32(1)
    static let bombEndBitMask: UInt32 = UInt32(2)
    static let bombBitMask: UInt32 = UInt32(4)
    static let noCollisionBitMask: UInt32 = UInt32(6)
}

let bombValue = 1
let redBombValue = 50
var currentWoodenPlankLevel = 2
