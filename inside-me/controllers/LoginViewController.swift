//
//  ViewController.swift
//  inside-me
//
//  Created by Victor Hugo on 4/17/20.
//  Copyright © 2020 Victor Hugo. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {

    @IBOutlet weak var comeInto: UIButton!
    @IBOutlet weak var biometricIdButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authBiometricLogin()
    }

    @IBAction func comeIntoAction(_ sender: Any) {
        
    }
        
    @IBAction func AuthBiometricClick(_ sender: Any) {
        authBiometricLogin()
    }
    
    func authBiometricLogin() {
        let currentType = LAContext().biometricType
        
        if currentType.rawValue == "touchID" {
            authenticateUsingTouchID()
        }
        
        if currentType.rawValue == "faceID" {
            authenticateUsingFaceID()
        }
    }
    
    func authenticateUsingTouchID() {
        let authContext = LAContext()
        let authReason = "Please uuse TouchID to authenticate"
        var authError: NSError?
        
        if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: authReason, reply: { (success, error) -> Void in
                if success {
                    DispatchQueue.main.async {
                        print("Authenticated!")
                    }
                } else {
                    print("Error auth")
                }
            })
        } else {
            print(authError?.localizedDescription)
            self.biometricIdButton.isHidden = true
        }
    }
    
    func authenticateUsingFaceID() {
        print("authenticateUsingFaceID")
    }
}


extension LAContext {
    enum BiometricType: String {
        case none
        case touchID
        case faceID
    }

    var biometricType: BiometricType {
        var error: NSError?

        guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            // Capture these recoverable error thru Crashlytics
            return .none
        }

        if #available(iOS 11.0, *) {
            switch self.biometryType {
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            default:
                return .none
            }
        } else {
            return self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
        }
    }
}
