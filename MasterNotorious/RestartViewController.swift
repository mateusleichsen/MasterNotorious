//
//  RestartViewController.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 14.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import UIKit

class RestartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        player?.restart((player?.restartCount)!)
        bank?.cleanAccount()
        UserDefaultData.saveObj(obj: player!, key: defaultKeys.playerDataKey)
        UserDefaultData.saveObj(obj: bank!, key: defaultKeys.bankDataKey)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let startVC = segue.destination as? StartViewController {
            startVC.isRestart = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doorTapped(_ sender: Any) {
        performSegue(withIdentifier: "startSegue", sender: self)
    }
}
