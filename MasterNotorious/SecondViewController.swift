//
//  SecondViewController.swift
//  NavigatorTest
//
//  Created by Tiago Leichsenring on 04.08.18.
//  Copyright © 2018 Tiago Leichsenring. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    var text:String = ""
    @IBOutlet weak var lbl1: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        lbl1.text = text
    }
    
    @IBAction func btnTap(_ sender: Any) {
        lbl1.isHidden = !lbl1.isHidden
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
