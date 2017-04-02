//
//  StargazersTableViewController.swift
//  Stargazers
//
//  Created by Paolo Malpeli on 28/03/2017.
//  Copyright © 2017 Paolo Malpeli. All rights reserved.
//

import UIKit
import PKHUD
import SwiftyJSON

class StargazersTableViewController: UITableViewController {
	var stargazers = [Stargazer]()
	var currentPage = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.navigationItem.title = "\(self.stargazerDelegate.owner)/\(self.stargazerDelegate.repo)"
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		loadNextPage(nil)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
		self.stargazers.forEach { $0.avatar = nil }
    }
	
	// Manage pagination
	func loadNextPage(_ callback: ((Bool)->())?) {
		currentPage += 1
		HUD.show(HUDContentType.labeledProgress(title: "", subtitle: "Loading Stargazers..."))
			
		self.stargazerDelegate.loadStargazersPage(currentPage: currentPage) { response in
			switch response {
			case .ok(let json):
				let pagedStargazers = Stargazer.createStargazer(fromJSON: json)
				self.stargazers.append(contentsOf: pagedStargazers)
				self.tableView.reloadData()
				HUD.hide()
			case .error(let message):
				HUD.flash(HUDContentType.labeledError(title: "Error", subtitle: message), delay: 3.0)
			}
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
