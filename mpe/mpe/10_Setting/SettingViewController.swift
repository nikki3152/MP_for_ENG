//
//  SettingViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit
import StoreKit

class SettingViewController: BaseViewController {

	
	deinit {
		print(">>>>>>>> deinit \(String(describing: type(of: self))) <<<<<<<<")
	}
	
	
	var chaMessages: [String] = []
	
	var textIndex: Int = 0
	var textTimer: Timer!
	
	class func settingViewController() -> SettingViewController {
		
		let storyboard = UIStoryboard(name: "SettingViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! SettingViewController
		return baseCnt
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.switchBGM.isSelected = UserDefaults.standard.bool(forKey: kBGMOn)
		self.switchSE.isSelected = UserDefaults.standard.bool(forKey: kSEOn)
		
		//ポイント
		let pp = UserDefaults.standard.integer(forKey: kPPPoint)
		self.ppButton.setTitle("\(pp)", for: .normal)
		
		DataManager.animationFuwa(v: dataIconImageView, dy: 10, speed: 3.0)
		DataManager.animationFuwa(v: soundIconImageView, dy: 12, speed: 2.2)
		
		let ctype = UserDefaults.standard.integer(forKey: kSelectedCharaType)
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
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		if self.textTimer == nil {
			self.chaMessages = MPEDataManager.loadStringList(name: "mpe_キャラセリフ文言_設定画面", type: "csv")
			self.updateMojikunString(txt: chaMessages[textIndex])
			self.textTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self](t) in
				self?.textIndex += 1
				if self!.textIndex >= self!.chaMessages.count {
					self!.textIndex = 0
				}
				self?.updateMojikunString(txt: self!.chaMessages[self!.textIndex])
			})
		}
	}
	
	@IBOutlet weak var charaImageView: UIImageView!
	var _customChara: CustomChara = .mojikun_b
	var customChara: CustomChara {
		get {
			return _customChara 
		}
		set {
			_customChara = newValue
			if let shippo = charaImageView.viewWithTag(99) {
				shippo.removeFromSuperview()
			}
			self.charaImageView.image = UIImage(named: "\(_customChara.rawValue)_01")
			if _customChara == .taiyokun {
				let shippoView = UIImageView(frame: CGRect(x: 0, y: 0, width: charaImageView.frame.size.width, height: charaImageView.frame.size.height))
				shippoView.contentMode = .scaleAspectFit
				shippoView.image = UIImage(named: "taiyokun_shippo_01")
				shippoView.tag = 99
				charaImageView.addSubview(shippoView)
				DataManager.animationInfinityRotate(v: shippoView, speed: 0.1)
			}
		}
	}
	
	//戻る
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		
		self.textTimer?.invalidate()
		self.textTimer = nil
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		self.remove()
	}
	
	//データ集計
	@IBOutlet weak var databackImageView: UIImageView!
	@IBOutlet weak var dataIconImageView: UIImageView!
	@IBOutlet weak var dataAggregateButton: UIButton!
	@IBAction func dataAggregateButtonTapAction(_ sender: Any) {
		
		dataIconImageView.layer.removeAllAnimations()
		databackImageView.isHighlighted = true
	}
	@IBAction func dataAggregateButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		let dataView = DataAggregateViewController.dataAggregateViewController()
		dataView.present(self, completed: {[weak self]() in
			self?.databackImageView.isHighlighted = false
			DataManager.animationFuwa(v: self!.dataIconImageView, dy: 10, speed: 3.0)
		})
	}
	//音楽
	@IBOutlet weak var soundbackImageView: UIImageView!
	@IBOutlet weak var soundIconImageView: UIImageView!
	@IBOutlet weak var soundButton: UIButton!
	@IBAction func soundButtonTapAction(_ sender: Any) {
		
		soundIconImageView.layer.removeAllAnimations()
		soundbackImageView.isHighlighted = true
	}
	@IBAction func soundButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		let soundView = SoundViewController.soundViewController()
		soundView.present(self, completed: {[weak self]() in
			self?.soundbackImageView.isHighlighted = false
			DataManager.animationFuwa(v: self!.soundIconImageView, dy: 12, speed: 2.2)
		})
	}
	
	//遊び方
	var howtoNum: Int = 1
	@IBOutlet weak var  howToPlayButton: UIButton!
	@IBAction func howToPlayButtonAction(_ sender: UIButton) {
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		
		let backView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
		backView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
		self.view.addSubview(backView)
		let tap_remove = UITapGestureRecognizer(target: self, action: #selector(self.tapRemove(_ :)))
		backView.addGestureRecognizer(tap_remove)
		
		howtoNum = 1
		let howtoView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width - 40, height: self.view.bounds.size.height - 40))
		let name = "howto_\(howtoNum)"
		let image = UIImage(named: name)
		howtoView.image = image
		howtoView.contentMode = .scaleAspectFit
		howtoView.isUserInteractionEnabled = true
		backView.addSubview(howtoView)
		howtoView.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.size.height / 2)
		let tap_next = UITapGestureRecognizer(target: self, action: #selector(self.tapNext(_ :)))
		howtoView.addGestureRecognizer(tap_next)
		
		backView.alpha = 0
		UIView.animate(withDuration: 0.25, animations: { 
			backView.alpha = 1
		}, completion: nil)
	}
	
	//評価する
	@IBOutlet weak var reviewButton: UIButton!
	@IBAction func reviewButtonAcgtion(_ sender: UIButton) {
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		
		SKStoreReviewController.requestReview()
	}
	
	//クレジット
	@IBOutlet weak var purchaseButton: UIButton!
	@IBAction func purchaseButtonAction(_ sender: Any) {
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		
		let creditView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
		creditView.contentMode = .scaleAspectFill
		creditView.isUserInteractionEnabled = true
		creditView.image = UIImage(named: "setting_credit")
		self.view.addSubview(creditView)
		let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapRemove(_ :)))
		creditView.addGestureRecognizer(tap)
		
		creditView.alpha = 0
		UIView.animate(withDuration: 0.25, animations: { 
			creditView.alpha = 1
		}, completion: nil)
	}
	
	@objc func tapRemove(_ tap: UITapGestureRecognizer) {
		
		if let v = tap.view {
			UIView.animate(withDuration: 0.25, animations: { 
				v.alpha = 0
			}) { (stop) in
				v.removeFromSuperview()
			}
		}
	}
	
	@objc func tapNext(_ tap: UITapGestureRecognizer) {
		
		if let v = tap.view as? UIImageView {
			howtoNum += 1
			if howtoNum >= 9 {
				SoundManager.shared.startSE(type: .seSelect)	//SE再生
				howtoNum = 1
				if let sv = v.superview {
					UIView.animate(withDuration: 0.25, animations: { 
						sv.alpha = 0
					}) { (stop) in
						sv.removeFromSuperview()
					}
				}
			} else {
				SoundManager.shared.startSE(type: .seSelect)	//SE再生
				v.image = UIImage(named: "howto_\(howtoNum)")
			}
		}
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
	
	//ポイントボタン
	@IBOutlet weak var ppButton: UIButton!
	@IBAction func ppButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seDone)	//SE再生
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
		let font = UIFont(name: "UDDigiKyokashoN-B", size: 14)!
		let bLabel = makeVerticalLabel(size: self.ballonDisplayImageView.frame.size, font: font, text: txt)
		bLabel.textAlignment = .left
		bLabel.numberOfLines = 3
		self.ballonDisplayImageView.addSubview(bLabel)
		bLabel.center = CGPoint(x: self.ballonDisplayImageView.frame.size.width / 2, y: self.ballonDisplayImageView.frame.size.height / 2)
		self.ballonMainLabel = bLabel
	}
}
