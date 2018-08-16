//
//  Dice.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 09.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation

class Dice {
    static func rollDice(_ type:typeDice) -> Double {
        return Double(arc4random_uniform(19) + 1)
    }
}

enum typeDice:Int {
    case six = 5, twenty = 19, fifty = 49
}
