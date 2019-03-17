//
//  StageSelectViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class StageSelectViewController: BaseViewController {

	
	deinit {
		print(">>>>>>>> deinit \(String(describing: type(of: self))) <<<<<<<<")
	}
	
	@IBOutlet weak var leftChaImageView: UIImageView!
	@IBOutlet weak var rightChaImageView: UIImageView!
	
	
	@IBOutlet weak var stageSumbImageView: UIImageView!
	@IBOutlet weak var backImageView: UIImageView!
	@IBOutlet weak var timeLimitLabel: UILabel!
	@IBOutlet weak var targetScoreLabel: UILabel!
	@IBOutlet weak var hiScoreLabel: UILabel!
	@IBOutlet weak var stageTitleLabel: UILabel!
	
	let dataMrg: MPEDataManager = MPEDataManager()
	var questNames: [String] = []
	var questDatas: [QuestData] = []
	var startIndex: Int = 0
	//MARK: 問題データ
	func questData(at: Int) -> QuestData? {
		
		var questData = questDatas[at]
		if at < questDatas.count {
			
			if at >= 80 && at <= 82 {
				if at != 82 {
					//ランダムステージ
					let cAry: [String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
					//テーブル配置
					var table = questData.table
					let mojiMax = Int.random(in: 5 ... 20)
					for _ in 0 ..< mojiMax {
						let index = Int.random(in: 0 ..< table.count)
						let r = Int.random(in: 0 ..< cAry.count)
						let moji = cAry[r]
						table[index] = moji
					}
					questData.table = table
					
					if at == 80 {
						//文字数ランダム
						//手札配置
						let cFont: [String] = ["B","C","D","F","G","H","J","K","L","M","N","P","Q","R","S","T","V","W","X","Y","Z"]
						var cards = questData.cards
						//let count = cards.count
						for _ in 0 ... 44 {
							let r = Int.random(in: 0 ..< cFont.count)
							let moji = cFont[r]
							cards.append(moji)
						}
						questData.cards = cards
						questData.wildCardLen = 5
						//文字数設定
						let words = Int.random(in: 3 ... 7)
						let count = Int.random(in: 3 ... 10)
						questData.questData = ["words":words, "count":count]
					}
					else if at == 81 {
						//スコアランダム
						//スコア設定
						let count = Int.random(in: 1 ... 14) * 500
						questData.questData = ["count":count]
						//特殊マス配置
						var tableType = questData.tableType
						var emptyCells: [Int] = []
						for i in 0 ..< questData.table.count {
							let moji = questData.table[i]
							if moji == "0" {
								emptyCells.append(i)
							}
						}
						let spCellMax = Int.random(in: 5 ... 20)
						let spcell = ["DL","TL","DW","TW"]
						for _ in 0 ..< spCellMax {
							let index = Int.random(in: 0 ..< emptyCells.count)
							if table[index] == "0" {
								emptyCells.remove(at: index)
								let sp = spcell[Int.random(in: 0 ..< 4)] 
								tableType[index] = sp
							}
						}
						questData.tableType = tableType
					}
				} else {
					//アンリミテッド
					
				}
			}
			//print("問題データ:\(questData!)")
		}
		return questData
	}
	
	//MARK: ページ
	var _currentPage: Int = 1
	var currentPage: Int {
		get {
			return _currentPage
		}
		set {
			_currentPage = newValue
			self.startIndex = (_currentPage - 1) * 10
			//ポイント
			let pp = UserDefaults.standard.integer(forKey: kPPPoint)
			var pageEnabled = false
			//ステージ有効フラグ
			let stageEnableAry = UserDefaults.standard.object(forKey: kEnableStageArry) as! [Bool]
			let page1StStageEnable = stageEnableAry[startIndex]
			for i in 0 ..< self.stageButtons.count {
				let stageIndex = self.startIndex + i
				let stageNum = "\(NSString(format: "%02d", stageIndex + 1))"
				let bt = self.stageButtons[i]
				if Int(stageNum)! >= 84 {
					bt.isHidden = true
				} else {
					bt.isHidden = false
					if stageIndex >= 0 && stageIndex <= 19 {
						//初級
						pageEnabled = true
					}
					if stageIndex >= 20 && stageIndex <= 39 {
						//中級
						if pp >= 20 {
							pageEnabled = true
						}
					}
					if stageIndex >= 40 && stageIndex <= 59 {
						//上級
						if pp >= 40 {
							pageEnabled = true
						}
					}
					if stageIndex >= 60 && stageIndex <= 79 {
						//神級
						if pp >= 60 {
							pageEnabled = true
						}
					}
					if stageIndex >= 80 && stageIndex <= 82 {
						//ランダム
						if pp >= 100 {
							pageEnabled = true
						}
					}
					
					if pageEnabled {
						//解放
						let enable = stageEnableAry[stageIndex]
						bt.isEnabled = enable
						if enable {
							if bt.isSelected {
								bt.setImage(nil, for: .normal)
							} else {
								let image = UIImage(named: "select_\(stageNum)")
								bt.setImage(image, for: .normal)
							}
						} else {
							bt.isSelected = false
							bt.setImage(nil, for: .normal)
						}
					} else {
						//未解放
						bt.isEnabled = false
						bt.isSelected = false
						bt.setImage(nil, for: .normal)
					}
				}
			}
			if _currentPage == 1 {
				self.leftButton.isHidden = true
				self.rightButton.isHidden = false
				self.leftImageView.isHidden = true
				self.rightImageView.isHidden = false
			}
			else if _currentPage == self.maxPage {
				self.leftButton.isHidden = false
				self.rightButton.isHidden = true
				self.leftImageView.isHidden = false
				self.rightImageView.isHidden = true
			}
			else {
				self.leftButton.isHidden = false
				self.rightButton.isHidden = false
				self.leftImageView.isHidden = false
				self.rightImageView.isHidden = false
			}
			
			let num = NSString(format: "%02d", _currentPage)
			let pageImage = UIImage(named: "select_stagemap_\(num)")
			self.stagePageImgView.image = pageImage
			
			//先頭ステージ解放
			if page1StStageEnable {
				//時間を表示
				targetScoreLabel.isHidden = false
				timeLimitLabel.isHidden = false
			} else {
				//時間を隠す
				targetScoreLabel.isHidden = true
				timeLimitLabel.isHidden = true
			}
			
			if _currentPage == 1 || _currentPage == 2 {
				//初級
				self.stageLeftButton.isHidden = true
				self.stageRightButton.isHidden = false
				self.stageLeftButton.setBackgroundImage(UIImage(named: "select_mapchange_left"), for: .normal)
				self.stageRightButton.setBackgroundImage(UIImage(named: "select_mapchange_right_intermediate"), for: .normal)
				self.backImageView.image = UIImage(named: "select_background_01")
				ppInfoBallonImageView.isHidden = true
				ppInfoBallonImageView.layer.removeAllAnimations()
			}
			else if _currentPage == 3 || _currentPage == 4 {
				//中級
				if page1StStageEnable == false && pp < 20 {
					ppInfoBallonImageView.isHidden = false
					MPEDataManager.animationFuwa(v: ppInfoBallonImageView, dy: 8, speed: 2.5)
				} else {
					ppInfoBallonImageView.isHidden = true
				}
				self.stageLeftButton.isHidden = false
				self.stageRightButton.isHidden = false
				self.stageLeftButton.setBackgroundImage(UIImage(named: "select_mapchange_left_biginner"), for: .normal)
				self.stageRightButton.setBackgroundImage(UIImage(named: "select_mapchange_right_advanced"), for: .normal)
				self.backImageView.image = UIImage(named: "select_background_02")
			}
			else if _currentPage == 5 || _currentPage == 6 {
				//上級
				if page1StStageEnable == false && pp < 40 {
					ppInfoBallonImageView.isHidden = false
					MPEDataManager.animationFuwa(v: ppInfoBallonImageView, dy: 8, speed: 2.5)
				} else {
					ppInfoBallonImageView.isHidden = true
				}
				self.stageLeftButton.isHidden = false
				self.stageRightButton.isHidden = false
				self.stageLeftButton.setBackgroundImage(UIImage(named: "select_mapchange_left_intermediate"), for: .normal)
				self.stageRightButton.setBackgroundImage(UIImage(named: "select_mapchange_right_god"), for: .normal)
				self.backImageView.image = UIImage(named: "select_background_03")
			}
			else if _currentPage == 7 || _currentPage == 8 {
				//神級
				if page1StStageEnable == false && pp < 60 {
					ppInfoBallonImageView.isHidden = false
					MPEDataManager.animationFuwa(v: ppInfoBallonImageView, dy: 8, speed: 2.5)
				} else {
					ppInfoBallonImageView.isHidden = true
				}
				self.stageLeftButton.isHidden = false
				self.stageRightButton.isHidden = false
				self.stageLeftButton.setBackgroundImage(UIImage(named: "select_mapchange_left_advanced"), for: .normal)
				self.stageRightButton.setBackgroundImage(UIImage(named: "select_mapchange_right_random"), for: .normal)
				self.backImageView.image = UIImage(named: "select_background_04")
			}
			else if _currentPage == 9  {
				//ランダム
				if page1StStageEnable == false && pp < 100 {
					ppInfoBallonImageView.isHidden = false
					MPEDataManager.animationFuwa(v: ppInfoBallonImageView, dy: 8, speed: 2.5)
				} else {
					ppInfoBallonImageView.isHidden = true
				}
				self.stageLeftButton.isHidden = false
				self.stageRightButton.isHidden = true
				self.stageLeftButton.setBackgroundImage(UIImage(named: "select_mapchange_left_god"), for: .normal)
				self.stageRightButton.setBackgroundImage(UIImage(named: "select_mapchange_right"), for: .normal)
				self.backImageView.image = UIImage(named: "select_background_05")
			}
			
		}
	}
	var maxPage: Int = 0
	
	var _customChara: CustomChara = .mojikun_b
	var customChara: CustomChara {
		get {
			return _customChara 
		}
		set {
			_customChara = newValue
			if let shippo = rightChaImageView.viewWithTag(99) {
				shippo.removeFromSuperview()
			}
			self.rightChaImageView.image = UIImage(named: "\(_customChara.rawValue)_01")
			if _customChara == .taiyokun {
				let shippoView = UIImageView(frame: CGRect(x: 0, y: 0, width: rightChaImageView.frame.size.width, height: rightChaImageView.frame.size.height))
				shippoView.contentMode = .scaleAspectFit
				shippoView.image = UIImage(named: "taiyokun_shippo_01")
				shippoView.tag = 99
				rightChaImageView.addSubview(shippoView)
				DataManager.animationInfinityRotate(v: shippoView, speed: 0.1)
			}
		}
	}
	
	class func stageSelectViewController() -> StageSelectViewController {
		
		let storyboard = UIStoryboard(name: "StageSelectViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! StageSelectViewController
		return baseCnt
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.stageButtons = [
			self.stageButton1,
			self.stageButton2,
			self.stageButton3,
			self.stageButton4,
			self.stageButton5,
			self.stageButton6,
			self.stageButton7,
			self.stageButton8,
			self.stageButton9,
			self.stageButton10,
		]
		self.questDatas = []
		let easy = self.dataMrg.questList(mode: "easy")
		let normal = self.dataMrg.questList(mode: "normal")
		let hard = self.dataMrg.questList(mode: "hard")
		let god = self.dataMrg.questList(mode: "god")
		let random = self.dataMrg.questList(mode: "random")
		let list = easy + normal + hard + god + random
		for dic in list {
			let filename = dic["filename"]!
			self.questNames.append(filename)
			if let path = Bundle.main.path(forResource: filename, ofType: "plist") {
				if let dic = NSDictionary(contentsOfFile: path) as? [String:Any] {
					var questData = QuestData(dict: dic)
					questData.filename = filename
					self.questDatas.append(questData)
				}
			}
		}
		//ハイスコア
		let hiscore = UserDefaults.standard.integer(forKey: kHiscore)
		self.hiScoreLabel.text = "\(hiscore)"
		
		self.maxPage = 9//(self.questDatas.count / 10) + (self.questDatas.count % 10)
		//選択
		let index = UserDefaults.standard.integer(forKey: kCurrentQuestIndex)
		self.selectStage(index: index)
		
		//ポイント
		let pp = UserDefaults.standard.integer(forKey: kPPPoint)
		self.ppButton.setTitle("\(pp)", for: .normal)
		
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
		
		DataManager.animationFuwa(v: leftChaImageView, dy: 10, speed: 2.0)
		DataManager.animationFuwa(v: rightChaImageView, dy: 10, speed: 3.3)
		
		DataManager.animationFuwa(v: leftImageView, dx: 10, speed: 2.2)
		DataManager.animationFuwa(v: rightImageView, dx: 10, speed: 2.0)
		
		let sumbFrame = stageSumbImageView.frame
		stageLeftButton.center = CGPoint(x: sumbFrame.origin.x - (stageLeftButton.frame.size.width / 2), y: stageLeftButton.center.y)
		stageRightButton.center = CGPoint(x: sumbFrame.origin.x + sumbFrame.size.width + (stageLeftButton.frame.size.width / 2), y: stageRightButton.center.y)
	}
	
	//戻る
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		
		self.selectTimer?.invalidate()
		self.selectTimer = nil
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		self.remove()
	}
	
	//MARK: ポイントボタン
	@IBOutlet weak var ppButton: UIButton!
	@IBAction func ppButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		let purchaseView = PurchaseViewController.purchaseViewController()
		purchaseView.present(self) { 
			
		}
		purchaseView.closeHandler = {[weak self]() in
			let pp = UserDefaults.standard.integer(forKey: kPPPoint)
			self?.ppButton.setTitle("\(pp)", for: .normal)
			self?.currentPage = self!._currentPage
			let index = self!.stageButton1.tag + self!.startIndex
			self?.selectStage(index: index)
		}
	}
	@IBOutlet weak var ppInfoBallonImageView: UIImageView!
	
	
	@IBOutlet weak var stagePageImgView: UIImageView!
	
	//MARK: ステージ移動ボタン
	@IBOutlet weak var stageLeftButton: UIButton!
	@IBAction func stageLeftButtonAction(_ sender: UIButton) {
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		sender.isUserInteractionEnabled = false
		let x = self.buttonBaseView.center.x
		UIView.animate(withDuration: 0.25, animations: { 
			self.buttonBaseView.center = CGPoint(x: x + (self.buttonBaseView.frame.size.width/2), y: self.buttonBaseView.center.y)
			self.buttonBaseView.alpha = 0
		}) { [weak self](stop) in
			guard let s = self else {
				return
			}
			if s.currentPage == 1 || s.currentPage == 2 {
			}
			else if s.currentPage == 3 || s.currentPage == 4 {
				s.currentPage = 1
			}
			else if s.currentPage == 5 || s.currentPage == 6 {
				s.currentPage = 3
			}
			else if s.currentPage == 7 || s.currentPage == 8 {
				s.currentPage = 5
			}
			else if s.currentPage == 9  {
				s.currentPage = 7
			}
			//選択
			let index = s.stageButton1.tag + s.startIndex
			s.selectStage(index: index)
			
			s.buttonBaseView.center = CGPoint(x: -(s.buttonBaseView.frame.size.width/2), y: s.buttonBaseView.center.y)
			UIView.animate(withDuration: 0.25, animations: { 
				s.buttonBaseView.center = CGPoint(x: x, y: s.buttonBaseView.center.y)
				s.buttonBaseView.alpha = 1
			}) { (stop) in
				sender.isUserInteractionEnabled = true
			}
		}
	}
	@IBOutlet weak var stageRightButton: UIButton!
	@IBAction func stageRightButtonAction(_ sender: UIButton) {
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		sender.isUserInteractionEnabled = false
		let x = self.buttonBaseView.center.x
		UIView.animate(withDuration: 0.25, animations: { 
			self.buttonBaseView.center = CGPoint(x: -(self.buttonBaseView.frame.size.width/2), y: self.buttonBaseView.center.y)
			self.buttonBaseView.alpha = 0
		}) { [weak self](stop) in
			guard let s = self else {
				return
			}
			if s.currentPage == 1 || s.currentPage == 2 {
				s.currentPage = 3
			}
			else if s.currentPage == 3 || s.currentPage == 4 {
				s.currentPage = 5
			}
			else if s.currentPage == 5 || s.currentPage == 6 {
				s.currentPage = 7
			}
			else if s.currentPage == 7 || s.currentPage == 8 {
				s.currentPage = 9
			}
			else if s.currentPage == 9  {
			}
			//選択
			let index = s.stageButton1.tag + s.startIndex
			s.selectStage(index: index)
			
			s.buttonBaseView.center = CGPoint(x: x + (s.buttonBaseView.frame.size.width/2), y: s.buttonBaseView.center.y)
			UIView.animate(withDuration: 0.25, animations: { 
				s.buttonBaseView.center = CGPoint(x: x, y: s.buttonBaseView.center.y)
				s.buttonBaseView.alpha = 1
			}) { (stop) in
				sender.isUserInteractionEnabled = true
			}
		}
	}
	
	//MARK: 左ボタン
	@IBOutlet weak var leftImageView: UIImageView!
	@IBOutlet weak var leftButton: UIButton!
	@IBAction func leftButtonAction(_ sender: UIButton) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		sender.isUserInteractionEnabled = false
		let x = self.buttonBaseView.center.x
		UIView.animate(withDuration: 0.25, animations: { 
			self.buttonBaseView.center = CGPoint(x: x + (self.buttonBaseView.frame.size.width/2), y: self.buttonBaseView.center.y)
			self.buttonBaseView.alpha = 0
		}) { [weak self](stop) in
			guard let s = self else {
				return
			}
			s.currentPage -= 1
//			s.stageSelectedButton?.isSelected = false
//			s.stageSelectedButton = s.stageButton1
//			s.stageSelectedButton?.isSelected = true
			//選択
			let index = s.stageButton1.tag + s.startIndex
			s.selectStage(index: index)
			
			s.buttonBaseView.center = CGPoint(x: -(s.buttonBaseView.frame.size.width/2), y: s.buttonBaseView.center.y)
			UIView.animate(withDuration: 0.25, animations: { 
				s.buttonBaseView.center = CGPoint(x: x, y: s.buttonBaseView.center.y)
				s.buttonBaseView.alpha = 1
			}) { (stop) in
				sender.isUserInteractionEnabled = true
			}
		}
	}
	//MARK: 右ボタン
	@IBOutlet weak var rightImageView: UIImageView!
	@IBOutlet weak var rightButton: UIButton!
	@IBAction func rightButtonAction(_ sender: UIButton) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		sender.isUserInteractionEnabled = false
		let x = self.buttonBaseView.center.x
		UIView.animate(withDuration: 0.25, animations: { 
			self.buttonBaseView.center = CGPoint(x: -(self.buttonBaseView.frame.size.width/2), y: self.buttonBaseView.center.y)
			self.buttonBaseView.alpha = 0
		}) { [weak self](stop) in
			guard let s = self else {
				return
			}
			s.currentPage += 1
//			s.stageSelectedButton?.isSelected = false
//			s.stageSelectedButton = s.stageButton1
//			s.stageSelectedButton?.isSelected = true
			//選択
			let index = s.stageButton1.tag + s.startIndex
			s.selectStage(index: index)
			
			s.buttonBaseView.center = CGPoint(x: x + (s.buttonBaseView.frame.size.width/2), y: s.buttonBaseView.center.y)
			UIView.animate(withDuration: 0.25, animations: { 
				s.buttonBaseView.center = CGPoint(x: x, y: s.buttonBaseView.center.y)
				s.buttonBaseView.alpha = 1
			}) { (stop) in
				sender.isUserInteractionEnabled = true
			}
		}
	}
	
	
	@IBOutlet weak var buttonBaseView: UIView!
	
	var gotoGameFlashCount: Int = 0
	
	//MARK: ステージ選択ボタン
	var selectTimer: Timer!
	weak var stageSelectedButton: UIButton!
	var stageButtons: [UIButton] = []
	@IBOutlet weak var stageButton1: UIButton!
	@IBOutlet weak var stageButton2: UIButton!
	@IBOutlet weak var stageButton3: UIButton!
	@IBOutlet weak var stageButton4: UIButton!
	@IBOutlet weak var stageButton5: UIButton!
	@IBOutlet weak var stageButton6: UIButton!
	@IBOutlet weak var stageButton7: UIButton!
	@IBOutlet weak var stageButton8: UIButton!
	@IBOutlet weak var stageButton9: UIButton!
	@IBOutlet weak var stageButton10: UIButton!
	@IBAction func stageButtonAction(_ sender: UIButton) {
		
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		let tag = sender.tag + self.startIndex
		if let bt = self.stageSelectedButton, sender == bt {
			//選択中点滅タイマー
			let mask = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
			self.view.addSubview(mask)
			mask.backgroundColor = UIColor.clear
			mask.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2)
			self.selectTimer?.invalidate()
			self.selectTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { [weak self](t) in
				if self!.gotoGameFlashCount % 2 == 0 {
					self?.stageSelectedButton?.setBackgroundImage(UIImage(named: "select_box_c"), for: .selected)
				} else {
					self?.stageSelectedButton?.setBackgroundImage(UIImage(named: "select_box_a"), for: .selected)
				}
				self!.gotoGameFlashCount += 1
				if self!.gotoGameFlashCount >= 8 {
					self!.gotoGameFlashCount = 0
					self!.selectTimer?.invalidate()
					//選択中、問題へ
					if self!.questDatas.count > tag {
						let questData: QuestData = self!.questData(at: tag)!
						let gameView = GameViewController.gameViewController(questData: questData)
						gameView.questIndex = tag
						gameView.selectCnt = self
						gameView.present(self!) { 
							let index = bt.tag + self!.startIndex
							self!.selectStage(index: index)
							mask.removeFromSuperview()
						}
						gameView.baseDelegate = self!
					}
				}
			})
		} else {
			//選択する
			self.stageSelectedButton?.isSelected = false
			if let bt = self.stageSelectedButton {
				let stageNum = "\(NSString(format: "%02d", self.startIndex + bt.tag + 1))"
				let image = UIImage(named: "select_\(stageNum)")
				bt.setImage(image, for: .normal)
			}
			self.stageSelectedButton = sender
			self.stageSelectedButton?.isSelected = true
			self.selectStage(index: tag)
		}
	}
	
	func selectStage(index: Int) {
		
		if self.questDatas.count <= index {
			return
		}
		
		var btIndex: Int
		if index < 10 {
			btIndex = index
		} else {
			btIndex = index % 10
		}
		let bt = stageButtons[btIndex]
		self.stageSelectedButton?.isSelected = false
		self.stageSelectedButton = bt
		self.stageSelectedButton?.isSelected = true
		
		let page = (index / 10) + 1
		self.currentPage = page
		
		UserDefaults.standard.set(index, forKey: kCurrentQuestIndex)
		//ステージ有効フラグ
		let stageEnableAry = UserDefaults.standard.object(forKey: kEnableStageArry) as! [Bool]
		let stageEnabled = stageEnableAry[index] 
		
		let questData: QuestData = self.questDatas[index]
		if stageEnabled {
			//問題名
			let title = questData.questName
			let stageNum = "stage\(NSString(format: "%02d", index + 1))" 
			self.stageTitleLabel.text = "\(stageNum) \(title)"
		} else {
			self.stageTitleLabel.text = nil
		}
		//時間
		let time = questData.time
		if time == 0 {
			self.timeLimitLabel?.text = "無制限"
		} else {
			let m = Int(time / 60)
			let s = Int(time) % 60
			self.timeLimitLabel?.text = "\(NSString(format: "%02d", m)) : \(NSString(format: "%02d", s))"
		}
		if stageEnabled {
			//アイコン
			self.stageSelectedButton?.setImage(nil, for: .normal)
			//サムネイル
			self.stageSumbImageView.image = UIImage(named: "prev_\(NSString(format: "%02d", index + 1))")
			//選択中点滅タイマー
			self.selectTimer?.invalidate()
			self.selectTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self](t) in
				if self!.isSelOn {
					self?.stageSelectedButton?.setBackgroundImage(UIImage(named: "select_box_a"), for: .selected)
				} else {
					self?.stageSelectedButton?.setBackgroundImage(UIImage(named: "select_box_b"), for: .selected)
				}
				self!.isSelOn = !self!.isSelOn
			})
		} else {
			//アイコン
			self.stageSelectedButton?.setImage(nil, for: .normal)
			//サムネイル
			self.stageSumbImageView.image = UIImage(named: "select_pleview_center_inactive")
		}
		//ターゲットスコア
		let strList = MPEDataManager.loadStringList(name: "mpe_ステージ別目標スコア", type: "csv")
		if let tgScore = Int(strList[index]) {
			self.targetScoreLabel.text = "\(tgScore)" 
		}
	}
	var isSelOn: Bool = false
	
	override func baseViewControllerBack(baseView: BaseViewController) -> Void {
		
		self.selectTimer?.invalidate()
		self.selectTimer = nil
		print("ゲームから戻る")
	}
	
}
