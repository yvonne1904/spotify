//
//  SearchResult.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 11.12.17..
//  Copyright © 2017. iOS Akademija. All rights reserved.
//

import Foundation

protocol SearchResult {
	var name: String { get }
	var imageURL: URL? { get }
}


extension Artist: SearchResult {
	var imageURL: URL? {
		return images.first?.url
	}
}


extension Album: SearchResult {
	var imageURL: URL? {
		return images.first?.url
	}
}

extension Track: SearchResult {
	var imageURL: URL? {
		return album.images.first?.url
	}
}
