//
//  Helpers.swift
//  NavigatorTest
//
//  Created by Mateus Leichsenring on 09.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation
import UIKit
import CoreData

func showAlert(title:String, message:String, uiViewController:UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    
    uiViewController.present(alert, animated: true)
}

func showAlert(title:String, message:String, uiViewController:UIViewController, actionToExecute: @escaping () -> Void) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            actionToExecute()
    }))
    
    uiViewController.present(alert, animated: true)
}

func showAlertInsertName(uiViewController: UIViewController, actionToExecute: @escaping (String) -> Void) {
    let alert = UIAlertController(title: "What's your name?", message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    alert.addTextField(configurationHandler: { textField in
        textField.placeholder = "Input your name here..."
    })
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        if let nameInserted = alert.textFields?.first?.text {
            actionToExecute(nameInserted)
        }
    }))
    
    uiViewController.present(alert, animated: true)
}

func requestAPI(urlSource:NSString, onCompletation: @escaping (Any) -> Void) {
    let configuration = URLSessionConfiguration.default
    let session = URLSession(configuration: configuration)
    let urlString = NSString(format: urlSource)
    
    let request : NSMutableURLRequest = NSMutableURLRequest()
    request.url = NSURL(string: NSString(format: "%@", urlString) as String)! as URL
    request.httpMethod = "GET"
    request.timeoutInterval = 30
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    let dataTask = session.dataTask(with: request as URLRequest) {
        (data: Data?, response: URLResponse?, error: Error?) -> Void in
        
        guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
        else {
            print("error: not a valid http response")
            return
        }
        
        switch (httpResponse.statusCode) {
            case 200:
                do {
                    let getResponse = try JSONSerialization.jsonObject(with: receivedData, options: .allowFragments)
                    onCompletation(getResponse)
                } catch {
                    print("error serializing JSON: \(error)")
                }
                break
            case 400:
                break
            default:
                print("wallet GET request got response \(httpResponse.statusCode)")
        }
    }
    
    dataTask.resume()
}

protocol EnumCollection: Hashable {
    static func cases() -> AnySequence<Self>
    static var allValues: [Self] { get }
}

extension EnumCollection {
    static func cases() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            return AnyIterator {
                let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else {
                    return nil
                }
                raw += 1
                return current
            }
        }
    }
    
    static var allValues: [Self] {
        return Array(self.cases())
    }
    
    static var count: Int {
        return Array(self.cases()).count
    }
}

class RepeatingTimer {
    let timeInterval: TimeInterval
    
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    private lazy var timer: DispatchSourceTimer = {
        let timeTasker = DispatchSource.makeTimerSource()
        timeTasker.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        timeTasker.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return timeTasker
    }()
    
    var eventHandler: (() -> Void)?
    
    private enum State {
        case suspended
        case resumed
    }
    
    private var state: State = .suspended
    
    deinit {
        timer.setEventHandler {}
        timer.cancel()
        resume()
        eventHandler = nil
    }
    
    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
}

class Repository {
    var context:NSManagedObjectContext!
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    func saveObj(obj:[String:Any], entityName:String) {
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        
        updateObj(managedObject: managedObject, obj: obj)
    }
    
    func readObjString(_ entity: String, forKey key:String, value:String) -> NSManagedObject? {
        let objList = readObjList(entity)
        
        for obj in objList {
            if let item = obj.value(forKey: key) {
                let itemCasted = item as! String
                if itemCasted == value {
                    return obj
                }
            }
        }
        
        return nil
    }
    
    func readObjInt(_ entity: String, forKey key:String, value:Int) -> NSManagedObject? {
        let objList = readObjList(entity)
        
        for obj in objList {
            if let item = obj.value(forKey: key) {
                let itemCasted = item as! Int
                if itemCasted == value {
                    return obj
                }
            }
        }
        
        return nil
    }
    
    func readObjList(_ entity: String) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try context.fetch(fetchRequest)
            
            if let records = records as? [NSManagedObject] {
                result = records
            }
            
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        
        return result
    }
    
    func updateObj(managedObject:NSManagedObject, obj:[String:Any]) {
        for element in obj {
            managedObject.setValue(element.1, forKey: element.0)
        }
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
}
