//
//  ItemShopViewController.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 11.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import UIKit

class ItemShopViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var smithPhraseLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    var pickerData:[String] = []
    var items:[Item] = []
    var priceDiscount = 0
    var buyButtonTap:(_ item:Item) -> Void = {_ in }
    var typeItemLabel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buyTapped(_ sender: Any) {
        let item = items[pickerView.selectedRow(inComponent: 0)]
        if (player?.gold)! < item.price - priceDiscount {
            showAlert(title: "Oh!", message: "You need more gold pieces to buy \(item.name)", uiViewController: self)
        } else {
            player?.spend(item.price - priceDiscount)
            buyButtonTap(item)
            updateLabels(item: item)
            UserDefaultData.saveObj(obj: player!, key: defaultKeys.playerDataKey)
            UserDefaultData.saveObj(obj: bank!, key: defaultKeys.bankDataKey)
            showAlert(title: "Have a nice hunt!", message: "You have bought \(item.name) for \(item.price)gp", uiViewController: self)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int ) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
    
    func fillPicker<T:Item>(items:[T]) {
        let startPrice:Double = 10
        var previousPrice:Int = 0
        for (index, element) in items.enumerated() {
            if !(element is Jewelry) {
                let price = Int(startPrice * Double(index + 1) * 0.5 + (Double(index +  10) * 1.8)) + previousPrice
                previousPrice = price
                element.price = price
            }
            pickerData.append("\(element.name) - \(element.price)gp")
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(0, inComponent: 0, animated: true)
        self.items = items
        updateLabels(item: items[0] is Weapon ? (player?.weapon)! : (items[0] is Armor ? (player?.armor)! : (items[0] is Jewelry ? (player?.jewelry)! : items[0])))
    }
    
    fileprivate func updateLabels(item:Item) {
        priceDiscount = item.price > 0 ? Int(Double(item.price) * 0.2) : 10
        goldLabel.text = "\(player?.gold ?? 0)"
        itemLabel.text = "\(item.name)"
        smithPhraseLabel.text = "Buy a \(typeItemLabel) and I buy your \(item.name) for \(priceDiscount)gp."
    }
}
