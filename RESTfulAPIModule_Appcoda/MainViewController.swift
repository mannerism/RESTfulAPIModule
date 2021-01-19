//
//  MainViewController.swift
//  RESTfulAPIModule_Appcoda
//
//  Created by Yu Juno on 2021/01/01.
//

import UIKit

class MainViewController: UIViewController {
	
	/// Instantiate rest manager here
	let rest = RestManager()
	
	lazy var startAPIButton: UIButton = {
		let bt = UIButton(type: .system)
		bt.setTitle("start", for: .normal)
		bt.addTarget(self, action: #selector(handleStart), for: .touchUpInside)
		return bt
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
		addViews()
		setConstraints()
	}
	
	private func setup() {
		view.backgroundColor = .white
	}
	
	private func addViews() {
		view.addSubview(startAPIButton)
	}
	
	private func setConstraints() {
		startAPIButtonConstraints()
	}
	
	@objc func handleStart() {
//		createUser()
		getUsersList()
	}
	
	/// Get users list
	func getUsersList() {
//		guard let url = URL(string: "https://reqres.in/api/users") else { return }
//		rest.urlQueryParameters.add(value: "1", forKey: "page")
//		rest.requestDelegate = self
//		rest.makeRequest(
//			toURL: url,
//			withHttpMethod: .get
//		)
		guard let url = URL(string: "https://reqres.in/api/users") else { return }
		rest.dataDelegate = self
		rest.getData(fromURL: url)
	}
	
//	func createUser() {
//		guard let url = URL(string: "https://reqres.in/api/users") else { return }
//		rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
//		rest.httpBodyParameters.add(value: "SMIZZ", forKey: "name")
//		rest.httpBodyParameters.add(value: "Developer", forKey: "job")
//		rest.makeRequest(
//			toURL: url,
//			withHttpMethod: .post) { (results) in
//			guard let statusCode = results.response?.httpStatusCode else { return }
//			if statusCode > 200 && statusCode < 300 {
//				print("유저 생성 완료")
//				guard let data = results.data,
//							let decoded = try? JSONDecoder().decode(
//								CreateUserResponse.self,
//								from: data) else { return }
//				print("새로 만들어진 이름: \(decoded.name)")
//				print("새로온 사람의 일: \(decoded.job)")
//				print("만들어진 시간: \(decoded.createdTime)")
//
//			} else {
//				print("유저 생성 실패")
//			}
//		}
//	}
	
	private func startAPIButtonConstraints() {
		startAPIButton.translatesAutoresizingMaskIntoConstraints = false
		startAPIButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
		startAPIButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
		startAPIButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		startAPIButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
	}
}

extension MainViewController: RestManagerRequestDelegate {
	func didFailToPrepareRequest(_ result: RestManager.Results) {
		print("did fail to prepare request")
	}
	
	func didReceiveResponseFromDataTask(_ result: RestManager.Results) {
		guard let data = result.data,
					let decoded = try? JSONDecoder().decode(Users.self, from: data) else { return }
		print(decoded)
	}
}

extension MainViewController: RestManagerDataDelegate {
	func didFailToGetData() {
		print("failed to get data")
	}
	
	func didReceiveData(_ data: Data) {
		print("did receive data! \(data)")
	}
	
}
