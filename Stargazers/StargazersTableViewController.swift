//
//  StargazersTableViewController.swift
//  Stargazers
//
//  Created by Paolo Malpeli on 28/03/2017.
//  Copyright © 2017 Paolo Malpeli. All rights reserved.
//

import UIKit
import PKHUD
import Alamofire
import SwiftyJSON

class StargazersTableViewController: UITableViewController {
	var stargazers = [Stargazer]()
	var owner : String!
	var repo : String!
	var currentPage = 0
	var perPage = 50
	
	var repoDetails : JSON? {
		didSet {
			guard let details = repoDetails else {
				stargazers = [Stargazer]()
				self.tableView.reloadData()
				return
			}
			
			guard let owner = details["owner"]["login"].string else {
				fatalError("Repository Description Data Format Error")
			}
			self.owner = owner
		
			guard let repo = details["name"].string else {
				fatalError("Repository Description Data Format Error")
			}
			self.repo = repo
			
			self.navigationItem.title = "\(owner)/\(repo)"
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		guard repoDetails != nil else {
			return
		}
		loadNextPage(nil)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
		self.stargazers.forEach { $0.avatar = nil }
    }
	
	// Manage pagination
	func loadNextPage(_ callback: ((Bool)->())?) {
		currentPage += 1
		if let url = GitHubEntryPoint.stargazers(owner: owner, repo: repo, page: currentPage, perPage: perPage).url {
			HUD.show(HUDContentType.labeledProgress(title: "", subtitle: "Loading Stargazers..."))
			
			Alamofire.request(url).validate().responseJSON { response in
				switch response.result {
				case .success(let jsonData):
					let json = JSON(jsonData)
					let pagedStargazers = Stargazer.createStargazer(fromJSON: json)
					self.stargazers.append(contentsOf: pagedStargazers)
					self.tableView.reloadData()
					HUD.hide()
					callback?(true)
				case .failure(let error):
					HUD.flash(HUDContentType.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 3.0)
					callback?(false)
				}
			}
		} else {
			HUD.flash(HUDContentType.labeledError(title: "Error", subtitle: "Invalid URL"), delay: 3.0)
			callback?(false)
		}
	}
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stargazers.count + 1
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell :UITableViewCell!
		if indexPath.row < self.stargazers.count {
			let stargazerCell = tableView.dequeueReusableCell(withIdentifier: "StargazerCell", for: indexPath) as! StargazerCell
			stargazerCell.stargazer = self.stargazers[indexPath.row]
			cell = stargazerCell
		} else {
			let loadCell = tableView.dequeueReusableCell(withIdentifier: "LoadCell", for: indexPath) as! LoadCell
			loadCell.delegate = self
			cell = loadCell
		}
		
        return cell
    }

}
