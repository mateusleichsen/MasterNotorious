//
//  Bank.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 11.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation

class Bank {
    var amount:Decimal {
        get {
            return deposits.sum() - loans.sum()
        }
    }
    private(set) var deposits:[(Date,Decimal)] = []
    private(set) var loans:[(Date,Decimal)] = []
    var timer:RepeatingTimer?
    
    func loadDeposits(_ data:[(Date,Decimal)]) {
        self.deposits = data
    }
    
    func loadLoans(_ data:[(Date,Decimal)]) {
        self.loans = data
    }
    
    func deposit(value:Int) {
        if value == 0 {
            return
        }
        
        if deposits.count == 0 {
            runInterest()
        }
        
        let newValue = payOffLoan(value: value)
        if  newValue > 0 {
            deposits.append((Date(), newValue))
        }
    }
    
    func withdraw(value:Int) -> Int {
        if amount < Decimal(value) {
            let withdraw = amount
            deposits = []
            return NSDecimalNumber(decimal: withdraw).intValue
        }
        
        var depositToRemove:[Int] = []
        var amountToWithdraw = Decimal(value)
        for (index, element) in deposits.enumerated() {
            if element.1 >= amountToWithdraw {
                let newValue = element.1 - amountToWithdraw
                deposits[index] = (deposits[index].0, newValue)
                if newValue == 0 {
                    depositToRemove.append(index)
                }
                break
            } else {
                depositToRemove.append(index)
                amountToWithdraw -= element.1
            }
        }
        
        for elementIndex in depositToRemove {
            deposits.remove(at: elementIndex)
        }
        
        return value
    }
    
    func cleanAccount() {
        deposits = []
        loans = []
        timer?.suspend()
    }
    
    func takeLoan(value: Int, level: Int) -> Int {
        let totalLoan = loans.sum() + Decimal(value)
        if totalLoan > Decimal(Bank.borrowValue(level: level)) {
            return 0
        }
        
        if loans.count == 0 {
            runInterest()
        }
        
        loans.append((Date(), Decimal(value)))
        return value
    }
    
    static func borrowValue(level: Int) -> Int {
        return Int(20 * Double(level + 1) * 0.5 + (Double(level +  10) * 1.8))
    }
    
    private func payOffLoan(value: Int) -> Decimal {
        if loans.count == 0 {
            return Decimal(value)
        }
        
        var loanToRemove:[Int] = []
        var amountToDeposit = Decimal(value)
        for (index, element) in loans.enumerated() {
            if element.1 >= amountToDeposit {
                let newValue = element.1 - amountToDeposit
                deposits[index] = (deposits[index].0, newValue)
                if newValue == 0 {
                    loanToRemove.append(index)
                }
                break
            } else {
                loanToRemove.append(index)
                amountToDeposit -= element.1
            }
        }
        
        for elementIndex in loanToRemove {
            loans.remove(at: elementIndex)
        }
        
        return amountToDeposit
    }
    
    private func calculateInterest() {
        if deposits.count == 0 {
            return
        }
        
        for (index, element) in deposits.enumerated() {
            let intervalInterest = Int(Date().timeIntervalSince(element.0) / 60 / 10)
            if intervalInterest == 0 {
                continue
            }
            let newValue = element.1 * (1 + (0.01 * Decimal(intervalInterest)))
            deposits[index] = (Date(), newValue.rounded(toPlaces: 4))
        }
        
        for (index, element) in loans.enumerated() {
            let intervalInterest = Int(Date().timeIntervalSince(element.0) / 60 / 10)
            if intervalInterest == 0 {
                continue
            }
            let newValue = element.1 * (1 + (0.02 * Decimal(intervalInterest)))
            loans[index] = (Date(), newValue.rounded(toPlaces: 4))
        }
    }
    
    private func runInterest() {
        timer = RepeatingTimer(timeInterval: 60)
        timer?.eventHandler = {
            self.calculateInterest()
        }
        timer?.resume()
    }
}

enum eBankData:Int {
    case deposit = 0, loan = 1
}
