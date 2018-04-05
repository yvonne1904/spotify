//
//  Album.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 27.11.17..
//  Copyright © 2017. iOS Akademija. All rights reserved.
//

import Foundation

final class Album: Codable {
	let name: String
	let id: String
	var webURL: URL?

	var images: [Image] = []

	var artists: [Artist] = []
	var availableMarkets: Set<String> = []


	enum CodingKeys : String, CodingKey {
		case artists
		case availableMarkets = "available_markets"
		case webURL = "href"
		case id
		case name
		case images
	}
}

struct SpotifyAlbumsContainer: Codable {
	let items: [Album]
}

struct SpotifyAlbumsResponse: Codable {
	let albums: SpotifyAlbumsContainer
}
