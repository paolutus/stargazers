//
//  GitHubEntryPoint.swift
//  Stargazers
//
//  Created by Paolo Malpeli on 31/03/2017.
//  Copyright © 2017 Paolo Malpeli. All rights reserved.
//

import Foundation
import Alamofire

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
