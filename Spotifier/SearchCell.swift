//
//  SearchCell.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 6.12.17..
//  Copyright © 2017. iOS Akademija. All rights reserved.
//

import UIKit
import Kingfisher

final class SearchCell: UICollectionViewCell, ReusableView {

	@IBOutlet private weak var label: UILabel!
	@IBOutlet private weak var photoView: UIImageView!

	func populate(with result: SearchResult) {
		label.text = result.name

		guard let url = result.imageURL else { return }
		photoView.kf.setImage(with: url)
	}

	func populate(with string: String) {
		label.text = string
	}
}
