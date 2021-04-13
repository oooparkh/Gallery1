//
//  Registration2ViewController.swift
//  Gallery
//
//  Created by Alexey on 23.02.21.
//

import UIKit
import SwiftyKeychainKit

class RegistrationViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var myView: UIView!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var reEnterPasswordTextField: UITextField!
    let keychain = Keychain(service: "alex.Gallery")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        reEnterPasswordTextField.isSecureTextEntry = true
        reEnterPasswordTextField.delegate = self
        passwordTextField.delegate = self
        loginTextField.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
   
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.myView.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        registerButton.layer.cornerRadius = 25
    
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            print(keyboardFrame)
            let bottomInset = keyboardFrame.height
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
            scrollView.contentInset = insets
        }
        print("Keyboard did show")
    }
    
    @objc func keyboardWillHide() {
        scrollView.contentInset = .zero
    }
    @IBAction func registerButtonPressed(_ sender: Any) {
        let keychainKey = KeychainKey<String>(key: self.loginTextField?.text ?? "")
        if self.passwordTextField?.text == self.reEnterPasswordTextField?.text  {
            if (try? self.keychain.get(keychainKey)) != nil {
                self.showErrorRegistrationAlert()
            } else {
                let password = self.passwordTextField?.text ?? ""
                try? self.keychain.set(password, for: keychainKey)
                self.openSuccessfulRegistrationAlert()
            }
        } else {
            showErrorPasswordAlert()
            
        }
    }

    
    func showNoLoginAlert() {
        let alert = UIAlertController(title: "Error", message: "Enter login", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorPasswordAlert() {
        let alert = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorRegistrationAlert() {
        let alert = UIAlertController(title: "Error", message: "That login is taken. Try another.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func openSuccessfulRegistrationAlert() {
        let alert = UIAlertController(title: "Thanks for registraion", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}




extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if loginTextField.text?.isEmpty ?? true {
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField.text?.isEmpty ?? true {
            passwordTextField.becomeFirstResponder()
        } else if reEnterPasswordTextField.text?.isEmpty ?? true {
            reEnterPasswordTextField.becomeFirstResponder()
        } else {
        self.view.endEditing(true)
        }
        return false
    }
}
