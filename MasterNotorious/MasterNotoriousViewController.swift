//
//  MasterNotoriousViewController.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 13.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import UIKit

class MasterNotoriousViewController: UIViewController {
    @IBOutlet weak var challengeButton:UIButton!
    var isLevelUp:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        challengeButton.layer.cornerRadius = 5
        challengeButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        setChallengeButton()
        if isLevelUp {
            playerRepository.updatePlayer(player: player!)
            bankRepository.updateBankData(bank: bank!)
            showAlert(title: "Congratulations", message: "You have grown a little. Now you are level \(player?.level.current ?? 0)", uiViewController: self, actionToExecute: {
                 self.isLevelUp = false
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let combatVC = segue.destination as? CombatViewController {
            if segue.identifier == "segueChallenge" {
                combatVC.mode = .master
            }
        }
    }
    
    fileprivate func setChallengeButton() {
        if !(player?.level.canLevelUp)! {
            challengeButton.isEnabled = false
            challengeButton.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.1)
            challengeButton.setTitle("You cannot challenge me", for: .normal)
        } else {
            challengeButton.isEnabled = true
            challengeButton.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.0)
            if (player?.level.current)! < 15 {
                challengeButton.setTitle("Challenge!", for: .normal)
            } else {
                showAlert(title: "You are ready", message: "Now it is the time to revenge your family, kill the man who killed your parents and siblings. (or you can run like a coward)", uiViewController: self)
                challengeButton.setTitle("Vegeance", for: .normal)
            }
        }
    }
    
    @IBAction func amIReadyTapped(_ sender: Any) {
        if (player?.level.canLevelUp)! {
            showAlert(title: "You!?", message: "Yes, you are ready to challenge me.", uiViewController: self)
        } else {
            let expMissing = Level.calculateExp((player?.level.current)!) - (player?.level.exp)!
            showAlert(title: "Ready!?", message: "No, you need training more, you need at least \(expMissing) experience", uiViewController: self)
        }
    }
}
