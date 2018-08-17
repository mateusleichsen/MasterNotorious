//
//  VillageViewController.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 10.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import UIKit

class VillageViewController: UIViewController {
    var playerContainerVC:PlayerContainerViewController?
    @IBOutlet weak var smithButton: UIButton!
    @IBOutlet weak var armourButton: UIButton!
    @IBOutlet weak var jewelyButton: UIButton!
    @IBOutlet weak var bankizButton: UIButton!
    @IBOutlet weak var priestButton: UIButton!
    @IBOutlet weak var notoriousButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        smithButton.setStandard()
        armourButton.setStandard()
        jewelyButton.setStandard()
        bankizButton.setStandard()
        priestButton.setStandard()
        notoriousButton.setStandard()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        playerContainerVC?.updateStatus()
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
}
