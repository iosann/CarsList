//
//  PickerView.swift
//  CarsList
//
//  Created by Anna Belousova on 05.05.2021.
//

import UIKit

extension AddEditTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {

	func createBodyTypeAndProductionYearPicker() {

		let bodyTypePicker = UIPickerView()
		bodyTypePicker.tag = 1
		bodyTypePicker.dataSource = self
		bodyTypePicker.delegate = self
		bodyTypeTextField.inputView = bodyTypePicker

		let productionYearPicker = UIPickerView()
		productionYearPicker.tag = 2
		productionYearPicker.dataSource = self
		productionYearPicker.delegate = self
		productionYearTextField.inputView = productionYearPicker

		let toolbar = UIToolbar()
		toolbar.sizeToFit()
		let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(endEditing))
		toolbar.setItems([doneButton], animated: true)
		toolbar.isUserInteractionEnabled = true
		bodyTypeTextField.inputAccessoryView = toolbar
		productionYearTextField.inputAccessoryView = toolbar
	}

	@objc func endEditing() {
		tableView.endEditing(true)
	}

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		switch pickerView.tag {
		case 1:
			return bodyTypesArray.count
		case 2:
			return productionYearArray.count
		default:
			return 0
		}
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		switch pickerView.tag {
		case 1:
			return bodyTypesArray[row]
		case 2:
			return String(productionYearArray[row])
		default:
			return ""
		}
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		switch pickerView.tag {
		case 1:
			bodyTypeTextField.text = bodyTypesArray[row]
			textFieldDidChange()
		case 2:
			productionYearTextField.text = String(productionYearArray[row])
			textFieldDidChange()
		default:
			break
		}
	}
}

