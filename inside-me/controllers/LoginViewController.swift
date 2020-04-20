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
        authBiometricID()
    }

    @IBAction func comeIntoAction(_ sender: Any) {
        performSegue(withIdentifier: "segueToHome", sender: nil)
    }
        
    @IBAction func AuthBiometricClick(_ sender: Any) {
        authBiometricID()
    }

    func authBiometricID() {
        let currentType = LAContext().biometricType
        
         switch currentType {
             case .touchID:
                 biometricIdButton.setImage(UIImage(named: "biometric_touchid"), for: .normal)
             
             case .faceID:
                 biometricIdButton.setImage(UIImage(named: "biometric_faceid"), for: .normal)
             default:
                 biometricIdButton.isHidden = true
             }
        
        let authContext = LAContext()
        let authReason = Bundle.main.infoDictionary?["NSFaceIDUsageDescription"] as! String
        var authError: NSError?
        
        if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: authReason, reply: { (success, error) -> Void in
                if success {
                    DispatchQueue.main.async {
                        print("Authenticated!")
                        self.performSegue(withIdentifier: "segueToHome", sender: nil)
                    }
                } else {
                    print("Error auth")
                }
            })
        } else {
          print(authError?.localizedDescription)
      }
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
