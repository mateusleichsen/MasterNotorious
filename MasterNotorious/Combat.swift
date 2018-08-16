//
//  Combat.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 06.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation

class Combat {
    static func rollDice(value:Int, defense:Bool) -> Int {
        let dice = Dice.rollDice(.twenty)
        
        if dice == 20 {//critical
            return Int(Double(value) * 1.25)
        }
        
        if dice == 1 {
            let miss = Dice.rollDice(.twenty)
            if miss <= 3 && !defense {
                return 0
            }
        }
        
        return Int(Double(value) * (dice * 0.05))
    }
    
    static func calculateGold(level:Int) -> Int {
        let dice = Dice.rollDice(.twenty)
        
        if dice == 20 {//critical
            return Int(dice * 1.5 * Double(level) + 15 + Double(level * 15))
        }
        
        return Int(dice * Double(level) + 10 + Double(level * 10))
    }
    
    static func calculateExp(mode:eMode, level:Int, monsterBaseExp: Int) -> Int {
        return Int(Double(monsterBaseExp) * 1.8 + Double(level) * (Double(monsterBaseExp) + 0.05 * Double(mode.rawValue)))
    }
    
    static func fight(_ player:Player, _ monster: Monster, playerAttack:Bool, skill: Skill?) -> String {
        if skill != nil && player.mana < (skill?.mana)! {
            return "Out of mana"
        }
        
        player.skillUsed(skill?.mana ?? 0)
        
        if playerAttack {
            let skillText = "using \(skill?.name ?? "")"
            let attack = rollDice(value: player.attack + (skill?.attack ?? 0), defense: false)
            if attack == 0 {
                return "\(player.name) missed"
            }
            let defense = rollDice(value: monster.defense, defense: true)
            let result = defense - attack
            if result < 0 {
                monster.health += result
                return "\(player.name) attacked \(skill != nil ? skillText : "") \(monster.name) hitting \(result) damage"
            }
            return "\(player.name) attacked \(skill != nil ? skillText : "") \(monster.name), but it defended"
        } else {
            let attack = rollDice(value: monster.attack, defense: false)
            if attack == 0 {
                return "\(monster.name) missed"
            }
            let defense = rollDice(value: player.defense + (skill?.defense ?? 0), defense: true)
            let result = defense - attack
            if result < 0 {
                player.hurt(-result)
                return "\(monster.name) attacked \(player.name) hitting \(result)"
            }
            return "\(monster.name) attacked \(player.name), but you defended"
        }
    }
}

enum Turns:Int {
    case x1 = 1, x5 = 5, x10 = 10
}
