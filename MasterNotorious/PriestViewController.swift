//
//  PriestViewController.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 09.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import UIKit

class PriestViewController: UIViewController {
    @IBOutlet weak var quotaLabel: UILabel!
    var playerContainerVC:PlayerContainerViewController!
    var quota:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAdvice()
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
    
    @IBAction func healTapped(_ sender: Any) {
        if (player?.stamina)! <= 0 {
            showAlert(title: "WHAT?", message: "You do not have something to sacrifice.\nYes, stamina", uiViewController: self)
            return
        }
        player?.fullHeal()
        player?.fullRecover()
        player?.decreaseStamina()
        playerContainerVC.updateStatus()
        showAlert(title: "Your wounds are past", message: "You are skinny, you shall eat more pasta.", uiViewController: self)
    }
    
    fileprivate func getAdvice() {
        let urlString = NSString(string: "http://api.adviceslip.com/advice")
        requestAPI(urlSource: urlString, onCompletation: {result in
            let jsonDictionary = result as! [String: [String: AnyObject]]
            let slip = Slip(jsonDictionary)
            self.quota = slip.advice
            DispatchQueue.main.async {
                self.quotaLabel.text = self.quota
            }
        })
    }
}
