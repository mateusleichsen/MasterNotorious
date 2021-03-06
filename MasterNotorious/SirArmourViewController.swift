//
//  SirArmourViewController.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 11.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import UIKit

class SirArmourViewController: UIViewController {
    var itemShopContainerVC:ItemShopViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        self.itemShopContainerVC.typeItemLabel = "armor"
        self.itemShopContainerVC.buyButtonTap = { item in
            player?.armor = item as? Armor
        }
        self.itemShopContainerVC.fillPicker(items: Armor.getAllArmor())
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
