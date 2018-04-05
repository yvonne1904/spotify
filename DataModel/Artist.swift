//
//  Artist.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 27.11.17..
//  Copyright © 2017. iOS Akademija. All rights reserved.
//

import Foundation

struct Followers: Codable {
	let total: Int
}

final class Artist: Codable {
	let name: String
	let id: String

	var popularity: Int? = nil
	var genres: [String] = []
	var webURL: URL

	var images: [Image] = []

	private var followers: Followers? = nil
	var followersCount: Int? { return followers?.total }

	enum CodingKeys : String, CodingKey {
		case webURL = "href"
		case id
		case name
		case popularity
		case genres
		case images
		case followers
	}

	//	Custom decoding
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		id = try container.decode(String.self, forKey: .id)
		name = try container.decode(String.self, forKey: .name)
		webURL = try container.decode(URL.self, forKey: .webURL)

		popularity = try? container.decode(Int.self, forKey: .popularity)
		genres = (try? container.decode([String].self, forKey: .genres)) ?? []
		images = (try? container.decode([Image].self, forKey: .images)) ?? []

		followers = try? container.decode(Followers.self, forKey: .images)
	}
}

struct SpotifyArtistsContainer: Codable {
	let items: [Artist]
}

struct SpotifyArtistsResponse: Codable {
	let artists: SpotifyArtistsContainer
}

