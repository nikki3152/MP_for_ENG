//
//  ViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/12.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	let dataMrg = MPEDataManager()
	//var db: [String:[String]] = [:]
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if dataMrg.checkFileExists(name: "database", dir: "") == false {
			dataMrg.makeDB()
		}
		//self.db = dataMrg.loadDB()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewWillLayoutSubviews() {
		
		let word = "Apple"
		let list = dataMrg.search(word: word, match: .contains)
		for dic in list {
			let keys = dic.keys
			for key in keys {
				print("【\(key)】")
				let values = dic[key]!
				for value in values {
					print(" >\(value)")
				}
			}
		}
		
		let gameView = GameViewController.gameViewController()
		gameView.present(self) { 
			
		}
	}
	
	// >> Skip
	@IBOutlet weak var skipButton: UIButton!
	@IBAction func skipButtonAction(_ sender: Any) {
		
		let homeView = HomeViewController.homeViewController()
		homeView.present(self) { 
			
		}
	}
	
	
}

