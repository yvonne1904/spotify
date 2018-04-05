//
//  RowLayout.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 20.12.17..
//  Copyright © 2017. iOS Akademija. All rights reserved.
//

import UIKit

final class RowLayout: UICollectionViewLayout {


	private var layoutInfo: [IndexPath: UICollectionViewLayoutAttributes] = [:]
	private var contentSize: CGSize = .zero

	private var itemSize: CGSize = CGSize(width: 300, height: 88)


	override func prepare() {
		super.prepare()
		guard let cv = collectionView else { return }

		itemSize = CGSize(width: cv.bounds.width, height: itemSize.height)

		let numberOfSections = cv.numberOfSections
		for section in (0 ..< numberOfSections) {
			let numberOfItems = cv.numberOfItems(inSection: section)

			for item in (0 ..< numberOfItems) {
				let indexPath = IndexPath(item: item, section: section)
				let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
				let frame = CGRect(x: 0,
								   y: CGFloat(indexPath.item) * itemSize.height,
								   width: itemSize.width,
								   height: itemSize.height)
				attr.frame = frame

				layoutInfo[indexPath] = attr
			}
		}

		calculateTotalContentSize()
	}

	override var collectionViewContentSize: CGSize {
		return contentSize
	}


	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		var attrs: [UICollectionViewLayoutAttributes] = []

		for (_, attr) in layoutInfo {
			let frame = attr.frame
			if rect.intersects(frame) {
				attrs.append(attr)
			}
		}

		return attrs
	}

	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return layoutInfo[indexPath]
	}


	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		guard let oldbounds = collectionView?.bounds else { return false }
		//	re-compute all layout info when bounds.size changes
		let shouldInvalidate = oldbounds.width != newBounds.width

		if shouldInvalidate {
			itemSize = CGSize(width: newBounds.width, height: itemSize.height)
		}

		return shouldInvalidate
	}

	override func invalidateLayout() {
		super.invalidateLayout()

		prepare()
	}
}


private extension RowLayout {
	func calculateTotalContentSize() {
		var	f: CGRect = .zero
		for (_, attr) in layoutInfo {
			let frame = attr.frame
			f = f.union(frame)
		}
		contentSize = f.size
	}
}
