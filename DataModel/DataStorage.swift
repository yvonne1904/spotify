//
//  DataStorage.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 20.12.17..
//  Copyright © 2017. iOS Akademija. All rights reserved.
//

import Foundation

//	cash = nije ovo
//	cache = ovo!

final class DataStorage {
	static let shared = DataStorage()
	private init() {}


	private(set) var artists: [Artist] = []
	private(set) var albums: [Album] = []
	private(set) var tracks: [Track] = []
}

extension DataStorage {
	func updateArtists(_ arr: [Artist]) {

		let existingArtistIDs = artists.map({ $0.id })

		for artist in arr {
			if !existingArtistIDs.contains(artist.id) {
				//	insert any new Artist object

			}

			//	update existing objects using new data
		}
	}

	func updateAlbums(_ arr: [Album]) {

		let existingAlbumIDs = albums.map({ $0.id })
		let existingArtistIDs = artists.map({ $0.id })

		for album in arr {
			//	update artist connection
			var finalArtists: [Artist] = []
			for artist in album.artists {
				if existingArtistIDs.contains(artist.id) {
					finalArtists.append( artists.filter({ $0.id == artist.id }).first! )
					continue
				}

				if let a = artists.filter({ $0.id == artist.id }).first {
					finalArtists.append(artist)
					continue
				}

				finalArtists.append(artist)
			}


			if !existingAlbumIDs.contains(album.id) {
				//	insert any new Artist object

			}

			//	update existing objects using new data




		}


	}
}
