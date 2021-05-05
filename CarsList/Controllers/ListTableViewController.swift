//
//  ListTableViewController.swift
//  CarsList
//
//  Created by Anna Belousova on 05.05.2021.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class ListTableViewController: UITableViewController {

	var cars = [Car]()
	var carCell = CarCell()
	let ref = Database.database().reference(withPath: "cars")
	let storageRef = Storage.storage().reference().child("images")
	let searchController = UISearchController(searchResultsController: nil)
	var filteredCars: [Car] = []
	var isSearchBarEmpty: Bool {
	  return searchController.searchBar.text?.isEmpty ?? true
	}
	var isFiltering: Bool {
		  return searchController.isActive && !isSearchBarEmpty
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		getSnapshot()
		createSearchController()
	}

	func getSnapshot() {
		ref.queryOrdered(byChild: "id").observe(.value, with: { snapshot in
			var newCars: [Car] = []
			for child in snapshot.children {
				guard let snapshot = child as? DataSnapshot, let car = Car(snapshot: snapshot) else { return }
					newCars.append(car)
			}
			self.cars = newCars
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		})
	}

	func createSearchController() {
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search car"
		navigationItem.searchController = searchController
		searchController.definesPresentationContext = true
		if #available(iOS 13.0, *) {
		}
		else {
		searchController.hidesNavigationBarDuringPresentation = false
		}
	}

	// MARK: - Table view data source
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isFiltering {
		  return filteredCars.count
		}
		return cars.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell", for: indexPath) as! CarCell
		let car: Car
		if isFiltering {
		  car = filteredCars[indexPath.row]
		} else {
			car = cars[indexPath.row]
		}
		cell.descriptionLabel.text = "\(car.manufacturer) \(car.model), \(car.productionYear)"
		cell.priceLabel.text = "\(car.price) $"
		cell.photoImageView.loadImagesUsingCache(urlString: car.urlPhoto)
		cell.configure(cell: carCell)
		return cell
	}

	// MARK: - Editing table view
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let car = cars[indexPath.row]
			storageRef.child(car.id).delete { error in
				if let error = error {
					print(error.localizedDescription)
					self.callAlert(withText: "Removal failed")
				}
			}
			car.ref?.removeValue()
		}
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if view.bounds.size.height > view.bounds.size.width {
			let aspectRatio: CGFloat = 120/896
			return aspectRatio * view.bounds.size.height
		} else {
			let aspectRatio: CGFloat = 100/414
			return aspectRatio * view.bounds.size.height
		}
	}

	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard segue.identifier == "EditSegue" else { return }
		guard let selectedPath = tableView.indexPathForSelectedRow else { return }
		let car: Car
		if isFiltering {
			car = filteredCars[selectedPath.row]
		} else {
			car = cars[selectedPath.row]
		}
		let destination = segue.destination as! AddEditTableViewController
		destination.cars = car
	}

	func callAlert(withText text: String) {
		let alert = UIAlertController(title: "\(text)", message: nil, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
			alert.dismiss(animated: true, completion: nil)
		}))
		performSegue(withIdentifier: "PresentSegue", sender: nil)
		present(alert, animated: true)
		selectedImage = nil
	}

	func filterContentForSearchText(_ searchText: String) {
		filteredCars = cars.filter { (cars: Car) -> Bool in
			let carsManufacturerAndModel = cars.manufacturer + cars.model
			return carsManufacturerAndModel.lowercased().contains(searchText.lowercased())
	  }
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}

	@IBAction func signOutTapped(_ sender: UIBarButtonItem) {
		do {
			try Auth.auth().signOut()
		}
		catch {
			print(error.localizedDescription)
		}
		self.dismiss(animated: true, completion: nil)
	}
}

extension ListTableViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		let searchBar = searchController.searchBar
		filterContentForSearchText(searchBar.text!)
	}
}
