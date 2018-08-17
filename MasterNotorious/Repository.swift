//
//  Repository.swift
//  MasterNotorious
//
//  Created by Mateus Leichsenring on 17.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct EntityNames {
    static let playerEntity:String = "PlayerModel"
    static let skillEntity:String = "SkillModel"
    static let bonusEntity:String = "BonusModel"
    static let jewelryEntity:String = "JewelryModel"
    static let bankEntity:String = "BankModel"
}

class Repository {
    var context:NSManagedObjectContext!
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    func saveObj(obj:[String:Any], entityName:String) {
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        updateObj(managedObject: managedObject, obj: obj)
    }
    
    func readObj(_ entity: String, forKey key:String, value:String) -> NSManagedObject? {
        let objList = readObjList(entity)
        
        for obj in objList {
            if let item = obj.value(forKey: key) {
                let itemCasted = item as! String
                if itemCasted == value {
                    return obj
                }
            }
        }
        
        return nil
    }
    
    func readObj(_ entity: String, forKey key:String, value:Int) -> NSManagedObject? {
        let objList = readObjList(entity)
        
        for obj in objList {
            if let item = obj.value(forKey: key) {
                let itemCasted = item as! Int
                if itemCasted == value {
                    return obj
                }
            }
        }
        
        return nil
    }
    
    func readObj(_ entity: String, forKey key:String, value:Date) -> NSManagedObject? {
        let objList = readObjList(entity)
        
        for obj in objList {
            if let item = obj.value(forKey: key) {
                let itemCasted = item as! Date
                if itemCasted == value {
                    return obj
                }
            }
        }
        
        return nil
    }
    
    func readObjList(_ entity: String) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try context.fetch(fetchRequest)
            
            if let records = records as? [NSManagedObject] {
                result = records
            }
            
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        
        return result
    }
    
    func updateObj(managedObject:NSManagedObject, obj:[String:Any]) {
        for element in obj {
            managedObject.setValue(element.1, forKey: element.0)
        }
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
}

class PlayerRepository:Repository {
    var jewelryRepository:JewelryRepository
    var bonusRepository:BonusRepository
    var skillRepository:SkillRepository
    
    init(jewelryRepositry:JewelryRepository, bonusRepository:BonusRepository, skillRepository:SkillRepository) {
        self.jewelryRepository = jewelryRepositry
        self.bonusRepository = bonusRepository
        self.skillRepository = skillRepository
    }
    
    func savePlayer(player: Player) {
        let obj = convertTo(player: player)
        
        jewelryRepository.saveJewelry(jewelry: player.jewelry!)
        bonusRepository.saveBonus(bonus: player.bonus)
        skillRepository.saveSkill(skill: player.skill)
        super.saveObj(obj: obj, entityName: EntityNames.playerEntity)
    }
    
    //Since we are going to have one player, load first result
    func loadPlayer() -> Player? {
        let obj = super.readObjList(EntityNames.playerEntity).first
        let objJewelry = super.readObjList(EntityNames.jewelryEntity).first
        let objBonus = super.readObjList(EntityNames.bonusEntity)
        let objSkill = super.readObjList(EntityNames.skillEntity)
        
        if obj == nil {
            return nil
        }
        
        let player = Player(objPlayer: obj!, objJewelry: objJewelry!, objBonus: objBonus, objSkill: objSkill)
        
        return player
    }
    
    func updatePlayer(player: Player) {
        if let playerObj = super.readObjList(EntityNames.playerEntity).first {
            let obj = convertTo(player: player)
            
            super.updateObj(managedObject: playerObj, obj: obj)
            jewelryRepository.updateJewelry(jewelry: player.jewelry!)
            bonusRepository.updateBonus(bonus: player.bonus)
            skillRepository.updateSkill(skill: player.skill)
        }
        
    }
    
    func convertTo(player:Player) -> [String:Any] {
        var obj = [String:Any]()
        
        obj["name"] = player.name
        obj["race"] = player.race.rawValue
        obj["profession"] = player.profession.rawValue
        obj["exp"] = player.level.exp
        obj["health"] = player.health
        obj["maxHealth"] = player.maxHealth
        obj["mana"] = player.mana
        obj["maxMana"] = player.maxMana
        obj["stamina"] = player.stamina
        obj["maxStamina"] = player.maxStamina
        obj["weaponName"] = player.weapon?.name
        obj["armorName"] = player.armor?.name
        obj["attack"] = player.attack
        obj["defense"] = player.defense
        obj["gold"] = player.gold
        obj["restartCount"] = player.restartCount
        
        return obj
    }
}

class JewelryRepository:Repository {
    func saveJewelry(jewelry:Jewelry) {
        let obj = convertTo(jewelry: jewelry)
        
        super.saveObj(obj: obj, entityName: EntityNames.jewelryEntity)
    }
    
    func updateJewelry(jewelry:Jewelry) {
        if let jewelryObj = super.readObjList(EntityNames.jewelryEntity).first {
            let obj = convertTo(jewelry: jewelry)
            
            super.updateObj(managedObject: jewelryObj, obj: obj)
        }
    }
    
    func convertTo(jewelry:Jewelry) -> [String:Any] {
        var obj = [String:Any]()
        
        obj["name"] = jewelry.name
        obj["price"] = jewelry.price
        obj["bonus"] = jewelry.bonus.rawValue
        obj["bonusValue"] = jewelry.bonusValue
        
        return obj
    }
}

class BonusRepository:Repository {
    func saveBonus(bonus:[eBonus:Int]) {
        for element in bonus {
            let obj = convertTo(bonus: element.0, value: element.1)
            
            super.saveObj(obj: obj, entityName: EntityNames.bonusEntity)
        }
    }
    
    func updateBonus(bonus:[eBonus:Int]) {
        for element in bonus {
            if let bonusObj = super.readObj(EntityNames.bonusEntity, forKey: "name", value: element.key.rawValue) {
                let obj = convertTo(bonus: element.key, value: element.value)
                
                super.updateObj(managedObject: bonusObj, obj: obj)
            }
        }
    }
    
    func convertTo(bonus:eBonus, value:Int) -> [String:Any] {
        var obj = [String:Any]()
        
        obj["name"] = bonus.rawValue
        obj["value"] = value
        
        return obj
    }
}

class SkillRepository:Repository {
    func saveSkill(skill:[Skill]) {
        for element in skill {
            let obj = convertTo(skill: element)
            
            super.saveObj(obj: obj, entityName: EntityNames.skillEntity)
        }
    }
    
    func updateSkill(skill:[Skill]) {
        for element in skill {
            if let skillObj = super.readObj(EntityNames.skillEntity, forKey: "name", value: element.name) {
                let obj = convertTo(skill: element)
                
                super.updateObj(managedObject: skillObj, obj: obj)
            }
        }
    }
    
    func convertTo(skill:Skill) -> [String:Any] {
        var obj = [String:Any]()
        obj["name"] = skill.name
        
        return obj
    }
}

class BankRepository:Repository {
    func saveBankData(bank: Bank) {
        for element in bank.deposits {
            let obj = convertTo(bankData: element, type: .deposit)
            
            super.saveObj(obj: obj, entityName: EntityNames.bankEntity)
        }
        
        for element in bank.loans {
            let obj = convertTo(bankData: element, type: .loan)
            
            super.saveObj(obj: obj, entityName: EntityNames.bankEntity)
        }
    }
    
    func loadBankData() -> Bank? {
        let obj = readObjList(EntityNames.bankEntity)
        
        if obj.first == nil {
            return nil
        }
        
        return Bank(obj: obj)
    }
    
    func updateBankData(bank: Bank) {
        for element in bank.deposits {
            if let bankDataObj = super.readObj(EntityNames.bankEntity, forKey: "date", value: element.0) {
                let obj = convertTo(bankData: element, type: .loan)
                
                super.updateObj(managedObject: bankDataObj, obj: obj)
            }
        }
        
        for element in bank.loans {
            if let bankDataObj = super.readObj(EntityNames.bankEntity, forKey: "date", value: element.0) {
                let obj = convertTo(bankData: element, type: .loan)
                
                super.updateObj(managedObject: bankDataObj, obj: obj)
            }
        }
    }
    
    func convertTo(bankData: (Date,Decimal), type: eBankData) -> [String:Any] {
        var obj = [String:Any]()
        
        obj["date"] = bankData.0
        obj["type"] = type.rawValue
        obj["value"] = bankData.1
        
        return obj
    }
}
