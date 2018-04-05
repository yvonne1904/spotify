//
//  Tab.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 18.12.17..
//  Copyright © 2017. iOS Akademija. All rights reserved.
//

import UIKit

struct Tab {
	enum ID: String {
		case artist
		case album
		case track
	}

	let id: ID
}

extension Tab {
	static let artistTab: Tab = Tab(id: .artist)
	static let albumTab: Tab = Tab(id: .album)
	static let trackTab: Tab = Tab(id: .track)
}


extension Tab {
	var icon: UIImage {
		switch id {
		case .artist:
			return #imageLiteral(resourceName: "mus-mic-2")
		case .album:
			return #imageLiteral(resourceName: "mus-record")
		case .track:
			return #imageLiteral(resourceName: "mus-cover")
		}
	}

	var color: UIColor {
		switch id {
		case .artist:
			return .magenta
		case .album:
			return .blue
		case .track:
			return .red
		}
	}

	var title: String {
		switch id {
		case .artist:
			return NSLocalizedString("Artists", comment: "")
		case .album:
			return NSLocalizedString("Albums", comment: "")
		case .track:
			return NSLocalizedString("Tracks", comment: "")
		}
	}
}


extension SpotifyManager.SearchType {
	init(tab: Tab) {
		switch tab.id {
		case .artist:
			self = .artist
		case .album:
			self = .album
		case .track:
			self  = .track
		}
	}
}

