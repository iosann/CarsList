//
//  AuthenticationViewController.swift
//  CarsList
//
//  Created by Anna Belousova on 05.05.2021.
//

import UIKit
import Firebase

class AuthenticationViewController: UIViewController {

	@IBOutlet var emailTextField: UITextField!
	@IBOutlet var passwordTextField: UITextField!
	@IBOutlet var signInButton: UIButton!
	@IBOutlet var registerButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		hideKeyboard()
		Auth.auth().addStateDidChangeListener { [weak self] auth, user in
			if user != nil {
				self?.performSegue(withIdentifier: "SignInSegue", sender: nil)
			}
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		emailTextField.text = ""
		passwordTextField.text = ""

		signInButton.layer.cornerRadius = 15
		signInButton.layer.borderWidth = 2.0
		signInButton.layer.borderColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
		signInButton.setTitleColor(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1.0), for: .normal)

		registerButton.layer.cornerRadius = 15
		registerButton.layer.borderWidth = 2.0
		registerButton.layer.borderColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
		registerButton.setTitleColor(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1.0), for: .normal)

	}

	func hideKeyboard() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
		self.view.addGestureRecognizer(tap)
	}

	@objc func endEditing() {
		view.endEditing(true)
	}

	func callAlert(withText text: String) {
		let alert = UIAlertController(title: "\(text)", message: nil, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
			alert.dismiss(animated: true, completion: nil)
		}))
		present(alert, animated: true)
	}

	@IBAction func signInTapped(_ sender: UIButton) {
		guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
			callAlert(withText: "Enter the email/password")
			return
		}
		Auth.auth().signIn(withEmail: email, password: password) { [weak self] dataResult, error in
			if error != nil {
				self?.callAlert(withText: "Such email and password not found")
				print(error?.localizedDescription ?? "Error: no discription")
				return
			}
			if dataResult != nil {
					self?.performSegue(withIdentifier: "SignInSegue", sender: nil)
					return
			}
		}
	}

	@IBAction func registerTapped(_ sender: UIButton) {
		guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
			callAlert(withText: "Enter the email and password")
			return
		}
		Auth.auth().createUser(withEmail: email, password: password) { [weak self] dataResult, error in
			if error != nil {
				self?.callAlert(withText: "Error occured, try again")
				print(error?.localizedDescription ?? "Error: no discription")
				return
			}
			if dataResult == nil {
				self?.callAlert(withText: "Select other email and password")
			}
		}
	}
}

