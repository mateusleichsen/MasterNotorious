//
//  StartViewController.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 14.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import UIKit

var player:Player?
var bank:Bank?
var playerRepository:PlayerRepository!
var bankRepository:BankRepository!

class StartViewController: UIViewController  {
    var isRestart:Bool = false
    var firstChar:Bool = player == nil
    var raceProfessionPicker:RaceProfessionPicker!
    var bonusPicker:BonusPicker!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var raceProfessionPickerView: UIPickerView!
    @IBOutlet weak var bonusPickerView: UIPickerView!
    @IBOutlet weak var nameStackView: UIStackView!
    @IBOutlet weak var bonusStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        playerRepository = PlayerRepository(jewelryRepositry: JewelryRepository(), bonusRepository: BonusRepository(), skillRepository: SkillRepository())
        bankRepository = BankRepository()
        
        setDataPickers()
        loadUserData()
        if player != nil && !isRestart {
            performSegue(withIdentifier: "crossroadSegue", sender: self)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if isRestart {
            nameStackView.hide()
        } else {
            nameStackView.show()
        }
        
        if firstChar {
            bonusStackView.hide()
        } else {
            bonusStackView.show()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startTapped(_ sender: Any) {
        let raceRawValue = raceProfessionPicker.data[0][raceProfessionPickerView.selectedRow(inComponent: 0)]
        let race = eRace(rawValue: raceRawValue)
        let professionRawValue = raceProfessionPicker.data[1][raceProfessionPickerView.selectedRow(inComponent: 1)]
        let profession = eProfession(rawValue: professionRawValue)
        let bonus = bonusPicker.data[bonusPickerView.selectedRow(inComponent: 0)]
        
        if firstChar {
            player = Player(name: nameText.text!, race: race!, profession: profession!)
            firstChar = false
            playerRepository.savePlayer(player: player!)
            print("playersaved")
        }
        
        if isRestart {
            player?.changeRace(race!)
            player?.changeProfession(profession!)
            if bonus == .stamina || bonus == .mana || bonus == .health {
                player?.bonus[bonus] = (player?.bonus[bonus])! + 10
            } else {
                player?.bonus[bonus] = (player?.bonus[bonus])! + 2
            }
            isRestart = false
        }
        
        player?.calculateLevel()
        
        player?.health = (player?.maxHealth)!
        player?.mana = (player?.maxMana)!
        player?.stamina = (player?.maxStamina)!
        
        if bank == nil {
            bank = Bank()
            bankRepository.saveBankData(bank: bank!)
        }
        
        playerRepository.updatePlayer(player: player!)
        bankRepository.updateBankData(bank: bank!)
        performSegue(withIdentifier: "crossroadSegue", sender: self)
    }
    
    fileprivate func setDataPickers() {
        raceProfessionPicker = RaceProfessionPicker()
        bonusPicker = BonusPicker()
        
        var racesProfessions = [[String]]()
        var races = [String]()
        for value in eRace.allValues {
            races.append(value.rawValue)
        }
        var professions = [String]()
        for value in eProfession.allValues {
            professions.append(value.rawValue)
        }
        
        racesProfessions.append(races)
        racesProfessions.append(professions)
        raceProfessionPicker.data = racesProfessions
        raceProfessionPickerView.dataSource = raceProfessionPicker
        raceProfessionPickerView.delegate = raceProfessionPicker
        
        var bonusList = [eBonus]()
        for value in eBonus.allValues {
            bonusList.append(value)
        }
        bonusPicker.data = bonusList
        bonusPickerView.dataSource = bonusPicker
        bonusPickerView.delegate = bonusPicker
    }
    
    fileprivate func loadUserData() {
        player = playerRepository.loadPlayer()
        bank = bankRepository.loadBankData()
        if bank == nil {
            bank = Bank()
            bankRepository.saveBankData(bank: bank!)
        }
        
        player?.level.exp = 1000000
        player?.level.levelUp()
        player?.level.levelUp()
        player?.level.levelUp()
        player?.level.levelUp()
        player?.level.levelUp()
        player?.level.levelUp()
        player?.level.levelUp()
        player?.level.levelUp()
        player?.level.levelUp()
        player?.level.levelUp()
        player?.level.levelUp()
        player?.level.levelUp()
        player?.level.levelUp()
        player?.level.levelUp()
        player?.weapon = Weapon(type: .light_saber, price: 199)
        player?.armor = Armor(type: .green_tunic, price: 199)
        player?.maxHealth = 1000
        player?.health = 1000
        player?.attack = 400
    }
}

class RaceProfessionPicker:UIPickerView,UIPickerViewDataSource,UIPickerViewDelegate {
    var data:[[String]]!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int ) -> String? {
        return data[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
}

class BonusPicker:UIPickerView,UIPickerViewDataSource,UIPickerViewDelegate {
    var data:[eBonus]!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
    
}
