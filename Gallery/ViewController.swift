//
//  ViewController.swift
//  Gallery
//
//  Created by Alexey on 17.01.21.
//

import UIKit
import SwiftyKeychainKit

class ViewController: UIViewController {

    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    let keychain = Keychain(service: "alex.Gallery")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        loginTextField.delegate = self
        passwordTextField.delegate = self

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        registrationButton.layer.cornerRadius = 25
        signInButton.layer.cornerRadius = 25
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Invalid data or not registered user",
        preferredStyle: .alert)
        
        let enterAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(enterAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        let keychainKey = KeychainKey<String>(key:self.loginTextField?.text ?? "")
        if (self.loginTextField.text != ""), self.passwordTextField.text != "" {
            if (try? self.keychain.get(keychainKey)) == self.passwordTextField?.text {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let galleryViewController = storyboard.instantiateViewController(identifier: String(describing: GalleryViewController.self)) as GalleryViewController
                galleryViewController.modalPresentationStyle = .fullScreen
                UserDefaults.standard.setValue(self.loginTextField?.text, forKey: "Login")
                self.navigationController?.pushViewController(galleryViewController, animated: true)
            
        } else {
                self.showErrorAlert()
                return
        }
        }

    }
    
    @IBAction func registrationButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registrationViewController = storyboard.instantiateViewController(identifier:
        String(describing: RegistrationViewController.self)) as RegistrationViewController
        registrationViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(registrationViewController, animated: true)
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if loginTextField.text?.isEmpty ?? true {
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField.text?.isEmpty ?? true {
            passwordTextField.becomeFirstResponder()
        } else {
        self.view.endEditing(true)
        }
        return false
    }
}
