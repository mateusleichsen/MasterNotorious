//
//  extensions.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 07.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Int {
    mutating func incrementByLevel(_ level:Int) {
        self = Int(Double(self) * (1 + (Double(level) * 0.15)))
    }
    
    mutating func incrementByMode(_ mode:eMode) {
        self = Int(Double(self) * (1 + (Double(mode.rawValue) * 0.2)))
    }
}

extension Array where Element == (Date,Decimal) {
    func sum() -> Decimal {
        var result:Decimal = 0.00
        for element in self {
            result += element.1
        }
        return result
    }
}

extension Decimal {
    func rounded(toPlaces places:Int) -> Decimal {
        let divisor = pow(10.0, Double(places))
        let value = (NSDecimalNumber(decimal: self).doubleValue * divisor).rounded() / divisor
        return NSDecimalNumber(value: value) as Decimal
    }
}

extension UIButton {
    //2D9832
    func setStandard() {
        self.backgroundColor = UIColor(red: 0.1, green: 0.5, blue: 0.1, alpha: 0.1)
        self.layer.cornerRadius = 10.0
        self.tintColor = UIColor(red: 0.1, green: 0.5, blue: 0.1, alpha: 1)
    }
}

extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        if self.contentSize.height + 50 < self.bounds.size.height {
            return
        }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height + 50 - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}

extension UIView {
    func hide() {
        self.alpha = 0
    }
    
    func show() {
        self.alpha = 1
    }
}

extension UIImage {
    func croppedInRect(rect: CGRect) -> UIImage {
        func rad(_ degree: Double) -> CGFloat {
            return CGFloat(degree / 180.0 * .pi)
        }
        
        let imageRef = self.cgImage!.cropping(to: rect)
        let result = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return result
    }
}

extension Player {
    convenience init(objPlayer obj:NSManagedObject, objJewelry:NSManagedObject, objBonus:[NSManagedObject], objSkill:[NSManagedObject]) {
        let name = obj.value(forKey: "name") as! String
        let race = obj.value(forKey: "race") as! String
        let profession = obj.value(forKey: "profession") as! String
        let exp = obj.value(forKey: "exp") as! Int
        let level = obj.value(forKey: "level") as! Int
        let health = obj.value(forKey: "health") as! Int
        let maxHealth = obj.value(forKey: "maxHealth") as! Int
        let mana = obj.value(forKey: "mana") as! Int
        let maxMana = obj.value(forKey: "maxMana") as! Int
        let stamina = obj.value(forKey: "stamina") as! Int
        let maxStamina = obj.value(forKey: "maxStamina") as! Int
        let weaponName = obj.value(forKey: "weaponName") as! String
        let armorName = obj.value(forKey: "armorName") as! String
        let attack = obj.value(forKey: "attack") as! Int
        let defense = obj.value(forKey: "defense") as! Int
        let gold = obj.value(forKey: "gold") as! Int
        let restartCount = obj.value(forKey: "restartCount") as! Int
        
        self.init(name: name, race: eRace(rawValue: race)!, profession: eProfession(rawValue: profession)!)
        
        self.level = Level(exp: exp)
        self.level.reloadLevel(level: level)
        self.health = health
        self.maxHealth = maxHealth
        self.mana = mana
        self.maxMana = maxMana
        self.stamina = stamina
        self.maxStamina = maxStamina
        self.weapon = Weapon(type: eWeapon(rawValue: weaponName)!, price: 10)
        self.armor = Armor(type: eArmor(rawValue: armorName)!, price: 10)
        self.attack = attack
        self.defense = defense
        self.gold = gold
        self.restartCount = restartCount
        
        let jewelryName = objJewelry.value(forKey: "name") as! String
        let jewelryPrice = objJewelry.value(forKey: "price") as! Int
        let jewelryBonus = objJewelry.value(forKey: "bonus") as! String
        let jewelryBonusValue = objJewelry.value(forKey: "bonusValue") as! Int
        
        self.jewelry = Jewelry(name: jewelryName, price: jewelryPrice, bonus: eBonus(rawValue: jewelryBonus)!, bonusValue: jewelryBonusValue)
        
        for element in objBonus {
            let bonusName = element.value(forKey: "name") as! String
            let bonusValue = element.value(forKey: "value") as! Int
            self.bonus[eBonus(rawValue: bonusName)!] = bonusValue
        }
        
        self.skill = [Skill]()
        for element in objSkill {
            let skill = element.value(forKey: "name") as! String
            self.skill.append(Skill(eSkill(rawValue: skill)!))
        }
    }
}

extension Bank {
    convenience init(obj: [NSManagedObject]) {
        self.init()
        
        var loans = [(Date,Decimal)]()
        var deposits = [(Date,Decimal)]()
        for element in obj {
            let date = element.value(forKey: "date") as! Date
            let valueFloat = element.value(forKey: "value") as! Float
            let value = NSDecimalNumber(value: valueFloat).decimalValue
            let type = element.value(forKey: "type") as! Int
            if type == eBankData.deposit.rawValue {
                deposits.append((date, value))
            }
            if type == eBankData.loan.rawValue {
                loans.append((date, value))
            }
        }
        
        self.loadDeposits(deposits)
        self.loadLoans(loans)
    }
}
