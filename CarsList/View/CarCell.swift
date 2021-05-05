//
//  CarCell.swift
//  CarsList
//
//  Created by Anna Belousova on 05.05.2021.
//

import UIKit

class CarCell: UITableViewCell {

	@IBOutlet var descriptionLabel: UILabel!
	@IBOutlet var priceLabel: UILabel!
	@IBOutlet var photoImageView: UIImageView!

	func configure(cell: CarCell) {
		photoImageView.layer.cornerRadius = 10
		photoImageView.layer.borderWidth = 1.0
		photoImageView.layer.borderColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
	}
}
