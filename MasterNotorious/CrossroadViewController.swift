//
//  ViewController.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 04.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import UIKit

class CrossroadViewController: UIViewController {
    var playerContainerVC:PlayerContainerViewController?
    @IBOutlet weak var florestButton: UIButton!
    @IBOutlet weak var villageButton: UIButton!
    @IBOutlet weak var houseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        florestButton.setStandard()
        villageButton.setStandard()
        houseButton.setStandard()
    }

    override func viewDidAppear(_ animated: Bool) {
        playerContainerVC?.updateStatus()
    }
    
    func updateName(name:String) {
        player?.name = name
        playerContainerVC?.updateStatus()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let playerContainerVC = segue.destination as? PlayerContainerViewController {
            self.playerContainerVC = playerContainerVC
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

