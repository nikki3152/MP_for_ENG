//
//  SoundViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class SoundViewController: BaseViewController {

	class func soundViewController() -> SoundViewController {
		
		let storyboard = UIStoryboard(name: "SoundViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! SoundViewController
		return baseCnt
	}
	
	var buttonList: [UIButton] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		for bt in self.baseView.subviews {
			if let bt = bt as? UIButton, bt.tag > 1 {
				buttonList.append(bt)
			}
		}
		self.playButton.isEnabled = false
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
	}
	
	@IBOutlet weak var cdImageView: UIImageView!
	@IBOutlet weak var baseView: UIView!
	
	//戻る
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		
		self.remove()
	}
	
	//再生
	@IBOutlet weak var playButton: UIButton!
	@IBAction func playButtonAction(_ sender: UIButton) {
		
		sender.isSelected = !sender.isSelected
		if sender.isSelected {
			cdImageView.layer.removeAnimation(forKey: "ImageViewRotation")
			let animation:CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
			animation.toValue = .pi / 2.0
			animation.duration = 0.1           // 指定した秒で90度回転
			animation.repeatCount = MAXFLOAT;   // 無限に繰り返す
			animation.isCumulative = true;         // 効果を累積
			cdImageView.layer.add(animation, forKey: "ImageViewRotation")
			cdImageView.layer.speed = 1.0
		} else {
			//let pausedTime: CFTimeInterval = cdImageView.layer.convertTime(CACurrentMediaTime(), from: nil)
			cdImageView.layer.speed = 0.0
			//cdImageView.layer.timeOffset = pausedTime
			
		}
	}
	
	//曲選択
	@IBAction func musicSelectButtonAction(_ sender: UIButton) {
		
		sender.isSelected = !sender.isSelected 
		for bt in self.buttonList {
			if sender.isSelected {
				if bt !== sender && bt.isSelected {
					bt.isSelected = false
				}
			}
		}
		self.playButton.isEnabled = sender.isSelected

	}
	
}
