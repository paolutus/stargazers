//
//  AppDelegate.swift
//  Stargazers
//
//  Created by Paolo Malpeli on 28/03/2017.
//  Copyright © 2017 Paolo Malpeli. All rights reserved.
//

import UIKit
import Alamofire

// available segues
enum StargazersSegue: String {
	case stargazers = "StargazersSegue"
	
	var identifier : String {
		return self.rawValue
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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

