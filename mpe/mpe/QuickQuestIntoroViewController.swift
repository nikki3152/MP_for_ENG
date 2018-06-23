//
//  QuickQuestIntoroViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class QuickQuestIntoroViewController: BaseViewController {
	
	class func quickQuestIntoroViewController() -> QuickQuestIntoroViewController {
		
		let storyboard = UIStoryboard(name: "QuickQuestViewController", bundle: nil)
		let baseCnt = storyboard.instantiateViewController(withIdentifier: "QuickQuestIntoroView") as! QuickQuestIntoroViewController
		return baseCnt
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	//戻る
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		
		self.remove()
	}
	
	//スタート
	@IBAction func startButtonAction(_ sender: UIButton) {
		
		let quickView = QuickQuestViewController.quickQuestViewController()
		quickView.present(self) { 
			
		}
	}
}
