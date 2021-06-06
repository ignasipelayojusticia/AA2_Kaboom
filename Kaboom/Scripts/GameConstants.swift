//
//  GameConstants.swift
//  Kaboom
//
//  Created by Alumne on 20/5/21.
//

import Foundation
import SpriteKit

enum CategoryBitMasks {
    static let playerBitMask: UInt32 = UInt32(1)
    static let bombEndBitMask: UInt32 = UInt32(2)
    static let bombBitMask: UInt32 = UInt32(4)
    static let noCollisionBitMask: UInt32 = UInt32(6)
}

let bombValue = 10
var currentWoodenPlankLevel = 2
