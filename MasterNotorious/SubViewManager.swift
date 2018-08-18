//
//  SubViewManager.swift
//  MasterNotorious
//
//  Created by Mateus Leichsenring on 18.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation
import UIKit

class SubViewManager {
    var storyboardName:String
    var parentView:UIView
    var parentViewController:UIViewController
    var currentChildViewController:UIViewController?
    
    init(storyboardName:String, parentView:UIView, parentViewController:UIViewController) {
        self.storyboardName = storyboardName
        self.parentView = parentView
        self.parentViewController = parentViewController
    }
    
    func instantiateViewController(identifier:String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        
        self.add(asChildViewController: viewController)
        return viewController
    }
    
    func updateView(nextViewController:UIViewController) {
        if currentChildViewController != nil {
            remove(asChildViewController: currentChildViewController!)
        }
        add(asChildViewController: nextViewController)
        currentChildViewController = nextViewController
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        parentViewController.addChildViewController(viewController)
        
        // Add Child View as Subview
        parentView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = parentView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: parentViewController)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
}
