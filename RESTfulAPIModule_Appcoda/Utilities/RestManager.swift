//
//  RestManager.swift
//  RESTfulAPIModule_Appcoda
//
//  Created by Yu Juno on 2021/01/01.
//

import Foundation

class RestManager {
	
	/// Reqeust
	var requestHttpHeaders = RestEntity()
	var urlQueryParameters = RestEntity()
	var httpBodyParameters = RestEntity()
	
	/// Optional
	var httpBody: Data?
	
	/// Response
	/// 1. Numeric status(http status code)
	/// 2. http headers
	/// 3. response body
	
	/// Making a request to a server
	func makeRequest(
		toURL url: URL,
		withHttpMethod httpMethod: HttpMethod,
		completion: @escaping (_ result: Results) -> Void
	) {
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			let targetURL = self?.addURLQueryParameters(toURL: url)
			let httpBody = self?.getHttpBody()
			guard let request = self?.prepareRequest(
							withURL: targetURL,
							httpBody: httpBody,
							httpMethod: httpMethod) else {
				completion(
					Results(withError: CustomError.failedToCreateRequest)
				)
				return
			}
			let sessionConfiguration = URLSessionConfiguration.default
			let session = URLSession(configuration: sessionConfiguration)
			let task = session.dataTask(with: request) { (data, response, error) in
				completion(
					Results(
						withData: data,
						response: Response(fromURLResponse: response),
						error: error)
				)
			}
			task.resume()
		}
	}
	
	/// Fetching data from URL
	func getData(
		fromURL url: URL,
		completion: @escaping (_ data: Data?) -> Void
	) {
		DispatchQueue.global(qos: .userInitiated).async {
			let sessionConfiguration = URLSessionConfiguration.default
			let session = URLSession(configuration: sessionConfiguration)
			let task = session.dataTask(with: url) { (data, response, error) in
				guard let data = data else { completion(nil); return }
				completion(data)
			}
			task.resume()
		}
	}

	/// Create a private function where we wil append
	/// any URL query parameters specified through the
	/// `urlQueryParameters` property to the original URL.
	/// https://api.github.com/users/zellwk/repos?sort=pushed
	private func addURLQueryParameters(toURL url: URL) -> URL {
		if urlQueryParameters.totalItems() > 0 {
			/// We must make sure that there are
			/// URL query parameters to append
			guard var urlComponents = URLComponents(
							url: url,
							resolvingAgainstBaseURL: false) else { return url }
			var queryItems = [URLQueryItem]()
			for (key, value) in urlQueryParameters.allValues() {
				/// https://someUrl.com?phrase=hello world
				/// https://someUrl.com?phrase=hello%20world
				let item = URLQueryItem(
					name: key,
					value: value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
				)
				queryItems.append(item)
			}
			urlComponents.queryItems = queryItems
			/// getting a ful URL
			guard let updatedURL = urlComponents.url else { return url }
			return updatedURL
		}
		return url
	}
	
	private func getHttpBody() -> Data? {
		guard let contentType = requestHttpHeaders.value(forKey: "Content-Type") else { return nil }
		if contentType.contains("application/json") {
			/// `httpBodyParameter` objecg must be converted into a JSON
			return try? JSONSerialization.data(
				withJSONObject: httpBodyParameters,
				options: [.prettyPrinted, .sortedKeys]
			)
		} else if contentType.contains("application/x-www-form-urlencoded") {
			let bodyString = httpBodyParameters.allValues().map{
				"\($0)=\(String(describing: $1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))"
			}.joined(separator: "&")
			/// ["firstname":"John", "age":"40"]
			/// "firstname=John&age=40"
			return bodyString.data(using: .utf8)
		} else {
			return httpBody
		}
	}
	
	private func prepareRequest(
		withURL url: URL?,
		httpBody: Data?,
		httpMethod: HttpMethod
	) -> URLRequest? {
		guard let url = url else { return nil }
		var request = URLRequest(url: url)
		
		/// Http method를 request안에 넣어주는 일
		request.httpMethod = httpMethod.rawValue
		
		/// Http header를 request안에 넣어주는 일
		for (header, value) in requestHttpHeaders.allValues() {
			request.setValue(value, forHTTPHeaderField: header)
		}
		
		/// Http body를 request안에 넣어주는 일
		request.httpBody = httpBody
		
		return request
	}
}

extension RestManager {
	enum HttpMethod: String {
		case get
		case post
		case put
		case patch
		case delete
	}
	
	/// Error case
	enum CustomError: Error {
		case failedToCreateRequest
	}

	/// Reqeust
	struct RestEntity {
		private var values: [String: String] = [:]
		
		mutating func add(
			value: String,
			forKey key: String
		) {
			values[key] = value
		}
		
		func value(forKey key: String) -> String? {
			return values[key]
		}
		
		func allValues() -> [String: String] {
			return values
		}
		
		func totalItems() -> Int {
			return values.count
		}
	}
	
	/// Response
	struct Response {
		var httpStatusCode: Int = 0
		var headers = RestEntity()
		var response: URLResponse?
		
		init(fromURLResponse response: URLResponse?) {
			guard let response = response else { return }
			self.response = response
			httpStatusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
			if let headerFields = (response as? HTTPURLResponse)?.allHeaderFields {
				for (key, value) in headerFields {
					headers.add(
						value: "\(value)",
						forKey: "\(key)"
					)
				}
			}
		}
	}

	/// Result
	struct Results {
		var data: Data?
		var response: Response?
		var error: Error?
		
		init(
			withData data: Data?,
			response: Response?,
			error: Error?
		){
			self.data = data
			self.response = response
			self.error = error
		}
		
		init(withError error: Error) {
			self.error = error
		}
	}
}

extension RestManager.CustomError: LocalizedError {
	public var localizedDescription: String {
		switch self {
		case .failedToCreateRequest:
			return NSLocalizedString(
				"Unable to create the URLRequest object",
				comment: ""
			)
		}
	}
}
