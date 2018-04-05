//
//  Track.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 27.11.17..
//  Copyright © 2017. iOS Akademija. All rights reserved.
//

import Foundation

final class Track: Codable {
	let name: String
	let id: String
	var webURL: URL?
	var previewURL: URL?

	var album: Album
	var isExplicit: Bool = false

	var artists: [Artist] = []
	var availableMarkets: Set<String> = []
	var durationInMilliseconds: Int

	enum CodingKeys : String, CodingKey {
		case availableMarkets = "available_markets"
		case webURL = "href"
		case id
		case name
		case previewURL = "preview_url"
		case album
		case artists
		case durationInMilliseconds = "duration_ms"
		case isExplicit = "explicit"
	}
}

struct SpotifyTracksContainer: Codable {
	let items: [Track]
}

struct SpotifyTracksResponse: Codable {
	let tracks: SpotifyTracksContainer
}



