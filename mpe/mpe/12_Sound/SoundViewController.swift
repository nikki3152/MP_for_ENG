//
//  SoundViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class SoundViewController: BaseViewController {

	
	deinit {
		print(">>>>>>>> deinit \(String(describing: type(of: self))) <<<<<<<<")
	}
	
	class func soundViewController() -> SoundViewController {
		
		let storyboard = UIStoryboard(name: "SoundViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! SoundViewController
		return baseCnt
	}
	
	var buttonList: [UIButton] = []
	var selectedButtonTag: Int!
	
	
	var names = [
		"TOP画面",
		"待機画面",
		"一問一答",
		"初級ステージ",
		"中級ステージ",
		"上級ステージ",
		"神級ステージ",
		"ステージクリア",
		"ランダムクリア",
		"失敗",]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		for bt in self.baseView.subviews {
			if let bt = bt as? UIButton, bt.tag >= 1 {
				buttonList.append(bt)
			}
		}
		self.playButton.isEnabled = false
		SoundManager.shared.stopBGM()		//BGM停止
		
		for i in 1 ... 10 {
			if let bt = baseView.viewWithTag(i) as? UIButton {
				let text = names[i - 1]
				bt.setTitle(text, for: .normal)
			}
		}
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
	}
	
	@IBOutlet weak var cdImageView: UIImageView!
	@IBOutlet weak var baseView: UIView!
	
	//戻る
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		self.remove()
		SoundManager.shared.startBGM(type: .bgmWait)		//BGM再生
	}
	
	//再生
	@IBOutlet weak var playButton: UIButton!
	@IBAction func playButtonAction(_ sender: UIButton) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		sender.isSelected = !sender.isSelected
		discPlay(play: sender.isSelected)
	}
	
	//曲選択
	@IBAction func musicSelectButtonAction(_ sender: UIButton) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		let tag = sender.tag
		if tag == 1 {
			SoundManager.shared.startBGM(type: .bgmTop)
		}
		else if tag == 2 {
			SoundManager.shared.startBGM(type: .bgmWait)
		}
		else if tag == 3 {
			SoundManager.shared.startBGM(type: .bgmOneQuest)
		}
		else if tag == 4 {
			SoundManager.shared.startBGM(type: .bgmEasy)
		}
		else if tag == 5 {
			SoundManager.shared.startBGM(type: .bgmNormal)
		}
		else if tag == 6 {
			SoundManager.shared.startBGM(type: .bgmHard)
		}
		else if tag == 7 {
			SoundManager.shared.startBGM(type: .bgmGod)
		}
		else if tag == 8 {
			SoundManager.shared.startBGMLoopPlay(type: .bgmStageClear)
		}
		else if tag == 9 {
			SoundManager.shared.startBGMLoopPlay(type: .bgmStageRundom)
		}
		else if tag == 10 {
			SoundManager.shared.startBGMLoopPlay(type: .bgmFail)
		}
		
		self.selectedButtonTag = tag
		sender.isEnabled = false 
		for bt in self.buttonList {
			if sender.isEnabled == false {
				if bt !== sender && bt.isEnabled == false {
					bt.isEnabled = true
				}
			}
		}
		
		self.playButton.isEnabled = true
		self.playButton.isSelected = true
		
		discPlay(play: self.playButton.isSelected)
	}
	
	func discPlay(play: Bool) {
		
		if play {
			cdImageView.layer.removeAnimation(forKey: "ImageViewRotation")
			let animation:CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
			animation.toValue = .pi / 2.0
			animation.duration = 0.1           // 指定した秒で90度回転
			animation.repeatCount = MAXFLOAT;   // 無限に繰り返す
			animation.isCumulative = true;         // 効果を累積
			cdImageView.layer.add(animation, forKey: "ImageViewRotation")
			cdImageView.layer.speed = 1.0
			SoundManager.shared.pauseBGM(false)
		} else {
			cdImageView.layer.speed = 0.0
			SoundManager.shared.pauseBGM(true)
		}
	}
}
