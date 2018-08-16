//
//  SteeleSmithViewController.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 10.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import UIKit

class SteeleSmithViewController: UIViewController {
    var itemShopContainerVC:ItemShopViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.itemShopContainerVC.typeItemLabel = "weapon"
        self.itemShopContainerVC.buyButtonTap = { item in
            player?.weapon = item as? Weapon
        }
        self.itemShopContainerVC.fillPicker(items: Weapon.getAllWeapons())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let itemShopContainerVC = segue.destination as? ItemShopViewController {
            self.itemShopContainerVC = itemShopContainerVC
        }
    }
}
