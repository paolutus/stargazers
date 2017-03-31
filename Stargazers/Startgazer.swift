//
//  Startgazer.swift
//  Stargazers
//
//  Created by Paolo Malpeli on 30/03/2017.
//  Copyright © 2017 Paolo Malpeli. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol AvatarDelegate : class {
	func avatarReady(image: UIImage)
	func avatarUnavailable()
}

class Stargazer {
	let login : String
	let avatarURL : URL
	var avatar : UIImage?
	weak var avatarDelegate : AvatarDelegate?
	
	static func createStargazer(fromJSON json:JSON) -> [Stargazer] {
		var stargazers = [Stargazer]()
		if let array = json.array {
			let page = array.flatMap { Stargazer(json: $0) }
			stargazers.append(contentsOf: page)
		}
		return stargazers
	}
	
	func loadAvatar(delegate:AvatarDelegate) {
		avatarDelegate = delegate
		if let avatar = self.avatar {
			avatarDelegate?.avatarReady(image: avatar)
			return
		}

		Alamofire.request(avatarURL).responseData { response in
			if response.result.isSuccess, let data = response.result.value, let avatar = UIImage(data: data) {
				self.avatar = avatar
				self.avatarDelegate?.avatarReady(image: avatar)
			} else {
				self.avatarDelegate?.avatarUnavailable()
			}
		}
	}
	
	init?(json:JSON) {
		guard let login = json["login"].string else {
			return nil
		}
		
		guard let avatarURL = json["avatar_url"].url else {
			return nil
		}
		
		self.login = login
		self.avatarURL = avatarURL
	}
	
}
