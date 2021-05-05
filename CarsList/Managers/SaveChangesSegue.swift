//
//  SaveChangesSegue.swift
//  CarsList
//
//  Created by Anna Belousova on 05.05.2021.
//

import UIKit

extension ListTableViewController {

	@IBAction func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UITableViewController) {

			guard unwindSegue.identifier == "SaveSegue" else { return }
			let source = unwindSegue.source as! AddEditTableViewController
			source.updateCar()
			var car = source.cars
			guard car.manufacturer != "" && car.model != "" && car.bodyType != "" && car.productionYear > 0 && car.price > 0 && (selectedImage != nil || car.urlPhoto != "") else {
				callAlert(withText: "Fill in all fields and select a photo")
				return
			}
			if let selectedPath = tableView.indexPathForSelectedRow {
//edited cell
				cars[selectedPath.row] = car
				if selectedImage != nil {
					storageRef.child(car.id).delete { error in
						if let error = error {
							print(error.localizedDescription)
						}
					}
					car.ref?.removeValue()

					let newStorageRef = storageRef.child(car.id)
					guard let imageData = selectedImage?.jpegData(compressionQuality: 0.5) else { return }
					newStorageRef.putData(imageData, metadata: nil) { metadata, error in
						guard metadata != nil else {
							print(error?.localizedDescription ?? "Error: no discription")
							return
						}
						newStorageRef.downloadURL { url, error in
							guard let downloadUrl = url else {
								print(error?.localizedDescription ?? "Error: no discription")
								return
							}
							let urlPhoto = downloadUrl.absoluteString
							car.ref?.updateChildValues(["id": car.id, "urlPhoto": urlPhoto, "manufacturer": car.manufacturer, "model": car.model, "productionYear": car.productionYear, "bodyType": car.bodyType, "price": car.price, "dateOfAdding": car.dateOfAdding
							  //  , "addedByUser": car.addedByUser
							])
							selectedImage = nil
						}
					}
				} else {
					car.ref?.updateChildValues(["id": car.id, "urlPhoto": car.urlPhoto, "manufacturer": car.manufacturer, "model": car.model, "productionYear": car.productionYear, "bodyType": car.bodyType, "price": car.price, "dateOfAdding": car.dateOfAdding
					 //   , "addedByUser": car.addedByUser
					])
				}
			} else {
//added cell
				car.id = car.createUniqueId()
				let newRef = self.ref.child(car.id)
				let newStorageRef = storageRef.child(car.id)
				guard let imageData = selectedImage?.jpegData(compressionQuality: 0.5) else { return }
				newStorageRef.putData(imageData, metadata: nil) { metadata, error in
					guard metadata != nil else {
						print(error?.localizedDescription ?? "Error: no discription")
						return
					}
					newStorageRef.downloadURL { url, error in
						guard let downloadUrl = url else {
							print(error?.localizedDescription ?? "Error: no discription")
							return
						}
						let urlPhoto = downloadUrl.absoluteString
						newRef.setValue(["id": car.id, "urlPhoto": urlPhoto, "manufacturer": car.manufacturer, "model": car.model, "productionYear": car.productionYear, "bodyType": car.bodyType, "price": car.price, "dateOfAdding": car.dateOfAdding, "addedByUser": car.addedByUser])
						selectedImage = nil
					}
				}
			}
		}
}

