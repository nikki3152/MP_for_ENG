//
//  StageSelectViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class StageSelectViewController: BaseViewController {

	@IBOutlet weak var leftChaImageView: UIImageView!
	@IBOutlet weak var rightChaImageView: UIImageView!
	
	
	let dataMrg: MPEDataManager = MPEDataManager()
	var questNames: [String] = []
	var questDatas: [QuestData] = []
	var startIndex: Int = 0
	var _currentPage: Int = 1
	var currentPage: Int {
		get {
			return _currentPage
		}
		set {
			_currentPage = newValue
			self.startIndex = (_currentPage - 1) * 10
			for i in 0 ..< self.stageButtons.count {
				let bt = self.stageButtons[i]
				bt.setTitle("\(self.startIndex + i + 1)", for: .normal)
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
		}
	}
	var maxPage: Int = 0
	
	
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
		let list = easy + normal + hard + god
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
		self.maxPage = 8//(self.questDatas.count / 10) + (self.questDatas.count % 10)
		self.currentPage = 1
    }
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		DataManager.animationFuwa(v: leftChaImageView, dy: 10, speed: 2.0)
		DataManager.animationFuwa(v: rightChaImageView, dy: 10, speed: 3.3)
		
		DataManager.animationFuwa(v: leftImageView, dx: 10, speed: 2.2)
		DataManager.animationFuwa(v: rightImageView, dx: 10, speed: 2.0)
	}
	
	//戻る
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		self.remove()
	}
	
	//左ボタン
	@IBOutlet weak var leftImageView: UIImageView!
	@IBOutlet weak var leftButton: UIButton!
	@IBAction func leftButtonAction(_ sender: UIButton) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		sender.isUserInteractionEnabled = false
		let x = self.buttonBaseView.center.x
		UIView.animate(withDuration: 0.25, animations: { 
			self.buttonBaseView.center = CGPoint(x: x + (self.buttonBaseView.frame.size.width/2), y: self.buttonBaseView.center.y)
			self.buttonBaseView.alpha = 0
		}) { (stop) in
			
			self.currentPage -= 1
			
			self.buttonBaseView.center = CGPoint(x: -(self.buttonBaseView.frame.size.width/2), y: self.buttonBaseView.center.y)
			UIView.animate(withDuration: 0.25, animations: { 
				self.buttonBaseView.center = CGPoint(x: x, y: self.buttonBaseView.center.y)
				self.buttonBaseView.alpha = 1
			}) { (stop) in
				sender.isUserInteractionEnabled = true
			}
		}
	}
	//右ボタン
	@IBOutlet weak var rightImageView: UIImageView!
	@IBOutlet weak var rightButton: UIButton!
	@IBAction func rightButtonAction(_ sender: UIButton) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		sender.isUserInteractionEnabled = false
		let x = self.buttonBaseView.center.x
		UIView.animate(withDuration: 0.25, animations: { 
			self.buttonBaseView.center = CGPoint(x: -(self.buttonBaseView.frame.size.width/2), y: self.buttonBaseView.center.y)
			self.buttonBaseView.alpha = 0
		}) { (stop) in
			
			self.currentPage += 1
			
			self.buttonBaseView.center = CGPoint(x: x + (self.buttonBaseView.frame.size.width/2), y: self.buttonBaseView.center.y)
			UIView.animate(withDuration: 0.25, animations: { 
				self.buttonBaseView.center = CGPoint(x: x, y: self.buttonBaseView.center.y)
				self.buttonBaseView.alpha = 1
			}) { (stop) in
				sender.isUserInteractionEnabled = true
			}
		}
	}
	
	
	@IBOutlet weak var buttonBaseView: UIView!
	
	//ステージ
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
		let questData: QuestData = self.questDatas[tag]
		let gameView = GameViewController.gameViewController(questData: questData)
		gameView.questIndex = tag
		gameView.selectCnt = self
		gameView.present(self) { 
		}
		gameView.baseDelegate = self
	}
	
	override func baseViewControllerBack(baseView: BaseViewController) -> Void {
		
		print("ゲームから戻る")
	}
	
}
