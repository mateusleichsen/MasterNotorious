//
//  UnderworldViewController.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 14.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import UIKit

class UnderworldViewController: UIViewController {
    @IBOutlet weak var healthGatekeeperLabel: UILabel!
    @IBOutlet weak var imageTop: UIImageView!
    var healthGatekeeper = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        healthGatekeeperLabel.text = "\(healthGatekeeper)"
        self.navigationItem.setHidesBackButton(true, animated: true)
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        imageTop.image = imageTop.image?.croppedInRect(rect: CGRect(x: 0, y: -130, width: 660, height: (imageTop.image?.size.height)!))
        showAlert(title: "You are dead", message: "Someone or something killed you, now you are in the underworld", uiViewController: self, actionToExecute: {
                showAlert(title: "Underworld", message: "But you need return to life, there is a thing left to do", uiViewController: self, actionToExecute: {
                    showAlert(title: "The Gatekeeper", message: "Attack the Gatekeeper to return to life", uiViewController: self)
                })
            })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func attackTapped(_ sender: Any) {
        let dice = Combat.rollDice(value: 20, defense: false)
        healthGatekeeper -= dice
        healthGatekeeperLabel.text = "\(healthGatekeeper)"
        
        if healthGatekeeper <= 0 {
            performSegue(withIdentifier: "mainSegueFromUnder", sender: self)
        }
    }
}
