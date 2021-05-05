//
//  Car.swift
//  CarsList
//
//  Created by Anna Belousova on 05.05.2021.
//

import Firebase

struct Car {
	var id: String
	var manufacturer: String
	var model: String
	var productionYear: Int
	var bodyType: String
	var urlPhoto: String
	var price: Int
	var dateOfAdding: String
	var addedByUser: String
	var ref: DatabaseReference?

	init(id: String = "", manufacturer: String = "", model: String = "", productionYear: Int = 0, bodyType: String = "", urlPhoto: String = "", price: Int = 0, dateOfAdding: String = "", addedByUser: String = "") {
		self.ref = nil
		self.id = id
		self.manufacturer = manufacturer
		self.model = model
		self.productionYear = productionYear
		self.bodyType = bodyType
		self.urlPhoto = urlPhoto
		self.price = price
		self.dateOfAdding = dateOfAdding
		self.addedByUser = addedByUser
	}

	init?(snapshot: DataSnapshot) {
		guard let value = snapshot.value as? [String: AnyObject],
		let id = value["id"] as? String,
		let manufacturer = value["manufacturer"] as? String,
		let model = value["model"] as? String,
		let productionYear = value["productionYear"] as? Int,
		let bodyType = value["bodyType"] as? String,
		let price = value["price"] as? Int,
		let urlPhoto = value["urlPhoto"] as? String,
		let dateOfAdding = value["dateOfAdding"] as? String,
		let addedByUser = value["addedByUser"] as? String
		else { return nil }

		self.ref = snapshot.ref
		self.id = id
		self.manufacturer = manufacturer
		self.model = model
		self.productionYear = productionYear
		self.bodyType = bodyType
		self.urlPhoto = urlPhoto
		self.price = price
		self.dateOfAdding = dateOfAdding
		self.addedByUser = addedByUser
	}
}

extension Car {

	func createProductionYearArray() -> [Int] {
		var array: Array<Int> = []
		for i in 2000...2021 {
			array.append(i)
		}
		array.reverse()
		return array
	}

	func createBodyTypeArray() -> [String] {
		return ["Sedan", "Hatchback", "MPV", "SUV", "Crossover", "Coupe", "Convertible"]
	}

	func createUniqueId() -> String {
	  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	  return String((0..<16).map{ _ in letters.randomElement()! })
	}
}

