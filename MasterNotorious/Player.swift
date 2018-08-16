//
//  Player.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 05.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation

class Player {
    var name:String
    var race:eRace
    var profession:eProfession
    var level:Level = Level(exp:0)
    var health:Int = 100
    var maxHealth:Int = 100
    var stamina:Int = 100
    var maxStamina:Int = 100
    var mana:Int = 100
    var maxMana = 100
    var weapon:Weapon? {
        willSet {
            attack += (newValue?.attack)!
        }
        didSet {
            attack -= (oldValue?.attack)!
        }
    }
    var armor:Armor? {
        willSet {
            defense += (newValue?.defense)!
        }
        didSet {
            defense -= (oldValue?.defense)!
        }
    }
    var jewelry:Jewelry? {
        willSet {
            if let bonus = newValue?.bonus {
                switch bonus {
                case .attack:
                    attack += (newValue?.bonusValue)!
                case .defense:
                    defense += (newValue?.bonusValue)!
                case .health:
                    health += (newValue?.bonusValue)!
                case .mana:
                    mana += (newValue?.bonusValue)!
                case .stamina:
                    stamina += (newValue?.bonusValue)!
                }
            }
        }
        didSet {
            if let oldBonus = oldValue?.bonus {
                switch oldBonus {
                case .attack:
                    attack -= (oldValue?.bonusValue)!
                case .defense:
                    defense -= (oldValue?.bonusValue)!
                case .health:
                    health -= (oldValue?.bonusValue)!
                case .mana:
                    mana -= (oldValue?.bonusValue)!
                case .stamina:
                    stamina -= (oldValue?.bonusValue)!
                }
            }
        }
    }
    var skill:[Skill]
    var attack = 15
    var defense = 10
    var gold = 50
    var restartCount = 0
    var bonus:[eBonus:Int] = [:]
    
    init(name:String, race:eRace, profession:eProfession) {
        self.name = name == "" ? "(name?)" : name
        self.race = race
        self.profession = profession
        self.weapon = Weapon(type: .stick, price: 0)
        self.armor = Armor(type: .pijama, price: 0)
        self.jewelry = Jewelry(name: "Ring", price: 15, bonus: .attack, bonusValue: 0)
        self.skill = [Skill]()
        self.skill.append(Skill(.kick))
        self.skill.append(Skill(.kick))
        self.changeRace(race)
        self.changeProfession(profession)
        self.bonus[.attack] = 0
        self.bonus[.defense] = 0
        self.bonus[.stamina] = 0
        self.bonus[.health] = 0
        self.bonus[.mana] = 0
    }
    
    func calculateLevel() {
        maxHealth.incrementByLevel(self.level.current)
        maxMana.incrementByLevel(self.level.current)
        attack.incrementByLevel(self.level.current)
        defense.incrementByLevel(self.level.current)
    }
    
    func restart(_ restartCount:Int) {
        self.level = Level(exp: 0)
        self.weapon = Weapon(type: .stick, price: 0)
        self.armor = Armor(type: .pijama, price: 0)
        self.jewelry = Jewelry(name: "Ring", price: 15, bonus: .attack, bonusValue: 0)
        self.gold = 50 + (10 * restartCount)
        self.restartCount += 1
        
        self.maxHealth = 100
        self.maxStamina = 100
        self.maxMana = 100
        self.attack = 15
        self.defense = 10
    }
    
    func changeRace(_ race:eRace) {
        self.race = race
        switch race {
            case .human:
                maxHealth += 5
                maxMana += 5
                attack += 5
                defense += 5
                skill[0] = Skill(.kick)
            case .dwarf:
                maxHealth += 10
                defense += 5
                skill[0] = Skill(.ironPunch)
            case .elf:
                maxMana += 10
                attack += 10
                skill[0] = Skill(.evasion)
            case .orc:
                maxHealth += 20
                maxMana -= 5
                attack += 10
                skill[0] = Skill(.roar)
            case .troll:
                maxHealth += 30
                maxMana -= 20
                attack += 15
                skill[0] = Skill(.stoneShield)
            case .centaur:
                maxMana += 20
                maxHealth -= 5
                attack += 5
                defense += 10
                skill[0] = Skill(.roundHouseKick)
        }
    }
    
    func changeProfession(_ profession: eProfession) {
        switch profession {
        case .warrior:
            maxHealth += 10
            maxMana -= 5
            attack += 10
            skill[1] = Skill(.upperCut)
        case .mage:
            maxHealth -= 5
            maxMana += 10
            attack += 15
            defense -= 5
            skill[1] = Skill(.fireBall)
        case .archer:
            attack += 15
            skill[1] = Skill(.trap)
        case .rogue:
            maxHealth += 5
            attack += 15
            defense -= 5
            skill[1] = Skill(.poisonGas)
        case .priest:
            maxMana += 5
            defense += 10
            skill[1] = Skill(.magicShield)
        }
    }
    
    func increaseStamina() {
        if stamina < maxStamina {
            stamina += 10
        }
    }
    
    func decreaseStamina() {
        if stamina > 0 {
            stamina -= 10
        }
    }
    
    func fullHeal() {
        health = maxHealth
    }
    
    func heal(_ value:Int) {
        if health + value > maxHealth {
            health = maxHealth
        } else {
            health += value
        }
    }
    
    func fullRecover() {
        mana = maxMana
    }
    
    func recover(_ value:Int) {
        if mana + value > maxMana {
            mana = maxMana
        } else {
            mana += value
        }
    }
    
    func hurt(_ value:Int) {
        health -= value
    }
    
    func skillUsed(_ value:Int) {
        mana -= value
    }
    
    func spend(_ value:Int) {
        gold -= value
    }
    
    func receive(_ value:Int) {
        gold += value
    }
}

enum eRace:String, EnumCollection {
    case human = "Human"
    case dwarf = "Dwarf"
    case elf = "Elf"
    case orc = "Orc"
    case troll = "Troll"
    case centaur = "Centaur"
}

enum eProfession:String, EnumCollection {
    case warrior = "Warrior"
    case mage = "Mage"
    case archer = "Archer"
    case rogue = "Rogue"
    case priest = "Priest"
}

class Skill {
    var name:String
    var mana:Int = 0
    var attack:Int = 0
    var defense:Int = 0
    var type:eSkill
    
    init(_ skill:eSkill) {
        self.name = skill.rawValue
        self.type = skill
        switch skill {
        case .none:
            mana = 0
        case .upperCut:
            mana = 10
            attack = 30
        case .fireBall:
            mana = 50
            attack = 120
        case .trap:
            mana = 20
            attack = 50
        case .poisonGas:
            mana = 30
            attack = 80
        case .magicShield:
            mana = 50
            defense = 80
        case .kick:
            mana = 5
            attack = 20
        case .ironPunch:
            mana = 10
            attack = 20
            defense = 12
        case .evasion:
            mana = 25
            defense = 45
        case .roar:
            mana = 30
            attack = 30
            defense = 30
        case .stoneShield:
            mana = 40
            attack = 35
            defense = 55
        case .roundHouseKick:
            mana = 80
            attack = 200
            defense = 40
        }
    }
}

enum eSkill: String {
    case
    none = "None",
    upperCut = "Upper Cut",
    fireBall = "Fire Ball",
    trap = "Trap",
    poisonGas = "Poison Gas",
    magicShield = "Magic Shield",
    kick = "Kick",
    ironPunch = "Iron Punch",
    evasion = "Evasion",
    roar = "ARGHHH",
    stoneShield = "Stone Shield",
    roundHouseKick = "Round House Kick"
}

class Level {
    private(set) var current:Int = 1
    var exp:Int = 0
    var canLevelUp:Bool {
        get {
            return exp >= Level.calculateExp(self.current)
        }
    }
    
    init(exp value:Int) {
        self.exp = value
        self.current = 1
    }
    
    static func calculateExp(_ value:Int) -> Int {
        if value == 0 {
            return 0
        }
        return Int(pow(100, 0.1 * Double(value - 1)) * 100) + calculateExp(value - 1)
    }
    
    static func calculateExpLevel(_ value:Int) -> Int {
        return calculateExp(value) - calculateExp(value - 1)
    }
    
    func levelUp() {
        self.current += 1
    }
}
