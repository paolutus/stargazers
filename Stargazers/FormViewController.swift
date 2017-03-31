//
//  ViewController.swift
//  Stargazers
//
//  Created by Paolo Malpeli on 28/03/2017.
//  Copyright © 2017 Paolo Malpeli. All rights reserved.
//

import UIKit
import PKHUD
import Alamofire
import SwiftyJSON

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
			checkRepo(owner: owner, repo: repo) { ok, json in
				if ok {
					HUD.flash(.success, delay: 0.5) { finished in
						self.performSegue(withIdentifier: StargazersSegue.stargazers.identifier, sender: json)
					}
				} else if let message = json["message"].string {
					HUD.flash(HUDContentType.labeledError(title: "Error", subtitle: message), delay: 3.0)
				} else {
					HUD.flash(HUDContentType.labeledError(title: "Error", subtitle: "Unknown Error"), delay: 3.0)
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
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch segue.identifier! {
		case StargazersSegue.stargazers.identifier:
			guard let json = sender as? JSON else {
				fatalError("It's my fault, fix the github response API management")
			}
			guard let stargazerViewController = segue.destination as? StargazersTableViewController else {
				fatalError("It's my fault, there is a bug in my storyboard")
			}
			stargazerViewController.repoDetails = json
		default:
			fatalError("It's my fault, there is a bug in my code")
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		goButton.isEnabled = false
		ownerTextField.delegate = self
		repositoryTextField.delegate = self
	}

	// check input data by loading repo details
	func checkRepo(owner:String, repo:String, callback:@escaping (Bool, JSON)->()) {
		if let url = GitHubEntryPoint.repoDetails(owner: owner, repo: repo).url {
			Alamofire.request(url).validate().responseJSON { response in
				switch response.result {
				case .success(let jsonData):
					let json = JSON(jsonData)
					callback(true, json)
				case .failure(let error):
					if let data = response.data {
						let json = JSON(data: data)
						callback(false, json)
					} else {
						callback(false, ["message":"\(error.localizedDescription)"])
					}
				}
			}
		} else {
			HUD.flash(HUDContentType.labeledError(title: "Error", subtitle: "Invalid URL"), delay: 3.0)
		}
	}

	// MARK: - UITextFieldDelegate
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

