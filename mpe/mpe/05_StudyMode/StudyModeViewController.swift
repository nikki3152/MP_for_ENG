//
//  StudyModeViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class StudyModeViewController: BaseViewController {
	
	class func studyModeViewController() -> StudyModeViewController {
		
		let storyboard = UIStoryboard(name: "StudyModeViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! StudyModeViewController
		return baseCnt
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	//戻る
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		self.remove()
	}
	
	//辞書モード
	@IBOutlet weak var dictModeButton: UIButton!
	@IBAction func dictModeButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		let dictView = DictViewController.dictViewController()
		dictView.present(self) { 
			
		}
	}
	
	//一問一答モード
	@IBOutlet weak var quickQuestModeButton: UIButton!
	@IBAction func quickQuestModeButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		let quickIntroView = QuickQuestIntoroViewController.quickQuestIntoroViewController()
		quickIntroView.present(self) { 
			
		}
	}
	
}
