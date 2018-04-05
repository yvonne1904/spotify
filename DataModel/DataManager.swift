//
//  DataManager.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 27.11.17..
//  Copyright © 2017. iOS Akademija. All rights reserved.
//

import Foundation

final class DataManager {
	static let shared = DataManager()
	private init() {

	}

	lazy var dataStorage: DataStorage = DataStorage.shared

	private let spotifyManager = SpotifyManager()
}


extension DataManager {

	func search(for string: String,
				type: SpotifyManager.SearchType,
				dataCallback: @escaping (String, [SearchResult], DataError?) -> Void ) {

		let path: SpotifyManager.Path = .search(q: string, type: type)
		spotifyManager.call(path: path) {
			data, spotifyError in

			if let spotifyError = spotifyError {
				DispatchQueue.main.async {
					dataCallback(string, [], DataError.spotifyError(spotifyError))
				}
				return
			}

			//	process Data

			guard let data = data else {
				return
			}

			let decoder = JSONDecoder()
			do {
				switch type {
				case .artist:
					let artistsResponse = try decoder.decode(SpotifyArtistsResponse.self, from: data)

					//	update in data storage

					DispatchQueue.main.async {
						dataCallback( string, artistsResponse.artists.items as [SearchResult], nil)
					}

				case .album:
					let albumsResponse = try decoder.decode(SpotifyAlbumsResponse.self, from: data)
					let objects = albumsResponse.albums.items

					//	update in data storage

					DispatchQueue.main.async {
						dataCallback( string, objects as [SearchResult], nil)
					}
					break

				case .track:
					let tracksResponse = try decoder.decode(SpotifyTracksResponse.self, from: data)

					//	update in data storage

					DispatchQueue.main.async {
						dataCallback( string, tracksResponse.tracks.items as [SearchResult], nil)
					}
					break
				}

			} catch let error {
				print(error)
				DispatchQueue.main.async {
					dataCallback( string, [], DataError.internalError)
				}
			}
		}
	}
}
