//
//  CreateUserResponse.swift
//  RESTfulAPIModule_Appcoda
//
//  Created by Yu Juno on 2021/01/14.
//

import Foundation

struct CreateUserResponse: Codable {
	let name: String
	let job: String
	let id: String
	let createdTime: String
	
	enum CodingKeys: String, CodingKey {
		case name
		case job
		case id
		case createdTime = "createdAt"
	}
}
