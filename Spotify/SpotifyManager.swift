//
//  SpotifyManager.swift
//  Spotifier
//
//  Created by Aleksandar Vacić on 27.11.17..
//  Copyright © 2017. iOS Akademija. All rights reserved.
//

import Foundation
import SwiftyOAuth

typealias JSON = [String: Any]

final class SpotifyManager {

	private var requests: [APIRequest] = []

	private var isFetchingTokenInProgress = false {
		didSet {
			if isFetchingTokenInProgress { return }
			processPendingRequests()
		}
	}

	private var oauthProvider = Provider.spotify(clientID: "badf9c13b4604dd3b6f3335df4542100",
												 clientSecret: "a889c1f8e98f4e07a93fbb56ce5d19a5")

	enum Path {
		static let host = "https://api.spotify.com/v1/"

		case search(q: String, type: SearchType)

		private var url: URL {
			var s = ""

			switch self {
			case .search(let q, let type):
				s = "\( Path.host )search?q=\( q )&type=\( type.rawValue )"
			}

			return URL(string: s)!
		}

		private var method: String {
			switch self {
			case .search:
				return "GET"
			}
		}

		var urlRequest: URLRequest {
			var urlRequest = URLRequest(url: url)
			urlRequest.httpMethod = method
			return urlRequest
		}
	}
}

extension SpotifyManager {
	//	MARK: Public API

	typealias Callback = ( Data?, SpotifyError? ) -> Void

	func call(path: Path, spotifyCallback: @escaping Callback) {
		let apiReq = (path, spotifyCallback)
		oauth(apiReq)

//		execute(urlRequest: path.urlRequest, spotifyCallback: spotifyCallback)
	}

}

private extension SpotifyManager {
	//	MARK: Internal

	typealias APIRequest = (path: Path, callback: Callback)

	func processPendingRequests() {
		let reqs = self.requests

		for req in reqs {
			oauth(req)
		}

		self.requests = []
	}

	//	MARK: OAuth

	func fetchToken() {
		if isFetchingTokenInProgress { return }
		isFetchingTokenInProgress = true

		oauthProvider.authorize {
			[unowned self] result in

			switch result {
			case .success:
				self.isFetchingTokenInProgress = false

			case .failure(let error):
				print(error)
			}
		}
	}

	func refreshToken() {
		fetchToken()
	}

	//	MARK: Authorization

	func oauth(_ apiReq: APIRequest) {

		// do we have valid AccessToken?
		guard let token = oauthProvider.token else {
			//	if not, then save request,
			self.requests.append(apiReq)

			fetchToken()
			return
		}

		if !token.isValid {
			//	if not, then save request,
			self.requests.append(apiReq)

			refreshToken()
			return
		}


		//	sign the request

		var urlRequest = apiReq.path.urlRequest

		if let tokenType = token.tokenType {
			switch tokenType {
			case .bearer:
				let value = "Bearer \( token.accessToken )"
				urlRequest.addValue(value, forHTTPHeaderField: "Authorization")
			}
		}

		execute(urlRequest: urlRequest, spotifyCallback: apiReq.callback)
	}

	//	MARK: Networking

	func execute(urlRequest: URLRequest, spotifyCallback: @escaping Callback) {

		let task = URLSession.shared.dataTask(with: urlRequest) {
			data, urlRespose, error in

			spotifyCallback(data, nil)
		}

		task.resume()
	}
}

