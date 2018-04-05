//
//  SearchLayout.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 6.12.17..
//  Copyright © 2017. iOS Akademija. All rights reserved.
//

import UIKit

final class SearchLayout: UICollectionViewFlowLayout {

	override func awakeFromNib() {
		super.awakeFromNib()

		itemSize = CGSize(width: 110, height: 200)
		minimumInteritemSpacing = 10
		minimumLineSpacing = 10
		sectionInset = UIEdgeInsetsMake(10, 10, 0, 10)
	}
}

extension SearchLayout {
	//	Layout information:
	//	- size of each item, header, footer etc
	//	- origin of each item
	//	== layoutAttributes.frame
	//
	//	(plus all other UICollectionViewLayoutAttributes.* properties)


	//	method that says when should layout information be re-calculated
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		guard let oldbounds = collectionView?.bounds else { return false }
		//	re-compute all layout info when bounds.size changes
		return oldbounds.size != newBounds.size
	}

	//	Context is simple class with bunch of flags
	//	== properties that help *you* tally what needs to be re-calculated in the Layout
	override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
		//	convert into FlowLayout-related Context, since that's the Layout we are working with here
		guard let context = super.invalidationContext(forBoundsChange: newBounds) as? UICollectionViewFlowLayoutInvalidationContext else { return super.invalidationContext(forBoundsChange: newBounds) }
		//	and it has these two additional properties

		//	this says to re-calculate positions on screens
		context.invalidateFlowLayoutAttributes = true

		//	this says to re-query sizes for the items from the UICollectionViewDelegateFlowLayout
		context.invalidateFlowLayoutDelegateMetrics = true

		return context
	}
}
