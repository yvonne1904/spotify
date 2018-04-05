//
//  SpotifyError.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 27.11.17..
//  Copyright © 2017. iOS Akademija. All rights reserved.
//

import Foundation

enum SpotifyError: Error {
	case urlError(URLError)
	case invalidResponse
	case noData
}
