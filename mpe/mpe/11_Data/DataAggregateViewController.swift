//
//  DataAggregateViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class DataAggregateViewController: BaseViewController {

	
	var page1: DataPanelView!
	var page2: DataPanelView!
	
	deinit {
		print(">>>>>>>> deinit \(String(describing: type(of: self))) <<<<<<<<")
	}
	
	class func dataAggregateViewController() -> DataAggregateViewController {
		
		let storyboard = UIStoryboard(name: "DataAggregateViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! DataAggregateViewController
		return baseCnt
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe(_:)))
		leftSwipe.direction = .left
		self.view.addGestureRecognizer(leftSwipe)
		
		let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe(_:)))
		rightSwipe.direction = .right
		self.view.addGestureRecognizer(rightSwipe)
		
		
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
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		if page1 == nil {
			self.page1 = DataPanelView.dataPanelView(1)
			self.page2 = DataPanelView.dataPanelView(2)
			
			let userDef = UserDefaults.standard
			//トータルスコア
			let hiScore = userDef.integer(forKey: kTotalScore)
			self.page1.totalScore = hiScore
			//プレイ時間
			let time = userDef.double(forKey: kAlllPlayTimes)
			let h = Int(time / 3600)
			var m = Int(time / 60)
			if m >= 60 {
				m = m - (h * 60) 
			}
			let s = Int(time) % 60
			self.page1.playTimeLabel.text = "\(NSString(format: "%02d", h)):\(NSString(format: "%02d", m)):\(NSString(format: "%02d", s))"
			//ゲームクリア回数
			let gameClearCount = userDef.integer(forKey: kGameClearCount)
			self.page1.gameClearLabel.text = "\(gameClearCount)回"
			//ゲームオーバー回数
			let gameOverCount = userDef.integer(forKey: kGameOverCount)
			self.page1.gameOverLabel.text = "\(gameOverCount)回"
			//揃えた英単語数
			let gameWordsCount = userDef.integer(forKey: kGameWordsCount)
			self.page1.gameWordsLabel.text = "\(gameWordsCount)個"
			
			//ランダムモード（クリア回数／挑戦回数）
			//文字数
			let randomWordPlayCount = userDef.integer(forKey: kRandomWordPlayCount)
			let randomWordClearCount = userDef.integer(forKey: kRandomWordClearCount)
			self.page1.gandomWordsLabel.text = "\(randomWordClearCount) 回 / \(randomWordPlayCount) 回"
			//スコア
			let randomScorePlayCount = userDef.integer(forKey: kRandomScorePlayCount)
			let randomScoreClearCount = userDef.integer(forKey: kRandomScoreClearCount)
			self.page1.gandomScoreLabel.text = "\(randomScoreClearCount) 回 / \(randomScorePlayCount) 回"
			
			//一問一答（正答率／平均解答時間）
			//初級
			let biginnerTimes = userDef.double(forKey: kQuickBiginnerTimes)
			if biginnerTimes == 0 {
				self.page1.qqBiginnerLabel.text = "0 ％ / 0.0 Sec"
			} else {
				let biginnerCount = userDef.double(forKey: kQuickBiginnerCount)
				let biginnerCorrectCount = userDef.double(forKey: kQuickBiginnerCorrectCount)
				let bigginerTimeAvr: Double =  biginnerTimes / biginnerCount
				let bigginerCorrectPer: Double =  (biginnerCorrectCount / biginnerCount) * 100
				self.page1.qqBiginnerLabel.text = "\(NSString(format: "%.0f", bigginerCorrectPer))％ / \(NSString(format: "%.1f", bigginerTimeAvr)) Sec"
			}
			//中級
			let intermediateTimes = userDef.double(forKey: kQuickIntermediateTimes)
			if intermediateTimes == 0 {
				self.page1.qqIntermediateLabel.text = "0 ％ / 0.0 Sec"
			} else {
				let intermediateCount = userDef.double(forKey: kQuickBiginnerCount)
				let intermediateCorrectCount = userDef.double(forKey: kQuickBiginnerCorrectCount)
				let intermediateTimeAvr: Double =  intermediateTimes / intermediateCount
				let intermediateCorrectPer: Double =  (intermediateCorrectCount / intermediateCount) * 100
				self.page1.qqIntermediateLabel.text = "\(NSString(format: "%.0f", intermediateCorrectPer))％ / \(NSString(format: "%.1f", intermediateTimeAvr)) Sec"
			}
			//上級
			let advancedTimes = userDef.double(forKey: kQuickAdvancedTimes)
			if advancedTimes == 0 {
				self.page1.qqAdvancedLabel.text = "0 ％ / 0.0 Sec"
			} else {
				let advancedCount = userDef.double(forKey: kQuickAdvancedCount)
				let advancedCorrectCount = userDef.double(forKey: kQuickAdvancedCorrectCount)
				let advancedTimeAvr: Double =  advancedTimes / advancedCount
				let advancedCorrectPer: Double =  (advancedCorrectCount / advancedCount) * 100
				self.page1.qqAdvancedLabel.text = "\(NSString(format: "%.0f", advancedCorrectPer))％ / \(NSString(format: "%.1f", advancedTimeAvr)) Sec"
			}
			//神級
			let godTimes = userDef.double(forKey: kQuickGodTimes)
			if godTimes == 0 {
				self.page1.qqGodLabel.text = "0 ％ / 0.0 Sec"
			} else {
				let godCount = userDef.double(forKey: kQuickGodCount)
				let godCorrectCount = userDef.double(forKey: kQuickGodCorrectCount)
				let godTimeAvr: Double =  godTimes / godCount
				let godCorrectPer: Double =  (godCorrectCount / godCount) * 100
				self.page1.qqGodLabel.text = "\(NSString(format: "%.0f", godCorrectPer))％ / \(NSString(format: "%.1f", godTimeAvr)) Sec"
			}
			//ランダム
			let randomTimes = userDef.double(forKey: kQuickRandomTimes)
			if randomTimes == 0 {
				self.page1.qqRandomLabel.text = "0 ％ / 0.0 Sec"
			} else {
				let randomCount = userDef.double(forKey: kQuickRandomCount)
				let randomCorrectCount = userDef.double(forKey: kQuickRandomCorrectCount)
				let randomTimeAvr: Double =  randomTimes / randomCount
				let tandomCorrectPer: Double =  (randomCorrectCount / randomCount) * 100
				self.page1.qqRandomLabel.text = "\(NSString(format: "%.0f", tandomCorrectPer))％ / \(NSString(format: "%.1f", randomTimeAvr)) Sec"
			}
			
			
			self.currentPage = 1
		}
	}
	
	@objc func swipe(_ swipe: UISwipeGestureRecognizer) {
		
		let direction = swipe.direction 
		if direction == .left {
			self.currentPage += 1
		}
		else if direction == .right {
			self.currentPage -= 1
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

	@IBOutlet weak var baseView: UIView!
	
	//戻る
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		self.remove()
	}
	
	//左ボタン
	@IBOutlet weak var leftButton: UIButton!
	@IBAction func leftButtonAction(_ sender: Any) {
		
		self.currentPage -= 1
	}
	
	//右ボタン
	@IBOutlet weak var rightButton: UIButton!
	@IBAction func rightButtonAction(_ sender: Any) {
		
		self.currentPage += 1
	}
	
	var _currentPage: Int = 1
	var currentPage: Int {
		get {
			return _currentPage
		}
		set {
			_currentPage = newValue
			if _currentPage == 1 {
				self.leftButton.isHidden = true
				self.rightButton.isHidden = false
				if let _ = page2.superview {
					page2.removeFromSuperview()
				}
				self.baseView.addSubview(page1)
				page1.center = CGPoint(x: baseView.frame.size.width / 2, y: baseView.frame.size.height / 2)
			}
			else if _currentPage == 2 {
				self.leftButton.isHidden = false
				self.rightButton.isHidden = true
				if let _ = page1.superview {
					page1.removeFromSuperview()
				}
				self.baseView.addSubview(page2)
				page2.center = CGPoint(x: baseView.frame.size.width / 2, y: baseView.frame.size.height / 2)
			}
		}
	}
	
}
