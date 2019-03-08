//
//  CustomViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class CustomViewController: BaseViewController {

	var _customChara: CustomChara = .mojikun_b
	var customChara: CustomChara {
		get {
			return _customChara 
		}
		set {
			_customChara = newValue
			self.charaImageView.image = UIImage(named: "\(_customChara.rawValue)_01")
		}
	}
	
	
	deinit {
		print(">>>>>>>> deinit \(String(describing: type(of: self))) <<<<<<<<")
	}
	
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
		
		let ctype = UserDefaults.standard.integer(forKey: kSelectedCharaType)
		if let bt = charBtBaseView.viewWithTag(ctype) as? UIButton {
			selectedButton = bt
			selectedButton.isSelected = true
		}
		if ctype == 1 {
			self.customChara = .mojikun_b
		}
		else if ctype == 2 {
			self.customChara = .mojichan
		}
		else if ctype == 3 {
			self.customChara = .taiyokun
		}
		else if ctype == 4 {
			self.customChara = .tsukikun
		}
		else if ctype == 5 {
			self.customChara = .kumokun
		}
		else if ctype == 6 {
			self.customChara = .mojikun_a
		}
		else if ctype == 7 {
			self.customChara = .pack
		}
		else if ctype == 8 {
			self.customChara = .ouji
		}
		else if ctype == 9 {
			self.customChara = .driller
		}
		else if ctype == 10 {
			self.customChara = .galaga
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		updatePP()
	}
	
	func updatePP() {
		
		//ポイント
		let pp = UserDefaults.standard.integer(forKey: kPPPoint)
		self.ppButton.setTitle("\(pp)", for: .normal)
		
		if pp >= 70 {
			charCustomButton1.isEnabled = true
			charCustomButton2.isEnabled = true
			charCustomButton3.isEnabled = true
			charCustomButton4.isEnabled = true
			charCustomButton5.isEnabled = true
			charCustomButton6.isEnabled = true
			charCustomButton7.isEnabled = true
			charCustomButton8.isEnabled = true
			charCustomButton9.isEnabled = true
			charCustomButton10.isEnabled = true
		}
		else if pp >= 50 {
			charCustomButton1.isEnabled = true
			charCustomButton2.isEnabled = true
			charCustomButton3.isEnabled = true
			charCustomButton4.isEnabled = true
			charCustomButton5.isEnabled = true
			charCustomButton6.isEnabled = true
			charCustomButton7.isEnabled = true
			charCustomButton8.isEnabled = false
			charCustomButton9.isEnabled = false
			charCustomButton10.isEnabled = false
		}
		else if pp >= 30 {
			charCustomButton1.isEnabled = true
			charCustomButton2.isEnabled = true
			charCustomButton3.isEnabled = true
			charCustomButton4.isEnabled = true
			charCustomButton5.isEnabled = true
			charCustomButton6.isEnabled = false
			charCustomButton7.isEnabled = false
			charCustomButton8.isEnabled = false
			charCustomButton9.isEnabled = false
			charCustomButton10.isEnabled = false
		}
		else if pp >= 10 {
			charCustomButton1.isEnabled = true
			charCustomButton2.isEnabled = true
			charCustomButton3.isEnabled = true
			charCustomButton4.isEnabled = false
			charCustomButton5.isEnabled = false
			charCustomButton6.isEnabled = false
			charCustomButton7.isEnabled = false
			charCustomButton8.isEnabled = false
			charCustomButton9.isEnabled = false
			charCustomButton10.isEnabled = false
		}
		else {
			charCustomButton1.isEnabled = true
			charCustomButton2.isEnabled = false
			charCustomButton3.isEnabled = false
			charCustomButton4.isEnabled = false
			charCustomButton5.isEnabled = false
			charCustomButton6.isEnabled = false
			charCustomButton7.isEnabled = false
			charCustomButton8.isEnabled = false
			charCustomButton9.isEnabled = false
			charCustomButton10.isEnabled = false
		}
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
			if sender.tag == 1 {
				self.customChara = .mojikun_b
			}
			else if sender.tag == 2 {
				self.customChara = .mojichan
			}
			else if sender.tag == 3 {
				self.customChara = .taiyokun
			}
			else if sender.tag == 4 {
				self.customChara = .tsukikun
			}
			else if sender.tag == 5 {
				self.customChara = .kumokun
			}
			else if sender.tag == 6 {
				self.customChara = .mojikun_a
			}
			else if sender.tag == 7 {
				self.customChara = .pack
			}
			else if sender.tag == 8 {
				self.customChara = .ouji
			}
			else if sender.tag == 9 {
				self.customChara = .driller
			}
			else if sender.tag == 10 {
				self.customChara = .galaga
			}
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
			self?.updatePP()
		}
		
	}
	
}
