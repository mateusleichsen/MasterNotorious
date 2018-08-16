//
//  StatusViewController.swift
//  NavigatorTest
//
//  Created by Tiago Leichsenring on 08.08.18.
//  Copyright © 2018 Tiago Leichsenring. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem?.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        statusOpen = false
        self.view.removeFromSuperview()
    }
}
