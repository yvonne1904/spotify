//
//  NavigationController.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 13.12.17..
//  Copyright © 2017. iOS Akademija. All rights reserved.
//

import UIKit

final class NavigationController: UINavigationController {
	static let tabHeight: CGFloat = 64

	private weak var collectionView: UICollectionView!

	private var tabs: [Tab] = [.artistTab, .albumTab, .trackTab]
	private var selectedIndex: Int = 0

	override func viewDidLoad() {
		super.viewDidLoad()

		addCollectionView()
		collectionView.register(TabCell.self)
		renderSelected()
	}

//	override var preferredStatusBarStyle: UIStatusBarStyle {
//		return .lightContent
//	}
}

extension NavigationController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return tabs.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell: TabCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
		let tab = tabs[indexPath.item]
		cell.configure(with: tab)
		return cell
	}
}

extension NavigationController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		selectedIndex = indexPath.item

		let tab = tabs[indexPath.item]
		handleTab(tab)
	}

	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		guard let layout = collectionViewLayout as? TabLayout else { fatalError("Must be used with TabLayout only") }
		var itemSize = layout.itemSize
		let availableWidth = collectionView.bounds.width
		itemSize.width = availableWidth / CGFloat(tabs.count)
		return itemSize
	}
}



private extension NavigationController {
	func addCollectionView() {
		let layout = TabLayout()
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		view.addSubview(cv)
		collectionView = cv

		cv.backgroundColor = .clear
		cv.backgroundView = {
			let e = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
			let v = UIVisualEffectView(effect: e)
			return v
		}()

		cv.translatesAutoresizingMaskIntoConstraints = false
		cv.heightAnchor.constraint(equalToConstant: NavigationController.tabHeight).isActive = true
		cv.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		cv.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		cv.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

		cv.dataSource = self
		cv.delegate = self
	}

	func handleTab(_ tab: Tab) {
		guard let lastVC = viewControllers.last else { return }

//		if lastVC is SearchController {
//			let vc = lastVC as! SearchController
//		}

		switch lastVC {
		case let vc as SearchController:
			vc.searchType = SpotifyManager.SearchType(tab: tab)
			vc.moodColor = tab.color

		default:
//			let vc =
//			viewControllers = [vc]
			break
		}
	}

	func renderSelected() {
		let indexPath = IndexPath(item: selectedIndex, section: 0)
		collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
	}
}
