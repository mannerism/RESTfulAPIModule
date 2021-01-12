//
//  Users.swift
//  RESTfulAPIModule_Appcoda
//
//  Created by Yu Juno on 2021/01/10.
//
// Test API: https://reqres.in/api/users
import Foundation

struct Users: Codable {
	let page: Int
	let perPage: Int
	let total: Int
	let totalPages: Int
	let data: [User]
	let support: Support
	
	enum CodingKeys: String, CodingKey {
		case page
		case perPage = "per_page"
		case total
		case totalPages = "total_pages"
		case data
		case support
	}
}

struct User: Codable {
	let id: Int
	let email: String
	let firstName: String
	let lastName: String
	let avatar: String

	enum CodingKeys: String, CodingKey {
			case id
			case email
			case firstName = "first_name"
			case lastName = "last_name"
			case avatar
	}
}

struct Support: Codable {
	let url: String
	let text: String
	
	enum CodingKeys: String, CodingKey {
		case url
		case text
	}
}
