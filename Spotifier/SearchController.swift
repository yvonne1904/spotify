//
//  SearchController.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 27.11.17..
//  Copyright © 2017. iOS Akademija. All rights reserved.
//

import UIKit

final class SearchController: UIViewController {

	var dataManager: DataManager = .shared

	private var results: [SearchResult] = []

	private var searchWorkItem: DispatchWorkItem?

	var searchType: SpotifyManager.SearchType = .artist {
		didSet {
			if !isViewLoaded { return }
			if oldValue == searchType { return }
			cleanupUI()
			resetDataSource()
		}
	}

	var moodColor: UIColor = Tab.artistTab.color {
		didSet {
			if !isViewLoaded { return }
			if oldValue == moodColor { return }
			updateVisuals()
		}
	}

	@IBOutlet private weak var searchBarView: UIVisualEffectView!
	@IBOutlet private weak var searchField: UITextField!
	@IBOutlet private weak var collectionView: UICollectionView!
	@IBOutlet private weak var backImageView: UIImageView!
}

extension SearchController {
	//	MARK:- View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		collectionView.contentInsetAdjustmentBehavior = .never

		setupKeyboardNotificationHandlers()
		cleanupUI()
		updateVisuals()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		collectionView.contentInset.top = searchBarView.frame.maxY
		collectionView.contentInset.bottom = NavigationController.tabHeight
	}

//	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//		super.viewWillTransition(to: size, with: coordinator)
//
//		collectionView.collectionViewLayout.invalidateLayout()
//	}


	func setupKeyboardNotificationHandlers() {
		let nc = NotificationCenter.default

		nc.addObserver(self, selector: #selector(SearchController.keyboardWillShowNotificationHandler(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

		nc.addObserver(forName: NSNotification.Name.UIKeyboardDidHide, object: nil, queue: .main, using: keyboardDidHideNotificationHandler)
	}

	@objc func keyboardWillShowNotificationHandler(_ notification: Notification) {
		DispatchQueue.main.async {
			[weak self] in
			guard let `self` = self else { return }

			if let userInfo = notification.userInfo {
				if let frameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
					let frame = frameValue.cgRectValue
					let keyboardVisibleHeight = frame.size.height

					self.collectionView.contentInset.bottom = keyboardVisibleHeight
				}
			}
		}
	}

	@objc func keyboardDidHideNotificationHandler(_ notification: Notification) {
		self.collectionView.contentInset.bottom = NavigationController.tabHeight
	}



	//	MARK:- Internal

	func updateVisuals() {
		UIView.animate(withDuration: 0.2, animations: {
			self.backImageView.alpha = 1
		}) { _ in
			self.view.backgroundColor = self.moodColor
			UIView.animate(withDuration: 0.2, animations: {
				self.backImageView.alpha = 0.8
			})
		}
	}

	func resetDataSource() {
		results = []
		collectionView.reloadData()
	}

	func cleanupUI() {
		searchField.text = nil
	}

	func search(for string: String) {

		searchWorkItem?.cancel()

		searchWorkItem = DispatchWorkItem {
			[weak self] in
			guard let `self` = self else { return }

			self.searchWorkItem = nil

			self.dataManager.search(for: string, type: self.searchType) {
				str, results, dataError in

				if str != self.searchField.text ?? "" { return }

				if let _ = dataError {
					//	alert
					return
				}

				self.results = results

				self.collectionView.reloadData()
			}
		}

		if let searchWorkItem = searchWorkItem {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: searchWorkItem)
		}
	}
}


extension SearchController {
	@IBAction func textFieldChanged(_ sender: UITextField) {
		guard let s = sender.text, s.count > 2 else {
			results.removeAll()
			collectionView.reloadData()
			return
		}
		search(for: s)
	}
}



extension SearchController: UICollectionViewDataSource {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return results.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell: SearchCell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.reuseIdentifier, for: indexPath) as! SearchCell

		let result = results[indexPath.item]
		cell.populate(with: result)

		return cell
	}
}


extension SearchController: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		let result = results[indexPath.item]
		processTapResult(result)
	}

	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { fatalError("Must be used with FlowLayout only") }


		var itemSize = layout.itemSize

		var availableWidth = collectionView.bounds.width
		availableWidth -= (layout.sectionInset.left + layout.sectionInset.right)

		let columns = floor( availableWidth / ( itemSize.width + layout.minimumInteritemSpacing ) )
		availableWidth -= (columns - 1) * layout.minimumInteritemSpacing

		let w = availableWidth / columns

		itemSize.width = w

		return itemSize
	}
}


extension SearchController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}


private extension SearchController {
	func processTapResult(_ result: SearchResult) {

		switch result {
		case let obj as Artist:
			let vc = ArtistController.instantiate(fromStoryboardNamed: "Main")
			vc.artist = obj
			show(vc, sender: self)

		default:
			break
		}

	}
}
