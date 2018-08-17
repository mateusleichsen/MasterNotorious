//
//  ForestViewController.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 06.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import UIKit

class ForestViewController: UIViewController {
    @IBOutlet weak var playerContainerView: UIView!
    var playerContainerVC:PlayerContainerViewController?
    @IBOutlet weak var huntButton: UIButton!
    @IBOutlet weak var ambushButton: UIButton!
    @IBOutlet weak var banditCampButton: UIButton!
    @IBOutlet weak var ragHutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        huntButton.setStandard()
        ambushButton.setStandard()
        banditCampButton.setStandard()
        ragHutButton.setStandard()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        playerContainerVC?.updateStatus()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if (player?.stamina)! <= 0 && identifier != "segueRagHut" {
            showAlert(title: "Is it missing something?", message: "Yeah! You must rest. No stamina, no fight. Go home and take a nap.", uiViewController: self)
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let combatVC = segue.destination as? CombatViewController {
            if segue.identifier == "segueHunt" {
                combatVC.mode = .easy
            } else if segue.identifier == "segueAmbush" {
                combatVC.mode = .moderate
            } else if segue.identifier == "segueBanditCamp" {
                combatVC.mode = .hard
            }
        }
        if let playerContainerVC = segue.destination as? PlayerContainerViewController {
            self.playerContainerVC = playerContainerVC
        }
    }
}
