//
//  TabCell.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 13.12.17..
//  Copyright © 2017. iOS Akademija. All rights reserved.
//

import UIKit

final class TabCell: UICollectionViewCell, NibReusableView {

	@IBOutlet private weak var label: UILabel!
	@IBOutlet private weak var iconView: UIImageView!

	override var isSelected: Bool {
		didSet {
			applyTheme()
		}
	}

	private var color: UIColor = .darkGray {
		didSet {
			applyTheme()
		}
	}

    override func awakeFromNib() {
        super.awakeFromNib()

		cleanup()
		applyTheme()
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		cleanup()
	}

	func configure(with tab: Tab) {
		label.text = tab.title
		iconView.image = tab.icon
		color = tab.color
	}

	private func cleanup() {
		label.text = nil
		iconView.image = nil
		iconView.backgroundColor = .clear
	}

	private func applyTheme() {
		iconView.tintColor = (isSelected) ? color : .darkGray
		label.textColor = (isSelected) ? color : .darkGray
	}
}
