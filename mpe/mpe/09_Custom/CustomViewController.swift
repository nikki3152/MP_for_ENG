//
//  CustomViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class CustomViewController: BaseViewController {

	class func customViewController() -> CustomViewController {
		
		let storyboard = UIStoryboard(name: "CustomViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! CustomViewController
		return baseCnt
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		DataManager.animationFuwa(v: onpu1, dy: 10, speed: 2.2)
		DataManager.animationFuwa(v: onpu2, dy: 10, speed: 2.0)
		DataManager.animationFuwa(v: onpu3, dy: 10, speed: 1.8)
		DataManager.animationFuwa(v: onpu4, dy: 10, speed: 2.0)
		
		DataManager.animationFuwa(v: charaImageView, dy: 15, speed: 1.8)
		
		let sel = UserDefaults.standard.integer(forKey: kSelectedCharaType)
		if let bt = charBtBaseView.viewWithTag(sel) as? UIButton {
			selectedButton = bt
			selectedButton.isSelected = true
		}
		//ポイント
		let pp = UserDefaults.standard.integer(forKey: kPPPoint)
		self.ppButton.setTitle("\(pp)", for: .normal)
	}
	
	//戻る
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		self.remove()
	}
	
	@IBOutlet weak var charaImageView: UIImageView!
	@IBOutlet weak var onpu1: UIImageView!
	@IBOutlet weak var onpu2: UIImageView!
	@IBOutlet weak var onpu3: UIImageView!
	@IBOutlet weak var onpu4: UIImageView!
	
	
	weak var selectedButton: UIButton!
	
	@IBOutlet weak var charBtBaseView: UIView!
	@IBOutlet weak var charCustomButton1: UIButton!
	@IBOutlet weak var charCustomButton2: UIButton!
	@IBOutlet weak var charCustomButton3: UIButton!
	@IBOutlet weak var charCustomButton4: UIButton!
	@IBOutlet weak var charCustomButton5: UIButton!
	@IBOutlet weak var charCustomButton6: UIButton!
	@IBOutlet weak var charCustomButton7: UIButton!
	@IBOutlet weak var charCustomButton8: UIButton!
	@IBOutlet weak var charCustomButton9: UIButton!
	@IBOutlet weak var charCustomButton10: UIButton!
	@IBAction func charCustomButtonAction(_ sender: UIButton) {
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		
		if sender !== selectedButton {
			selectedButton?.isSelected = false
			selectedButton = sender 
			selectedButton?.isSelected = true
			UserDefaults.standard.set(sender.tag, forKey: kSelectedCharaType)
		}
	}
	
	//ポイントボタン
	@IBOutlet weak var infoFukidasi: UIImageView!
	@IBOutlet weak var ppButton: UIButton!
	@IBAction func ppButtonAction(_ sender: Any) {
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		let purchaseView = PurchaseViewController.purchaseViewController()
		purchaseView.present(self) { 
			
		}
		purchaseView.closeHandler = {[weak self]() in
			let pp = UserDefaults.standard.integer(forKey: kPPPoint)
			self?.ppButton.setTitle("\(pp)", for: .normal)
		}
		
	}
	
}
