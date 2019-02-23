//
//  SettingViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {

	class func settingViewController() -> SettingViewController {
		
		let storyboard = UIStoryboard(name: "SettingViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! SettingViewController
		return baseCnt
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.switchBGM.isSelected = UserDefaults.standard.bool(forKey: kBGMOn)
		self.switchSE.isSelected = UserDefaults.standard.bool(forKey: kSEOn)
		self.switchVoice.isSelected = UserDefaults.standard.bool(forKey: kVoiceOn)
		
		//ポイント
		let pp = UserDefaults.standard.integer(forKey: kPPPoint)
		self.ppButton.setTitle("\(pp)", for: .normal)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		self.updateMojikunString(txt: "もじピッタン")
	}
	
	//戻る
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		self.remove()
	}
	
	//データ集計
	@IBOutlet weak var dataAggregateButton: UIButton!
	@IBAction func dataAggregateButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		let dataView = DataAggregateViewController.dataAggregateViewController()
		dataView.present(self) { 
			
		}
	}
	//音楽
	@IBOutlet weak var soundButton: UIButton!
	@IBAction func soundButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		let soundView = SoundViewController.soundViewController()
		soundView.present(self) { 
			
		}
	}
	
	//遊び方
	@IBOutlet weak var  howToPlayButton: UIButton!
	@IBAction func howToPlayButtonAction(_ sender: UIButton) {
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
	}
	
	//評価する
	@IBOutlet weak var reviewButton: UIButton!
	@IBAction func reviewButtonAcgtion(_ sender: UIButton) {
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
	}
	
	//ポイント課金
	@IBOutlet weak var purchaseButton: UIButton!
	@IBAction func purchaseButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
	}
	
	// BGM
	@IBOutlet weak var switchBGM: UIButton!
	@IBAction func switchBGMAction(_ sender: UIButton) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		let on = !sender.isSelected
		sender.isSelected = on
		if on {
			UserDefaults.standard.set(sender.isSelected, forKey: kBGMOn)
			SoundManager.shared.startBGM(type: .bgmWait)
		} else {
			SoundManager.shared.stopBGM()
			UserDefaults.standard.set(sender.isSelected, forKey: kBGMOn)
		}
	}
	
	// SE
	@IBOutlet weak var switchSE: UIButton!
	@IBAction func switchSEAction(_ sender: UIButton) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		let on = !sender.isSelected
		sender.isSelected = on
		UserDefaults.standard.set(sender.isSelected, forKey: kSEOn)
	}
	
	// Voice
	@IBOutlet weak var switchVoice: UIButton!
	@IBAction func switchVoiceAction(_ sender: UIButton) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		let on = !sender.isSelected
		sender.isSelected = on
		UserDefaults.standard.set(sender.isSelected, forKey: kVoiceOn)
	}
	
	//ポイントボタン
	@IBOutlet weak var ppButton: UIButton!
	@IBAction func ppButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		let purchaseView = PurchaseViewController.purchaseViewController()
		purchaseView.present(self) { 
			
		}
		purchaseView.closeHandler = {[weak self]() in
			let pp = UserDefaults.standard.integer(forKey: kPPPoint)
			self?.purchaseButton.setTitle("\(pp)", for: .normal)
		}
	}
	
	
	
	@IBOutlet weak var ballonDisplayImageView: UIImageView!
	var ballonMainLabel: TTTAttributedLabel!
	func updateMojikunString(txt: String) {
		
		self.ballonMainLabel?.removeFromSuperview()
		let bLabel = makeVerticalLabel(size: self.ballonDisplayImageView.frame.size, font: UIFont.boldSystemFont(ofSize: 14), text: txt)
		bLabel.textAlignment = .center
		bLabel.numberOfLines = 2
		self.ballonDisplayImageView.addSubview(bLabel)
		bLabel.center = CGPoint(x: self.ballonDisplayImageView.frame.size.width / 2, y: self.ballonDisplayImageView.frame.size.height / 2)
		self.ballonMainLabel = bLabel
	}
}
