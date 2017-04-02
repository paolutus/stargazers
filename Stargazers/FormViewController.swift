//
//  ViewController.swift
//  Stargazers
//
//  Created by Paolo Malpeli on 28/03/2017.
//  Copyright © 2017 Paolo Malpeli. All rights reserved.
//

import UIKit
import PKHUD

// available segues
enum StargazersSegue: String {
	case stargazers = "StargazersSegue"
	
	var identifier : String {
		return self.rawValue
	}
}

class FormViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var ownerTextField: UITextField!
	@IBOutlet weak var repositoryTextField: UITextField!
	
	@IBOutlet weak var goButton: UIButton!
	
	@IBAction func goButtonPressed(_ sender: Any) {
		if let owner = ownerTextField.text, let repo = repositoryTextField.text {
			HUD.show(HUDContentType.labeledProgress(title: "Checking Repo...", subtitle: "\(owner)/\(repo)"))
			self.stargazerDelegate.useRepo(owner: owner, repo: repo) { response in
				switch response {
				case .ok:
					HUD.flash(.success, delay: 0.5) { finished in
						self.performSegue(withIdentifier: StargazersSegue.stargazers.identifier, sender: nil)
					}
				case .error(let message):
					HUD.flash(HUDContentType.labeledError(title: "Error", subtitle: message), delay: 3.0)
				}
			}
		}
	}
	
	@IBAction func textFieldChanged(_ sender: Any) {
		if let owner = ownerTextField.text, !owner.isEmpty, let repository = repositoryTextField.text, !repository.isEmpty {
			goButton.isEnabled = true
		} else {
			goButton.isEnabled = false
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		goButton.isEnabled = false
		ownerTextField.delegate = self
		repositoryTextField.delegate = self
	}

	// MARK: - UITextFieldDelegate
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

