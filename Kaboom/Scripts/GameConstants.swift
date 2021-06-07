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

struct DifficultyValues {
    var index: Int
    var multiplier: Int

    init(indexVariable: Int, multiplierVariable: Int) {
        self.index = indexVariable
        self.multiplier = multiplierVariable
    }
}

enum Difficulty: CaseIterable {
    case easy
    case medium
    case hard

    func values() -> DifficultyValues {
        switch self {
        case Difficulty.easy:
            return DifficultyValues(indexVariable: 1, multiplierVariable: 1)
        case Difficulty.medium:
            return DifficultyValues(indexVariable: 2, multiplierVariable: 2)
        case Difficulty.hard:
            return DifficultyValues(indexVariable: 3, multiplierVariable: 4)
        }
    }
}
var difficulty: Difficulty = Difficulty.easy
