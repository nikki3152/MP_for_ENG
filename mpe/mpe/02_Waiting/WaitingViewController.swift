//
//  WaitingViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class WaitingViewController: BaseViewController {

	class func waitingViewController() -> WaitingViewController {
		
		let storyboard = UIStoryboard(name: "WaitingViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! WaitingViewController
		return baseCnt
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		SoundManager.shared.startBGM(type: .bgmWait)		//BGM再生
    }
	
	//ひとりでパズル
	@IBOutlet weak var stageSelectButton: UIButton!
	@IBAction func stageSelectButtpnAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		let stageSelView = StageSelectViewController.stageSelectViewController()
		stageSelView.present(self) { 
			
		}
	}
	
	//勉強モード
	@IBOutlet weak var studyModeButton: UIButton!
	@IBAction func studyModeButtpnAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		let studyView = StudyModeViewController.studyModeViewController()
		studyView.present(self) { 
			
		}
	}
	
	//カスタム
	@IBOutlet weak var customButton: UIButton!
	@IBAction func customButtpnAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		let customView = CustomViewController.customViewController()
		customView.present(self) { 
			
		}
	}
	
	//設定
	@IBOutlet weak var settingButton: UIButton!
	@IBAction func settingButtpnAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		let settingView = SettingViewController.settingViewController()
		settingView.present(self) { 
			
		}
	}
	
	//ポイント課金
	@IBOutlet weak var purchaseButton: UIButton!
	@IBAction func purchaseButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		let purchaseView = PurchaseViewController.purchaseViewController()
		purchaseView.present(self) { 
			
		}
	}
	
}
