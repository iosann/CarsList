//
//  AppDelegate.swift
//  CarsList
//
//  Created by Anna Belousova on 24.04.2021.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication,
	  didFinishLaunchingWithOptions launchOptions:
		[UIApplication.LaunchOptionsKey: Any]?) -> Bool {
	  FirebaseApp.configure()
	  return true
	}

}
