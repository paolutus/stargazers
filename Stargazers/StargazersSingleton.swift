//
//  StargazersSingleton.swift
//  Stargazers
//
//  Created by Paolo Malpeli on 02/04/2017.
//  Copyright © 2017 Paolo Malpeli. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum GitHubResponse {
	case ok(json:JSON)
	case error(message:String)
}

protocol StargazersDelegate {
	func useRepo(owner:String, repo:String, callback:@escaping (GitHubResponse)->())
	func loadStargazersPage(currentPage:Int, callback:@escaping (GitHubResponse)->())
	var owner : String { get }
	var repo : String { get }
	var stargazersPerPage : Int { set get }
}

extension UIViewController {
	var stargazerDelegate : StargazersDelegate {
		return StargazersSingleton.sharedInstance
	}
}

// GitHub endoint factory enum
enum GitHubEntryPoint {
	static let root = URL(string:"https://api.github.com")
	
	static let headers: HTTPHeaders = [
		"Accept": "application/vnd.github.v3+json"
	]
	
	case repoDetails(owner: String, repo: String)
	
	case stargazers(owner: String, repo: String, page: Int, perPage: Int)
	
	var url : URL? {
		switch self {
		case .repoDetails(let owner, let repo):
			return URL(string: "repos/\(owner)/\(repo)", relativeTo: GitHubEntryPoint.root)
		case .stargazers(let owner, let repo, let page, let perPage):
			return URL(string: "repos/\(owner)/\(repo)/stargazers?per_page=\(perPage)&page=\(page)", relativeTo: GitHubEntryPoint.root)
		}
	}
}

class StargazersSingleton: StargazersDelegate {
	static let sharedInstance = StargazersSingleton()
	
	var owner = ""
	var repo = ""
	
	var stargazersPerPage = 50
	
	// check input data by loading repo details
	func useRepo(owner:String, repo:String, callback:@escaping (GitHubResponse)->()) {
		if let url = GitHubEntryPoint.repoDetails(owner: owner, repo: repo).url {
			Alamofire.request(url).validate().responseJSON { response in
				switch response.result {
				case .success(let jsonData):
					let json = JSON(jsonData)
					
					guard let owner = json["owner"]["login"].string else {
						fatalError("Repository Description Data Format Error")
					}
					self.owner = owner
					
					guard let repo = json["name"].string else {
						fatalError("Repository Description Data Format Error")
					}
					self.repo = repo
						
					callback(GitHubResponse.ok(json:json))
				case .failure(let error):
					var message = error.localizedDescription
					
					if let data = response.data, let errorMsg = JSON(data: data)["message"].string {
						message = errorMsg
					}
					callback(GitHubResponse.error(message:message))
				}
			}
		} else {
			callback(GitHubResponse.error(message:"Invalid URL"))
		}
	}

	func loadStargazersPage(currentPage:Int, callback:@escaping (GitHubResponse)->()) {
		if let url = GitHubEntryPoint.stargazers(owner: owner, repo: repo, page: currentPage, perPage: stargazersPerPage).url {
			Alamofire.request(url).validate().responseJSON { response in
				switch response.result {
				case .success(let jsonData):
					let json = JSON(jsonData)
					callback(GitHubResponse.ok(json:json))
				case .failure(let error):
					var message = error.localizedDescription

					if let data = response.data, let errorMsg = JSON(data: data)["message"].string {
						message = errorMsg
					}
					callback(GitHubResponse.error(message:message))
				}
			}
		} else {
			callback(GitHubResponse.error(message:"Invalid URL"))
		}
	}
}
