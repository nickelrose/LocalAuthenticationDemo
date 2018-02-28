//
//  SwiftKeychainViewController.swift
//  LocalAuthenticationDemo
//
//  Created by Nicholas Rose on 2/27/18.
//  Copyright © 2018 Nicholas Rose. All rights reserved.
//

import UIKit
import KeychainSwift

enum KeychainSwiftFeature: Int, Iteratable {
    case add
    case read
    case clear
    
    var stringValue: String {
        switch self {
        case .add:
            return "Add item to keychain"
        case .read:
            return "Read an item from the keychain"
        case .clear:
            return "Clear the keychain"
        }
    }
    
    static var features: [KeychainSwiftFeature] {
        return KeychainSwiftFeature.hashValues().map({ $0 })
    }
}

protocol KeychainSwiftFeatureDemo {
    func demo(_ feature: KeychainSwiftFeature)
    func demoAdd()
    func demoRead()
    func demoClear()
}

class SwiftKeychainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var keychain: KeychainSwift = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView()
    }
    
    func presentAlertController(with message: String) {
        let alertController = UIAlertController(title: "Result", message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(ok)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension SwiftKeychainViewController: KeychainSwiftFeatureDemo {
    func demo(_ feature: KeychainSwiftFeature) {
        switch feature {
        case .add:
            demoAdd()
        case .read:
            demoRead()
        case .clear:
            demoClear()
        }
    }
    
    func demoAdd() {
        let alertViewController = UIAlertController(title: "Add Item", message: "Add an item to the keychain", preferredStyle: .alert)
        alertViewController.addTextField { (textField) in
            textField.placeholder = "Key"
            textField.tag = 0
        }
        alertViewController.addTextField { (textField) in
            textField.placeholder = "Value"
            textField.tag = 1
        }
        
        let doneAction = UIAlertAction(title: "OK", style: .default) { (action) in
            guard let key = alertViewController.textFields?.first(where: { $0.tag == 0 })?.text, let value = alertViewController.textFields?.first(where: { $0.tag == 1 })?.text else {
                self.presentAlertController(with: "Invalid key value pair")
                return
            }
            
            let success = self.keychain.set(value, forKey: key)
            
            if success {
                self.presentAlertController(with: "\(key) has been set in the keychain with \(value)")
            }
            else {
                self.presentAlertController(with: "Failed to set \(key) into the keychain with \(value)")
            }
        }
        
        alertViewController.addAction(doneAction)
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func demoRead() {
        let alertViewController = UIAlertController(title: "Read Item", message: "Read an item from the keychain", preferredStyle: .alert)
        
        alertViewController.addTextField { (textField) in
            textField.placeholder = "Key"
        }
        
        let doneAction = UIAlertAction(title: "OK", style: .default) { (action) in
            guard let key = alertViewController.textFields?.first?.text else {
                self.presentAlertController(with: "Invalid key")
                return
            }
            
            if let value = self.keychain.get(key) {
                self.presentAlertController(with: "Retrieved \(value) from the keychain")
            }
            else {
                self.presentAlertController(with: "Failed to read \(key) from the keychain")
            }
        }
        
        alertViewController.addAction(doneAction)
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func demoClear() {
        let success = self.keychain.clear()
        
        if success {
            presentAlertController(with: "The keychain has been cleared.")
        }
        else {
            presentAlertController(with: "The keychain failed to clear.")
        }
    }
}

extension SwiftKeychainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let feature = KeychainSwiftFeature.features[indexPath.row]
        
        demo(feature)
    }
}

extension SwiftKeychainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return KeychainSwiftFeature.features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "KeychainSwiftCell") else {
            return UITableViewCell()
        }
        
        let feature = KeychainSwiftFeature.features[indexPath.row]
        
        cell.textLabel?.text = feature.stringValue
        
        return cell
    }
}
