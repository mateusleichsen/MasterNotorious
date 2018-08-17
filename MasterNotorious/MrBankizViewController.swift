//
//  MrBankizViewController.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 11.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import UIKit

class MrBankizViewController: UIViewController {
    @IBOutlet weak var depositText: UITextField!
    @IBOutlet weak var withdrawText: UITextField!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var bankGoldLabel: UILabel!
    @IBOutlet weak var loanText: UITextField!
    @IBOutlet weak var borrowLabel: UILabel!
    var timer:RepeatingTimer?
    var borrowValue:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        borrowValue = Int(20 * Double((player?.level.current)! + 1) * 0.5 + (Double((player?.level.current)! +  10) * 1.8))
        updateLabels()
        timer = RepeatingTimer(timeInterval: 10)
        timer?.eventHandler = {
            self.updateLabels()
        }
        timer?.resume()
        
        // Do any additional setup after loading the view.
    }

    override func viewDidDisappear(_ animated: Bool) {
        timer = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func depositTapped(_ sender: Any) {
        if depositText.text == nil {
            showAlert(title: "Hmm", message: "You should put some number there", uiViewController: self)
            return
        }
        if Int(depositText.text!) == nil {
            showAlert(title: "Sorry", message: "But we use numbers to deposit, maybe in the futere we can accept letters", uiViewController: self)
            return
        }
        var deposit = Int(depositText.text!)!
        if deposit < 0 {
            deposit = -deposit
        }
        if deposit == 0 || deposit > (player?.gold)! {
            deposit = (player?.gold)!
        }
        
        player?.gold -= deposit
        bank?.deposit(value: deposit)
        updateLabels()
        showAlert(title: "Thanks", message: "Your money was deposited, Total: \(deposit)", uiViewController: self)
    }
    
    @IBAction func withdrawTapped(_ sender: Any) {
        if withdrawText.text == nil {
            showAlert(title: "Hmm", message: "You should put some number there", uiViewController: self)
            return
        }
        if Int(withdrawText.text!) == nil {
            showAlert(title: "Sorry", message: "But we use numbers to withdraw, maybe in the futere we can accept letters", uiViewController: self)
            return
        }
        var withdraw = Int(withdrawText.text!)!
        if withdraw < 0 {
            withdraw = -withdraw
        }
        if withdraw == 0 {
            withdraw = (player?.gold)!
        }
        
        withdraw = (bank?.withdraw(value: withdraw))!
        player?.gold += withdraw
        updateLabels()
        showAlert(title: "Thanks", message: "Here is your money, Total: \(withdraw)", uiViewController: self)
    }
    
    @IBAction func loanTapped(_ sender: Any) {
        if loanText.text == nil {
            showAlert(title: "Hmm", message: "You should put some number there", uiViewController: self)
            return
        }
        if Int(loanText.text!) == nil {
            showAlert(title: "Sorry", message: "But we use numbers, maybe in the futere we can accept letters", uiViewController: self)
            return
        }
        var loan = Int(loanText.text!)!
        if loan <= 0 {
            showAlert(title: "Ops", message: "If you want lend money to us, use the deposit.", uiViewController: self)
            return
        }
        
        loan = (bank?.takeLoan(value: loan, level: (player?.level.current)!))!
        if loan == 0 {
            showAlert(title: "No more money", message: "You have borrowed enough money, better you pay it.", uiViewController: self)
            return
        }
        player?.gold += loan
        updateLabels()
        showAlert(title: "Thanks", message: "Here is your money, Total: \(loan)", uiViewController: self)
    }
    
    fileprivate func updateLabels() {
        DispatchQueue.main.async {
            self.goldLabel.text = "\(player?.gold ?? 0)"
            let doubleAmount = NSDecimalNumber(decimal: bank?.amount ?? 0).doubleValue
            self.bankGoldLabel.text = NSString(format: "%.4f", doubleAmount) as String
            self.borrowLabel.text = "\(self.borrowValue!)gp"
            playerRepository.updatePlayer(player: player!)
            bankRepository.updateBankData(bank: bank!)
        }
    }
}
