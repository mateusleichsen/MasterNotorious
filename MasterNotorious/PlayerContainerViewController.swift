//
//  PlayerContainerViewController.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 09.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import UIKit

class PlayerContainerViewController: UIViewController {
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var staminaProgressBar: UIProgressView!
    @IBOutlet weak var playerHealthLabel: UILabel!
    @IBOutlet weak var playerManaLabel: UILabel!
    @IBOutlet weak var playerAttackLabel: UILabel!
    @IBOutlet weak var playerDefenseLabel: UILabel!
    @IBOutlet weak var playerGoldLabel: UILabel!
    @IBOutlet weak var playerLevelLabel: UILabel!
    @IBOutlet weak var expProgressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStatus()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateStatus() {
        if player == nil {
            return
        }
        playerNameLabel.text = player?.name
        staminaProgressBar.progress = Float((player?.stamina)!) / Float((player?.maxStamina)!)
        let currentExp = (player?.level.exp)! - Level.calculateExp((player?.level.current)! - 1)
        expProgressBar.progress = Float(currentExp) / Float(Level.calculateExpLevel((player?.level.current)!))
        playerHealthLabel.text = "\(player?.health ?? 1)"
        playerManaLabel.text = "\(player?.mana ?? 1)"
        playerAttackLabel.text = "\(player?.attack ?? 1)"
        playerDefenseLabel.text = "\(player?.defense ?? 1)"
        playerGoldLabel.text = "\(player?.gold ?? 1)"
        playerLevelLabel.text = "\(player?.level.current ?? 1)"
    }
}
