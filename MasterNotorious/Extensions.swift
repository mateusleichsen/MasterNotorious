//
//  extensions.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 07.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    mutating func incrementByLevel(_ level:Int) {
        self = Int(Double(self) * (1 + (Double(level) * 0.15)))
    }
    
    mutating func incrementByMode(_ mode:eMode) {
        self = Int(Double(self) * (1 + (Double(mode.rawValue) * 0.2)))
    }
}

extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        if self.contentSize.height + 50 < self.bounds.size.height {
            return
        }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height + 50 - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}

extension UIView {
    func hide() {
        self.alpha = 0
    }
    
    func show() {
        self.alpha = 1
    }
}

extension Array where Element == (Date,Decimal) {
    func sum() -> Decimal {
        var result:Decimal = 0.00
        for element in self {
            result += element.1
        }
        return result
    }
}

extension Decimal {
    func rounded(toPlaces places:Int) -> Decimal {
        let divisor = pow(10.0, Double(places))
        let value = (NSDecimalNumber(decimal: self).doubleValue * divisor).rounded() / divisor
        return NSDecimalNumber(value: value) as Decimal
    }
}

extension UIImage {
    func croppedInRect(rect: CGRect) -> UIImage {
        func rad(_ degree: Double) -> CGFloat {
            return CGFloat(degree / 180.0 * .pi)
        }
        
        let imageRef = self.cgImage!.cropping(to: rect)
        let result = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return result
    }
}

extension Player {
    //create dictionary; call repository
}
