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
		getUsersList()
	}
	
	/// Get users list
	func getUsersList() {
		guard let url = URL(string: "https://reqres.in/api/users") else { return }
		rest.makeRequest(
			toURL: url,
			withHttpMethod: .get) { (result) in
			/// 1. result 안에 있는 data를 unwrapping
			/// 2. unwrapped된 data를 JsonDecoder라는 class를 사용하여 JSON -> 커스텀 Struct로 디코딩 진행
			/// 3. try? 를 붙이는 이유는 try catch 구문을 간단하게 적기 위해서 사용
			/// 4. Decodable protocol을 채택한 strcut의 meta type을 지정해 줌으로써, 내가 받을 객체가 이것이다 라고 알려줌
			/// 5. 끝
			guard let data = result.data,
						let decoded = try? JSONDecoder().decode(Users.self, from: data) else { return }
			print("총 사용자 수는 \(decoded.data.count) 명 입니다")
		}
	}
	
	private func startAPIButtonConstraints() {
		startAPIButton.translatesAutoresizingMaskIntoConstraints = false
		startAPIButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
		startAPIButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
		startAPIButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		startAPIButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
	}
}
