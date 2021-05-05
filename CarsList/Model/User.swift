//
//  User.swift
//  CarsList
//
//  Created by Anna Belousova on 05.05.2021.
//

import Firebase

struct User {
	let uid: String
	let email: String

	init(authData: Firebase.User) {
		uid = authData.uid
		email = authData.email!
	}

	init(uid: String, email: String) {
		self.uid = uid
		self.email = email
	}
}
