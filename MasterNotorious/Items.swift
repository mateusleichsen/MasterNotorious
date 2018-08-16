//
//  Items.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 10.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation

class Item {
    var name:String
    var price:Int
    
    init(name:String, price:Int) {
        self.name = name
        self.price = price
    }
}

enum eWeapon: String, EnumCollection {
    case wooden_dagger = "Wooden Dagger",
    wooden_sword = "Wooden Sword",
    iron_dagger = "Iron Dagger",
    iron_sword = "Iron Sword",
    steel_dagger = "Steel Dagger",
    steel_sword = "Steel Sword",
    silver_dagger = "Silver Dagger",
    silver_sword = "Silver Sword",
    golden_dagger = "Golden Dagger",
    golden_sword = "Golden Sword",
    platinum_dagger = "Platinum Dagger",
    platinum_sword = "Platinum Sword",
    crystal_dagger = "Crystal Dagger",
    crystal_sword = "Crystal Sword",
    light_saber = "Light Saber",
    stick = "Stick"
}

enum eArmor: String, EnumCollection {
    case old_leather = "Old Jacket",
    fresh_leather = "New Jacket",
    leather = "Jacket",
    heavy_leather = "2 Jackets",
    iron_chain = "Iron Chain",
    steel_chain = "Steel Chain",
    plate = "Plate",
    silver_plate = "Silver Plate",
    golden_plate = "Golden Plate",
    platinum_plate = "Platinum Plate",
    magic_plate = "Magic Plate",
    dragon_scales = "Dragon Scales Armor",
    old_dragon_scales = "Old DSA",
    golden_dragon_scales = "Golden DSA",
    green_tunic = "Green Tunic",
    pijama = "Pijama"
}

enum eBonus:String,EnumCollection {
    case attack = "Attack",
    defense = "Defense",
    health = "Health",
    mana = "Mana",
    stamina = "Stamina"
}

class Jewelry:Item {
    var bonus:eBonus
    var bonusValue:Int
    init(name: String, price:Int, bonus: eBonus, bonusValue: Int) {
        self.bonus = bonus
        self.bonusValue = bonusValue
        super.init(name: name, price: price)
    }
    
    static func getAllJewelry() -> [Jewelry] {
        var items:[Jewelry] = []
        
        items.append(Jewelry(name: "Copper Ring", price: 15, bonus: .attack, bonusValue: 10))
        items.append(Jewelry(name: "Silver Ring", price: 15, bonus: .defense, bonusValue: 10))
        items.append(Jewelry(name: "Golden Ring", price: 150, bonus: .health, bonusValue: 100))
        items.append(Jewelry(name: "Bracelet", price: 75, bonus: .mana, bonusValue: 50))
        items.append(Jewelry(name: "Necklace", price: 300, bonus: .stamina, bonusValue: 20))
        items.append(Jewelry(name: "Diamond Ring", price: 38, bonus: .attack, bonusValue: 25))
        items.append(Jewelry(name: "Arcane Talisman", price: 38, bonus: .defense, bonusValue: 25))
        items.append(Jewelry(name: "Piercing", price: 52, bonus: .health, bonusValue: 35))
        items.append(Jewelry(name: "Earring", price: 38, bonus: .mana, bonusValue: 25))
        items.append(Jewelry(name: "Crown", price: 750, bonus: .stamina, bonusValue: 50))
        
        return items
    }
}

class Weapon:Item {
    var type:eWeapon
    var attack:Int!
    
    init(type:eWeapon,price:Int) {
        self.type = type
        self.attack = Weapon.getWeaponAttack(type: type)
        super.init(name: type.rawValue, price: price)
    }
    
    static func getAllWeapons() -> [Weapon] {
        var weapons:[Weapon] = []
        for item in eWeapon.allValues {
            if item == .stick {
                continue
            }
            weapons.append(Weapon(type: item, price: 0))
        }
        return weapons
    }
    
    static func getWeaponAttack(type:eWeapon) -> Int{
        switch type {
        case .stick:
            return 0
        case .wooden_dagger:
            return 1
        case .wooden_sword:
            return 2
        case .iron_dagger:
            return 4
        case .iron_sword:
            return 5
        case .steel_dagger:
            return 7
        case .steel_sword:
            return 8
        case .silver_dagger:
            return 10
        case .silver_sword:
            return 11
        case .golden_dagger:
            return 13
        case .golden_sword:
            return 14
        case .platinum_dagger:
            return 16
        case .platinum_sword:
            return 17
        case .crystal_dagger:
            return 19
        case .crystal_sword:
            return 20
        case .light_saber:
            return 25
        }
    }
}

class Armor:Item {
    var type:eArmor
    var defense:Int
    
    init(type: eArmor, price: Int) {
        self.type = type
        self.defense = Armor.getArmorDefense(type: type)
        super.init(name: type.rawValue, price: price)
    }
    
    static func getAllArmor() -> [Armor] {
        var armor:[Armor] = []
        for item in eArmor.allValues {
            if item == .pijama {
                continue
            }
            armor.append(Armor(type: item, price: 0))
        }
        return armor
    }
    
    static func getArmorDefense(type:eArmor) -> Int{
        switch type {
        case .pijama:
            return 0
        case .old_leather:
            return 1
        case .fresh_leather:
            return 2
        case .leather:
            return 4
        case .heavy_leather:
            return 5
        case .iron_chain:
            return 7
        case .steel_chain:
            return 8
        case .plate:
            return 10
        case .silver_plate:
            return 11
        case .golden_plate:
            return 13
        case .platinum_plate:
            return 14
        case .magic_plate:
            return 16
        case .dragon_scales:
            return 17
        case .old_dragon_scales:
            return 19
        case .golden_dragon_scales:
            return 20
        case .green_tunic:
            return 25
        }
    }
}
