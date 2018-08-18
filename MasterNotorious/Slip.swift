//
//  Slip.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 10.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation

struct Slip {
    var advice:String
    var slip_id:Int
    
    init(_ value: Dictionary<String, Dictionary<String, AnyObject>>) {
        advice = value["slip"]!["advice"] as! String
        slip_id = Int(value["slip"]!["slip_id"] as! String)!
    }
}
