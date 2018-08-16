//
//  Monster.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 06.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation

class Monster {
    var type:eMonster = .slime
    var name:String = ""
    var health = 100
    var mana = 80
    var attack = 10
    var defense = 5
    var baseExp = 10
    
    init(_ type:eMonster, level:Int, mode: eMode) {
        self.type = type
        switch type {
        case .slime:
            name = "Slime"
            health -= 20
            attack -= 5
            defense -= 3
        case .rabbit:
            name = "Evil Rabbit"
            health -= 15
            attack -= 4
            defense -= 4
        case .fox:
            name = "Fox"
            health -= 10
            attack -= 3
            defense -= 3
            baseExp = 12
        case .goblin:
            name = "Goblin"
            health -= 5
            attack -= 1
            defense -= 1
            baseExp = 15
        case .shamanGoblin:
            name = "Shaman Goblin"
            health -= 15
            mana += 20
            attack += 2
            defense -= 3
            baseExp = 17
        case .chiefGoblin:
            name = "Chief Goblin"
            health += 15
            attack += 5
            defense += 3
            baseExp = 18
        case .zombie:
            name = "Zombie"
            health -= 5
            attack += 3
            defense -= 3
            baseExp = 14
        case .ghoul:
            name = "Ghoul"
            health += 5
            defense -= 2
            baseExp = 12
        case .gorilla:
            name = "Gorilla"
            health += 30
            attack += 5
            defense -= 3
            baseExp = 18
        case .tiger:
            name = "Tiger"
            health += 15
            attack += 10
            defense -= 3
            baseExp = 16
        case .minotaur:
            name = "Minotaur"
            health += 15
            attack += 5
            baseExp = 14
        case .gollem:
            name = "Gollem"
            health += 35
            attack -= 3
            defense += 3
            baseExp = 20
        case .swampGollen:
            name = "Swamp Gollen"
            health += 30
            attack -= 5
            defense += 3
            baseExp = 18
        case .skelleton:
            name = "Skelleton"
            health -= 25
            attack += 1
            defense -= 1
            baseExp = 15
        case .mageSkelleton:
            name = "Mage Skelleton"
            health -= 25
            mana += 20
            attack += 3
            defense -= 3
            baseExp = 19
        case .archerSkelleton:
            name = "Archer Skelleton"
            health -= 15
            attack += 5
            defense -= 3
            baseExp = 17
        case .master:
            name = "Master Notorious"
        }
        
        health.incrementByLevel(level)
        health.incrementByMode(mode)
        mana.incrementByLevel(level)
        mana.incrementByMode(mode)
        attack.incrementByLevel(level)
        attack.incrementByMode(mode)
        defense.incrementByLevel(level)
        defense.incrementByMode(mode)
    }
}

class MonsterGenerator {
    static func Generate(level:Int,mode:eMode) -> Monster {
        let monsterId = Int(arc4random_uniform(UInt32(eMonster.count - 1)))
        if mode == .master {
            return Monster(.master, level: level, mode: mode)
        }
        
        return Monster(eMonster(rawValue: monsterId)!, level: level, mode: mode)
    }
}

enum eMonster:Int,EnumCollection {
    case slime = 0,
    rabbit,
    fox,
    goblin,
    shamanGoblin,
    chiefGoblin,
    zombie,
    ghoul,
    gorilla,
    tiger,
    minotaur,
    gollem,
    swampGollen,
    skelleton,
    archerSkelleton,
    mageSkelleton,
    master
}

enum eMode:Int {
    case easy = 1, moderate, hard, master
}
