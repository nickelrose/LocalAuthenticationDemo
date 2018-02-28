//
//  LocalAuthenticationViewController.swift
//  LocalAuthenticationDemo
//
//  Created by Nicholas Rose on 2/26/18.
//  Copyright © 2018 Nicholas Rose. All rights reserved.
//

import UIKit
import LocalAuthentication

enum LocalAuthenticationFeature: Int, Iteratable {
    case createContext = 0
    case invalidateContext
    case canAuthenticate
    case canAuthenticateUsingBiometrics
    case isInteractionNotAllowed
    case biometricType
    case evaluateDeviceOwner
    case evaluateDeviceOwnerBiometrics
    case touchIDAuthenticationAllowableReuseDuration
    case setTouchIDAuthenticationAllowableReuseDuration
    
    var stringValue: String {
        switch self {
        case .createContext:
            return "Create a new LAContext"
        case .invalidateContext:
            return "Invalidate context"
        case .canAuthenticate:
            return "Can this device use LocalAuthentication?"
        case .canAuthenticateUsingBiometrics:
            return "Can this device use Biometrics?"
        case .isInteractionNotAllowed:
            return "Can authentication be interactive?"
        case .biometricType:
            return "What Biometry type is supported?"
        case .evaluateDeviceOwner:
            return "Evaluate as the device owner"
        case .evaluateDeviceOwnerBiometrics:
            return "Evaluate as the device owner using Biometrics"
        case .touchIDAuthenticationAllowableReuseDuration:
            return "How long before we have to re-authenticate?"
        case .setTouchIDAuthenticationAllowableReuseDuration:
            return "Set allowable reuse duration"
        }
    }
    
    static var features: [LocalAuthenticationFeature] {
        return LocalAuthenticationFeature.hashValues().map({ $0 })
    }
}

protocol LocalAuthenticationFeatureDemo {
    func demo(_ feature: LocalAuthenticationFeature)
    func demoCreateContext()
    func demoInvalidateContext()
    func demoCanAuthenticate()
    func demoCanAuthenticateUsingBiometrics()
    func demoIsInteractionNotAllowed()
    func demoBiometricType()
    func demoEvaluateDeviceOwner()
    func demoEvaluateDeviceOwnerBiometrics()
    func demoTouchIDAuthenticationAllowableReuseDuration()
    func demoSetTouchIDAuthenticationAllowableReuseDuration()
}

class LocalAuthenticationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var context: LAContext = LAContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style View
        self.tableView.tableFooterView = UIView()
    }
    
    func presentAlertController(with message: String) {
        let alertController = UIAlertController(title: "Result", message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(ok)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// Features
extension LocalAuthenticationViewController: LocalAuthenticationFeatureDemo {
    func demo(_ feature: LocalAuthenticationFeature) {
        switch feature {
        case .createContext:
            demoCreateContext()
        case .invalidateContext:
            demoInvalidateContext()
        case .canAuthenticate:
            demoCanAuthenticate()
        case .canAuthenticateUsingBiometrics:
            demoCanAuthenticateUsingBiometrics()
        case .isInteractionNotAllowed:
            demoIsInteractionNotAllowed()
        case .biometricType:
            demoBiometricType()
        case .evaluateDeviceOwner:
            demoEvaluateDeviceOwner()
        case .evaluateDeviceOwnerBiometrics:
            demoEvaluateDeviceOwnerBiometrics()
        case .touchIDAuthenticationAllowableReuseDuration:
            demoTouchIDAuthenticationAllowableReuseDuration()
        case .setTouchIDAuthenticationAllowableReuseDuration:
            demoSetTouchIDAuthenticationAllowableReuseDuration()
        }
    }
    
    func demoCreateContext() {
        self.context = LAContext()
        self.presentAlertController(with: "Context Created")
    }
    
    func demoInvalidateContext() {
        self.context.invalidate()
        self.presentAlertController(with: "Context Invalidated")
    }
    
    func demoCanAuthenticate() {
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            presentAlertController(with: "Yes we can!")
        }
        else {
            guard  let error = error as? LAError  else {
                presentAlertController(with: "Something went wrong.")
                return
            }
            
            presentAlertController(with: error.localizedDescription)
        }
    }
    
    func demoCanAuthenticateUsingBiometrics() {
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            presentAlertController(with: "Yes we can!")
        }
        else {
            guard  let error = error as? LAError  else {
                presentAlertController(with: "Something went wrong.")
                return
            }
            
            presentAlertController(with: error.localizedDescription)
        }
    }
    
    func demoIsInteractionNotAllowed() {
        if context.interactionNotAllowed {
            presentAlertController(with: "Interaction is not allowed")
        }
        else {
            presentAlertController(with: "Interaction is allowed")
        }
    }
    
    func demoBiometricType() {
        let type = context.biometryType
        
        switch type {
        case .none:
            self.presentAlertController(with: "Device policy has not been evaluated or the device is not capable of using biometrics.")
        case .touchID:
            self.presentAlertController(with: "TouchID is supported on this device.")
        case .faceID:
            self.presentAlertController(with: "FaceID is supported on this device.")
        }
    }
    
    func demoEvaluateDeviceOwner() {
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Because... reasons.") { (success, error) in
            if success {
                self.presentAlertController(with: "Success!")
            }
            else {
                if let error = error as? LAError {
                    self.presentAlertController(with: error.localizedDescription)
                }
            }
        }
    }
    
    func demoEvaluateDeviceOwnerBiometrics() {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Because... reasons.") { (success, error) in
            if success {
                self.presentAlertController(with: "Success!")
            }
            else {
                if let error = error as? LAError {
                    self.presentAlertController(with: error.localizedDescription)
                }
            }
        }
    }
    
    func demoTouchIDAuthenticationAllowableReuseDuration() {
        self.presentAlertController(with: "We'll have to re-authenticate in \(context.touchIDAuthenticationAllowableReuseDuration) seconds")
    }
    
    func demoSetTouchIDAuthenticationAllowableReuseDuration() {
        let alertViewController = UIAlertController(title: "Duration", message: "Enter a new LAContext duration", preferredStyle: .alert)
        alertViewController.addTextField { (textField) in
            textField.placeholder = "Duration"
        }
        
        let doneAction = UIAlertAction(title: "OK", style: .default) { (action) in
            guard let text = alertViewController.textFields?.first?.text, let timeInterval = TimeInterval(text) else {
                self.presentAlertController(with: "Not a valid time interval")
                return
            }
            
            self.context.touchIDAuthenticationAllowableReuseDuration = timeInterval
            
            self.presentAlertController(with: "Context will be reusable for \(self.context.touchIDAuthenticationAllowableReuseDuration) seconds")
        }
        
        alertViewController.addAction(doneAction)
        
        self.present(alertViewController, animated: true, completion: nil)
    }
}

// Table View Delegate
extension LocalAuthenticationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let feature = LocalAuthenticationFeature.features[indexPath.row]
        
        demo(feature)
    }
}

// Table View Data Source
extension LocalAuthenticationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocalAuthenticationFeature.features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocalAuthenticationCell") else {
            return UITableViewCell()
        }
        
        let feature = LocalAuthenticationFeature.features[indexPath.row]
        
        cell.textLabel?.text = feature.stringValue
        
        return cell
    }
}
