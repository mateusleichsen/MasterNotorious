//
//  MenuViewController.swift
//  MasterNotorious
//
//  Created by Tiago Leichsenring on 19.08.18.
//  Copyright © 2018 Tiago Leichsenring. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    var delegate:MenuViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        print("reset menu")
        delegate?.reset()
    }
}
