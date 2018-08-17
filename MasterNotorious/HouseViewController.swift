//
//  HouseViewController.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 10.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import UIKit

class HouseViewController: UIViewController {
    var playerContainerVC:PlayerContainerViewController!
    var isSleeping:Bool = false
    var sleepThread:DispatchWorkItem?
    @IBOutlet weak var sleepProgress: UIProgressView!
    @IBOutlet weak var sleepButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sleepProgress.progress = 0.0
        sleepButton.setStandard()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sleepThread?.cancel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let playerContainerVC = segue.destination as? PlayerContainerViewController {
            self.playerContainerVC = playerContainerVC
        }
    }
    
    @IBAction func sleepTapped(_ sender: Any) {
        let hoursSleep = Int(((player?.maxStamina)! - (player?.stamina)!) / 10)
        sleepThread = DispatchWorkItem {
            for index in 1...hoursSleep {
                if (self.sleepThread?.isCancelled)! {
                    self.isSleeping = false
                    break
                }
                sleep(5)
                DispatchQueue.main.async {
                    self.sleepProgress.progress = Float(index) / Float(hoursSleep)
                    player?.increaseStamina()
                    if index == hoursSleep {
                        player?.fullHeal()
                        player?.fullRecover()
                        self.sleepButton.setTitle("Sleep", for: .normal)
                        self.isSleeping = false
                    }
                    self.playerContainerVC.updateStatus()
                    playerRepository.updatePlayer(player: player!)
                    bankRepository.updateBankData(bank: bank!)
                }
            }
        }
        
        if player?.stamina == player?.maxStamina {
            showAlert(title: "Sleep?!?", message: "I am ready to fight!", uiViewController: self)
            return
        }
        
        if isSleeping {
            sleepButton.setTitle("Sleep", for: .normal)
            self.sleepProgress.progress = 0.0
            self.sleepThread?.cancel()
            return
        }
        
        sleepButton.setTitle("Wake up!", for: .normal)
        isSleeping = true
        
        DispatchQueue.global(qos: .background).async(execute: sleepThread!)
    }
}
