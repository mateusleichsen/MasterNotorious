//
//  RagHealHutViewController.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 08.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import UIKit

class RagHealHutViewController: UIViewController {

    @IBOutlet weak var valueHealLabel: UILabel!
    @IBOutlet weak var valueManaLabel: UILabel!
    @IBOutlet weak var healSlider: UISlider!
    @IBOutlet weak var manaSlider: UISlider!
    var playerContainerVC:PlayerContainerViewController?
    
    var costHeal = 0
    var costMana = 0
    var amountToHeal = 0
    var amountToRecover = 0
    let step:Float = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        updateStatus()
        setInitialValues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let playerContainerVC = segue.destination as? PlayerContainerViewController {
            self.playerContainerVC = playerContainerVC
        }
    }
    @IBAction func healSliderChanged(_ sender: Any) {
        let slider = sender as! UISlider
        let results = calculateHealValues(slider: slider)
        slider.value = results.roundedValue
        valueHealLabel.text = "\(Int(results.roundedValue))% - \(results.cost)gp"
        self.costHeal = results.cost
        self.amountToHeal = calculateAmountToHeal(results.roundedValue)
    }
    
    @IBAction func healTapped(_ sender: Any) {
        if costHeal > (player?.gold)! {
            showAlertNoMoney()
        } else {
            player?.spend(self.costHeal)
            player?.heal(self.amountToHeal)
            showAlert(title: "You are HEALED", message: "But was it necessery to eat a hearth?", uiViewController:self)
            updateStatus()
            playerRepository.updatePlayer(player: player!)
            setInitialValues()
        }
    }
    
    @IBAction func manaSliderChanged(_ sender: Any) {
        let manaSlider = sender as! UISlider
        let results = calculateManaValues(slider: manaSlider)
        manaSlider.value = results.roundedValue
        valueManaLabel.text = "\(Int(results.roundedValue))% - \(results.cost)gp"
        self.costMana = results.cost
        self.amountToRecover = calculateAmountToRecover(results.roundedValue)
    }
    
    @IBAction func recoverTapped(_ sender: Any) {
        if costMana > (player?.gold)! {
            showAlertNoMoney()
        } else {
            player?.spend(self.costMana)
            player?.recover(self.amountToRecover)
            showAlert(title: "Did you feel that?", message: "Sweet recovery.", uiViewController:self)
            updateStatus()
            playerRepository.updatePlayer(player: player!)
            setInitialValues()
        }
    }
    
    fileprivate func setInitialValues() {
        let resultHealth = calculateHealValues(value: healSlider.value)
        let resultRecover = calculateManaValues(value: manaSlider.value)
        valueHealLabel.text = "\(Int(resultHealth.roundedValue))% - \(resultHealth.cost)gp"
        valueManaLabel.text = "\(Int(resultRecover.roundedValue))% - \(resultRecover.cost)gp"
        self.costHeal = resultHealth.cost
        self.costMana = resultRecover.cost
        self.amountToHeal = calculateAmountToHeal(resultHealth.roundedValue)
        self.amountToRecover = calculateAmountToRecover(resultRecover.roundedValue)
    }
    
    fileprivate func calculateAmountToRecover(_ roundedValue: Float) -> Int {
        return Int(Float((player?.maxMana)! - (player?.mana)!) * roundedValue / 100)
    }
    
    fileprivate func calculateAmountToHeal(_ roundedValue: Float) -> Int {
        return Int(Float((player?.maxHealth)! - (player?.health)!) * roundedValue / 100)
    }
    
    fileprivate func showAlertNoMoney() {
        showAlert(title: "Where's my money?", message: "Sorry, you do not have enough money.", uiViewController: self)
    }
    
    fileprivate func calculateHealValues(slider:UISlider) -> (cost: Int, roundedValue: Float) {
        let results = calculateHealValues(value: slider.value)
        return (results.cost, results.roundedValue)
    }
    
    fileprivate func calculateHealValues(value:Float) -> (cost: Int, roundedValue: Float) {
        let roundedValue = round(value / step) * step
        
        var cost = 0
        if (player?.level.current)! > 1 {
            cost = Int(Float(((player?.maxHealth)! - (player?.health)!) * (player?.level.current)!) * roundedValue / 100.0)
        }
        cost = Int(Float(((player?.maxHealth)! - (player?.health)!) * (player?.level.current)!) * roundedValue / 100.0)
        
        return (cost,roundedValue)
    }
    
    fileprivate func calculateManaValues(slider:UISlider) -> (cost: Int, roundedValue: Float) {
        let results = calculateManaValues(value: slider.value)
        return (results.cost, results.roundedValue)
    }
    
    fileprivate func calculateManaValues(value:Float) -> (cost: Int, roundedValue: Float) {
        let roundedValue = round(value / step) * step
        
        var cost = 0
        if (player?.level.current)! > 1 {
            cost = Int(Float(((player?.maxMana)! - (player?.mana)!) * (player?.level.current)!) * roundedValue / 100.0 * 0.95)
        }
        cost = Int(Float(((player?.maxMana)! - (player?.mana)!) * (player?.level.current)!) * roundedValue / 100.0 * 0.95)
        
        return (cost,roundedValue)
    }
    
    fileprivate func updateStatus() {
        playerContainerVC?.updateStatus()
    }
}
