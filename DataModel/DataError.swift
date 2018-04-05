//
//  DataError.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 27.11.17..
//  Copyright © 2017. iOS Akademija. All rights reserved.
//

import Foundation

enum DataError: Error {
	case spotifyError(SpotifyError)

	case internalError
}
