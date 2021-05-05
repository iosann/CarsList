//
//  LoadImagesFromStorage.swift
//  CarsList
//
//  Created by Anna Belousova on 05.05.2021.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {

	func loadImagesUsingCache(urlString: String) {
		if let cachedImage = imageCache.object(forKey: urlString as NSString) {
			self.image = cachedImage
			return
		}
		guard let url = URL(string: urlString) else { return }
		URLSession.shared.dataTask(with: url) { data, response, error in
			guard let data = data else {
				print(error?.localizedDescription ?? "Error: no description")
				return
			}
			DispatchQueue.main.async {
				if let downloadedImage = UIImage(data: data) {
					imageCache.setObject(downloadedImage, forKey: urlString as NSString)
					self.image = downloadedImage
				}
			}
		}.resume()
	}
}
