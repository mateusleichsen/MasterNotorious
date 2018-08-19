//
//  ViewController.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 04.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate {
    func reset()
}

class CrossroadViewController: UIViewController {
    var playerContainerVC:PlayerContainerViewController?
    var menuVC:MenuViewController!
    var menu = true
    @IBOutlet weak var florestButton: UIButton!
    @IBOutlet weak var villageButton: UIButton!
    @IBOutlet weak var houseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsTapped))
        menuVC = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.delegate = self
        menuVC.view.frame = CGRect(x: 2 * UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        florestButton.setStandard()
        villageButton.setStandard()
        houseButton.setStandard()
    }

    fileprivate func showMenu() {
        UIView.animate(withDuration: 0.4) { () -> Void in
            self.menuVC.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.menuVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.addChildViewController(self.menuVC)
            self.view.addSubview(self.menuVC.view)
        }
    }
    
    fileprivate func hideMenu() {
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.menuVC.view.frame = CGRect(x: 2 * UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }) { (finished) in self.menuVC.view.removeFromSuperview()}
    }
    
    @objc func settingsTapped() {
        if menu {
            menu = false
            showMenu()
        } else {
            menu = true
            hideMenu()
        }
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

extension CrossroadViewController: MenuViewControllerDelegate {
    func reset() {
        print("reset")
        playerRepository.deletePlayer()
        bankRepository.deleteBank()
        player = nil
        bank = nil
        navigationController?.popToRootViewController(animated: true)
    }
}
