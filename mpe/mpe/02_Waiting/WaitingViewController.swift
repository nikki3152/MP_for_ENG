//
//  WaitingViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class WaitingViewController: BaseViewController, ADViewVideoDelegate {

	//MARK: ADViewVideoDelegate
	func adViewDidPlayVideo(_ adView: ADView, incentive: Bool) {
		
		if incentive {
			//ポイント
			let pp = UserDefaults.standard.integer(forKey: kPPPoint) + 1
			self.purchaseButton.setTitle("\(pp)", for: .normal)
			MPEDataManager.updatePP(pp: pp)
		}
	}
	func adViewLoadVideo(_ adView: ADView, canLoad: Bool) {
		
	}
	func adViewDidCloseVideo(_ adView: ADView, incentive: Bool) {
		
		SoundManager.shared.pauseBGM(false)
		if incentive {
			
		}
	}
	
	
	class func waitingViewController() -> WaitingViewController {
		
		let storyboard = UIStoryboard(name: "WaitingViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! WaitingViewController
		return baseCnt
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		SoundManager.shared.startBGM(type: .bgmWait)		//BGM再生
		
		DataManager.animationFuwa(v: stageSelectImgView, dy: 10, speed: 3.0)
		DataManager.animationFuwa(v: studyModeImgView, dy: 12, speed: 2.2)
		DataManager.animationFuwa(v: customImgView, dy: 13, speed: 3.2)
		DataManager.animationFuwa(v: settingImgView, dy: 14, speed: 2.6)
		
		//ポイント
		let pp = UserDefaults.standard.integer(forKey: kPPPoint)
		self.purchaseButton.setTitle("\(pp)", for: .normal)
    }
	
	
	//ひとりでパズル
	@IBOutlet weak var stageSelectBkImgView: UIImageView!
	@IBOutlet weak var stageSelectImgView: UIImageView!
	@IBOutlet weak var stageSelectButton: UIButton!
	@IBAction func stageSelectButtpnAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		let stageSelView = StageSelectViewController.stageSelectViewController()
		stageSelView.present(self) { 
			
		}
	}
	
	//勉強モード
	@IBOutlet weak var studyModeBkImgView: UIImageView!
	@IBOutlet weak var studyModeImgView: UIImageView!
	@IBOutlet weak var studyModeButton: UIButton!
	@IBAction func studyModeButtpnAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		let studyView = StudyModeViewController.studyModeViewController()
		studyView.present(self) { 
			
		}
	}
	
	//カスタム
	@IBOutlet weak var customBkImgView: UIImageView!
	@IBOutlet weak var customImgView: UIImageView!
	@IBOutlet weak var customButton: UIButton!
	@IBAction func customButtpnAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		let customView = CustomViewController.customViewController()
		customView.present(self) { 
			
		}
	}
	
	//設定
	@IBOutlet weak var settingBkImgView: UIImageView!
	@IBOutlet weak var settingImgView: UIImageView!
	@IBOutlet weak var settingButton: UIButton!
	@IBAction func settingButtpnAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		let settingView = SettingViewController.settingViewController()
		settingView.present(self) { 
			
		}
	}
	
	
	@IBOutlet weak var videoButton: UIButton!
	@IBAction func videoButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		
		//MARK: 動画デバッグ
		self.adViewDidPlayVideo(adVideoReward, incentive: true)

//		if adVideoReward.isCanPlayVideo {
//			adVideoReward.playVideo()
//			SoundManager.shared.pauseBGM(true)
//		} else {
//			let alert = UIAlertController(title: nil, message: "動画を再生できませんでした！！", preferredStyle: .alert)
//			alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: nil))
//			self.present(alert, animated: true, completion: nil)
//		}
	}
	
	//ポイント課金
	@IBOutlet weak var purchaseButton: UIButton!
	@IBAction func purchaseButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		let purchaseView = PurchaseViewController.purchaseViewController()
		purchaseView.present(self) { 
			
		}
		purchaseView.closeHandler = {[weak self]() in
			let pp = UserDefaults.standard.integer(forKey: kPPPoint)
			self?.purchaseButton.setTitle("\(pp)", for: .normal)
		}
	}
	
}
