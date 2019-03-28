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
		//ポイント
		let pp = MPEDataManager.getPP()
		if pp >= 90 {
			self.button1.isEnabled = true
			self.button2.isEnabled = true
			self.button3.isEnabled = true
			self.button4.isEnabled = true
			self.button5.isEnabled = true
		}
		else if pp >= 60 {
			self.button1.isEnabled = true
			self.button2.isEnabled = true
			self.button3.isEnabled = true
			self.button4.isEnabled = true
			self.button5.isEnabled = false
		}
		else if pp >= 40 {
			self.button1.isEnabled = true
			self.button2.isEnabled = true
			self.button3.isEnabled = true
			self.button4.isEnabled = false
			self.button5.isEnabled = false
		}
		else if pp >= 20 {
			self.button1.isEnabled = true
			self.button2.isEnabled = true
			self.button3.isEnabled = false
			self.button4.isEnabled = false
			self.button5.isEnabled = false
		}
		else {
			self.button1.isEnabled = true
			self.button2.isEnabled = false
			self.button3.isEnabled = false
			self.button4.isEnabled = false
			self.button5.isEnabled = false
		}
		
		self.backButton.isExclusiveTouch = true
		for v in self.buttonBaseView.subviews {
			if let bt = v as? UIButton {
				bt.isExclusiveTouch = true
			}
		}
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
	@IBOutlet weak var buttonBaseView: UIView!
	@IBOutlet weak var button1: UIButton!
	@IBOutlet weak var button2: UIButton!
	@IBOutlet weak var button3: UIButton!
	@IBOutlet weak var button4: UIButton!
	@IBOutlet weak var button5: UIButton!
	@IBAction func startButtonAction(_ sender: UIButton) {
		
		let tag = sender.tag
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		let quickView = QuickQuestViewController.quickQuestViewController()
		quickView.mode = tag
		quickView.present(self) { 
			
		}
	}
}
