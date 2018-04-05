//
//  ArtistController.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 20.12.17..
//  Copyright © 2017. iOS Akademija. All rights reserved.
//

import UIKit

final class ArtistController: UIViewController, StoryboardLoadable {

	var artist: Artist? {
		didSet {
			if !isViewLoaded { return }
			populate()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		populate()
	}


	private func populate() {

	}
}
