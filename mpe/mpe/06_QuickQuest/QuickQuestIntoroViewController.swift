//
//  QuickQuestIntoroViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class QuickQuestIntoroViewController: BaseViewController {
	
	
	deinit {
		print(">>>>>>>> deinit \(String(describing: type(of: self))) <<<<<<<<")
	}
	
	class func quickQuestIntoroViewController() -> QuickQuestIntoroViewController {
		
		let storyboard = UIStoryboard(name: "QuickQuestViewController", bundle: nil)
		let baseCnt = storyboard.instantiateViewController(withIdentifier: "QuickQuestIntoroView") as! QuickQuestIntoroViewController
		return baseCnt
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		DataManager.animationFuwa(v: fire1, dy: 10, speed: 2.0)
		DataManager.animationFuwa(v: fire2, dy: 10, speed: 2.2)
		DataManager.animationFuwa(v: fire3, dy: 10, speed: 2.3)
		DataManager.animationFuwa(v: fire4, dy: 10, speed: 1.8)
	}
	
	
	@IBOutlet weak var fire1: UIImageView!
	@IBOutlet weak var fire2: UIImageView!
	@IBOutlet weak var fire3: UIImageView!
	@IBOutlet weak var fire4: UIImageView!
	
	//戻る
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		self.remove()
	}
	
	//スタート
	@IBAction func startButtonAction(_ sender: UIButton) {
		
		let tag = sender.tag
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		let quickView = QuickQuestViewController.quickQuestViewController()
		quickView.mode = tag
		quickView.present(self) { 
			
		}
	}
}
