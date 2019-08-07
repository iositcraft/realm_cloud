//
//  ViewController.swift
//  Demo
//
//  Created by Tomek on 06/08/2019.
//  Copyright © 2019 ITCraft. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        title = "Demo"
        updateNavigationBar()
    }
    
    private func updateNavigationBar() {
        if let _ = SyncUser.current {
            let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutBarButtonDidClick))
            navigationItem.rightBarButtonItems = [logoutBarButtonItem]
        } else {
            let loginBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(loginBarButtonDidClick))
            let registerBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerBarButtonDidClick))
            navigationItem.rightBarButtonItems = [loginBarButtonItem, registerBarButtonItem]
        }
    }
    
    @objc func loginBarButtonDidClick() {
       showAlert(isRegister: false)
    }
    
    @objc func registerBarButtonDidClick() {
        showAlert(isRegister: true)
    }
    
    private func showAlert(isRegister: Bool) {
        let title = isRegister ? "Register" : "Login"
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let mainAction = UIAlertAction(title: title, style: .default, handler: { [unowned self] alert -> Void in
            let emailTextField = alertController.textFields![0] as UITextField
            let passwordTextField = alertController.textFields![1] as UITextField
            self.doAction(email: emailTextField.text, password: passwordTextField.text, isRegister: isRegister)
        })
        
        mainAction.isEnabled = false
        alertController.addAction(mainAction)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addTextField(configurationHandler: { [unowned self] textField in
            textField.addTarget(self, action: #selector(self.alertControllerTextFieldDidChange(_:)), for: .editingChanged)
            textField.placeholder = "E-mail"
            textField.keyboardType = .emailAddress
        })
        alertController.addTextField(configurationHandler: { [unowned self] textField in
            textField.addTarget(self, action: #selector(self.alertControllerTextFieldDidChange(_:)), for: .editingChanged)
            textField.isSecureTextEntry = true
            textField.placeholder = "password (min length 6)"
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func alertControllerTextFieldDidChange(_ sender: UITextField) {
        let alertController = self.presentedViewController as! UIAlertController
        let emailTextField = alertController.textFields![0] as UITextField
        let passwordTextField = alertController.textFields![1] as UITextField
        
        if let alertVC = self.presentedViewController as? UIAlertController {
            if let email = emailTextField.text, let password = passwordTextField.text, let mainAction = alertVC.actions.first {
                //we required correct email address and min. 6 characters for password
                mainAction.isEnabled = email.isValidEmail() && password.count >= 6
            }
        }
    }
    
    private func doAction(email: String?, password: String?, isRegister: Bool) {
        guard let email = email, let password = password else { return }
        
        let creds = SyncCredentials.usernamePassword(username: email, password: password, register: isRegister)
        
        SyncUser.logIn(with: creds, server: Constants.AUTH_URL) { [weak self] (user, error) in
            if let _ = user {
                self?.updateNavigationBar()
            } else if let error = error {
                //in real project we should have some logic here
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func logoutBarButtonDidClick() {
        let alertController = UIAlertController(title: "Logout", message: "", preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: "Yes, Logout", style: .destructive, handler: { [weak self] alert -> Void in
            SyncUser.current?.logOut()
            self?.updateNavigationBar()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

