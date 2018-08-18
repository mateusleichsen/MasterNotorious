//
//  RestartViewController.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 14.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import UIKit

class RestartViewController: UIViewController {
    
    private lazy var scene1VC: Scene1ViewController = {
        return subViewManager.instantiateViewController(identifier: "Scene1ViewController") as! Scene1ViewController
    }()
    private lazy var scene2VC: Scene2ViewController = {
        return subViewManager.instantiateViewController(identifier: "Scene2ViewController") as! Scene2ViewController
    }()
    private lazy var scene3VC: Scene3ViewController = {
        return subViewManager.instantiateViewController(identifier: "Scene3ViewController") as! Scene3ViewController
    }()
    private lazy var scene4VC: Scene4ViewController = {
        return subViewManager.instantiateViewController(identifier: "Scene4ViewController") as! Scene4ViewController
    }()
    var subViewManager:SubViewManager!
    var currentViewIndex:Int = 0
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var doorButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subViewManager = SubViewManager(storyboardName: "EndGame", parentView: containerView, parentViewController: self)
        player?.restart((player?.restartCount)!)
        bank?.cleanAccount()
        playerRepository.updatePlayer(player: player!)
        bankRepository.updateBankData(bank: bank!)
    }

    override func viewWillAppear(_ animated: Bool) {
        updateView(0)
        doorButton.setTitle("Next", for: .normal)
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
        if currentViewIndex == 3 {
            performSegue(withIdentifier: "startSegue", sender: self)
        }
        currentViewIndex += 1
        updateView(currentViewIndex)
        
        if currentViewIndex == 3 {
            doorButton.setTitle("Open the Door", for: .normal)
        }
    }
    
    private func updateView(_ index:Int) {
        switch index {
        case 0:
            subViewManager.updateView(nextViewController: scene1VC)
        case 1:
            subViewManager.updateView(nextViewController: scene2VC)
        case 2:
            subViewManager.updateView(nextViewController: scene3VC)
        case 3:
            subViewManager.updateView(nextViewController: scene4VC)
        default:
            return
        }
    }
}
