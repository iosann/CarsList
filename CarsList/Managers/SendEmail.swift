//
//  SendEmail.swift
//  CarsList
//
//  Created by Anna Belousova on 05.05.2021.
//

import MessageUI

extension AddEditTableViewController {

   @IBAction func sendMessage(_ sender: UIButton) {
		guard MFMailComposeViewController.canSendMail() else {
			let alert = UIAlertController(title: "Your device cannot send an email", message: nil, preferredStyle: .alert)
			cancelAction(alert, sender)
			return
		}
		let mailComposer = MFMailComposeViewController()
		mailComposer.mailComposeDelegate = self
		mailComposer.setToRecipients([cars.addedByUser])
		mailComposer.setSubject("\(cars.manufacturer) \(cars.model), \(cars.productionYear), id: \(cars.id)")
		mailComposer.setMessageBody("I want to buy your car, price: \(cars.price)$", isHTML: false)
		if let image = photo.image?.jpegData(compressionQuality: 1.0) {
			mailComposer.addAttachmentData(image, mimeType: "image", fileName: "\(cars.id).jpeg" )
		}
		present(mailComposer, animated: true)
	}
}

extension AddEditTableViewController: MFMailComposeViewControllerDelegate {
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		dismiss(animated: true)
	}
}


