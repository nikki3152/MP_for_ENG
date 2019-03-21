//
//  QuickQuestViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class QuickQuestViewController: BaseViewController {
	
	
	deinit {
		print(">>>>>>>> deinit \(String(describing: type(of: self))) <<<<<<<<")
	}
	
	let dataMrg: MPEDataManager = MPEDataManager()
	var max: Int = 10
	var _count: Int = 0
	var count: Int {
		get {
			return _count
		}
		set {
			_count = newValue
			self.stateLabel.text = "\(_count)/\(max)"
		}
	}
	var mode: Int = 0
	var quest: String = ""
	var answer1: String = ""
	var answer2: String = ""
	var answer3: String = ""
	var answer4: String = ""
	var correct: Int = 1
	var correctWord: String = ""
	var resultList: [[String:Any]] = []
	var time: Double = 0
	var timer: Timer!
	
	class func quickQuestViewController() -> QuickQuestViewController {
		
		let storyboard = UIStoryboard(name: "QuickQuestViewController", bundle: nil)
		let baseCnt = storyboard.instantiateViewController(withIdentifier: "QuickQuestView") as! QuickQuestViewController
		return baseCnt
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setQuest()
		SoundManager.shared.startBGM(type: .bgmOneQuest)		//BGM再生
		self.answerButton1.isExclusiveTouch = true
		self.answerButton2.isExclusiveTouch = true
		self.answerButton3.isExclusiveTouch = true
		self.answerButton4.isExclusiveTouch = true
		self.backButton.isExclusiveTouch = true
		
		self.backButton.isExclusiveTouch = true
		for v in self.buttonBaseView.subviews {
			if let bt = v as? UIButton {
				bt.isExclusiveTouch = true
			}
		}
	}
	
	//データ集計
	func recTime() {
		
		var corrects: Int = 0
		var totalTime: Double = 0
		for dic in resultList {
			if let time = dic["time"] as? Double {
				totalTime += time
			}
			if let correct = dic["correct"] as? Bool {
				if correct {
					corrects += 1
				}
			}
			
		}
		if mode == 1 {
			//時間
			let t = UserDefaults.standard.double(forKey: kQuickBiginnerTimes)
			UserDefaults.standard.set(t + totalTime, forKey: kQuickBiginnerTimes)
			//問題数
			let c = UserDefaults.standard.integer(forKey: kQuickBiginnerCount)
			UserDefaults.standard.set(c + resultList.count, forKey: kQuickBiginnerCount)
			//正解数
			let s = UserDefaults.standard.integer(forKey: kQuickBiginnerCorrectCount)
			UserDefaults.standard.set(s + corrects, forKey: kQuickBiginnerCorrectCount)
		}
		else if mode == 2 {
			//時間
			let t = UserDefaults.standard.double(forKey: kQuickIntermediateTimes)
			UserDefaults.standard.set(t + totalTime, forKey: kQuickIntermediateTimes)
			//問題数
			let c = UserDefaults.standard.integer(forKey: kQuickIntermediateCount)
			UserDefaults.standard.set(c + resultList.count, forKey: kQuickIntermediateCount)
			//正解数
			let s = UserDefaults.standard.integer(forKey: kQuickIntermediateCorrectCount)
			UserDefaults.standard.set(s + corrects, forKey: kQuickIntermediateCorrectCount)
		}
		else if mode == 3 {
			//時間
			let t = UserDefaults.standard.double(forKey: kQuickAdvancedTimes)
			UserDefaults.standard.set(t + totalTime, forKey: kQuickAdvancedTimes)
			//問題数
			let c = UserDefaults.standard.integer(forKey: kQuickAdvancedCount)
			UserDefaults.standard.set(c + resultList.count, forKey: kQuickAdvancedCount)
			//正解数
			let s = UserDefaults.standard.integer(forKey: kQuickAdvancedCorrectCount)
			UserDefaults.standard.set(s + corrects, forKey: kQuickAdvancedCorrectCount)
		}
		else if mode == 4 {
			//時間
			let t = UserDefaults.standard.double(forKey: kQuickGodTimes)
			UserDefaults.standard.set(t + totalTime, forKey: kQuickGodTimes)
			//問題数
			let c = UserDefaults.standard.integer(forKey: kQuickGodCount)
			UserDefaults.standard.set(c + resultList.count, forKey: kQuickGodCount)
			//正解数
			let s = UserDefaults.standard.integer(forKey: kQuickGodCorrectCount)
			UserDefaults.standard.set(s + corrects, forKey: kQuickGodCorrectCount)
		}
		else if mode == 5 {
			//時間
			let t = UserDefaults.standard.double(forKey: kQuickRandomTimes)
			UserDefaults.standard.set(t + totalTime, forKey: kQuickRandomTimes)
			//問題数
			let c = UserDefaults.standard.integer(forKey: kQuickRandomCount)
			UserDefaults.standard.set(c + resultList.count, forKey: kQuickRandomCount)
			//正解数
			let s = UserDefaults.standard.integer(forKey: kQuickRandomCorrectCount)
			UserDefaults.standard.set(s + corrects, forKey: kQuickRandomCorrectCount)
		}
		
	}
	
	//戻る
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		
		self.timer?.invalidate()
		self.timer = nil
		
		self.recTime()
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		self.remove()
		SoundManager.shared.startBGM(type: .bgmWait)		//BGM再生
	}
	//MARK: 問題設定
	func setQuest() {
		
		var name = ""
		if mode == 1 {
			name = "quiz_bigginer"
		}
		else if mode == 2 {
			name = "quiz_intermediate"
		}
		else if mode == 3 {
			name = "quiz_advanced"
		}
		else if mode == 4 {
			name = "quiz_god"
		}
		else if mode == 5 {
			name = "quiz_random"
		}
		var answers: [String] = []
		let wordList = dataMrg.loadQuickQuest(name: name)
		for _ in 0 ..< 4 {
			let index = Int.random(in: 0 ..< wordList.count)
			let word = wordList[index]
			answers.append(word)
		}
		
		self.correct = Int.random(in: 1 ... 4)
		correctWord = answers[self.correct - 1]
		let listH = dataMrg.search(word: correctWord.lowercased(), match: .perfect)
		if listH.count == 0 {
			self.setQuest()
			return
		}
		let dic = listH[0]
		let info = dic[correctWord]!
		self.quest = info[0]
		print("\([correct])\(correctWord):\(self.quest)")
		
		self.answer1 = answers[0]
		self.answer2 = answers[1]
		self.answer3 = answers[2]
		self.answer4 = answers[3]
		
		questLabel.text = quest
		answerButton1.setTitle(answer1, for: .normal)
		answerButton2.setTitle(answer2, for: .normal)
		answerButton3.setTitle(answer3, for: .normal)
		answerButton4.setTitle(answer4, for: .normal)
		
		answerButton1.isEnabled = true
		answerButton2.isEnabled = true
		answerButton3.isEnabled = true
		answerButton4.isEnabled = true
		
		self.count += 1
		
		self.time = 0.0
		self.timer?.invalidate()
		self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self](t) in
			self?.time += 0.01
		})

	}
	
	@IBOutlet weak var buttonBaseView: UIView!
	@IBOutlet weak var stateLabel: UILabel!
	@IBOutlet weak var questLabel: UILabel!
	@IBOutlet weak var answerButton1: UIButton!
	@IBOutlet weak var answerButton2: UIButton!
	@IBOutlet weak var answerButton3: UIButton!
	@IBOutlet weak var answerButton4: UIButton!
	@IBAction func answerButtonAction(_ sender: UIButton) {
		
		self.timer?.invalidate()
		self.timer = nil

		let tag = sender.tag
		var isCorrect: Bool
		if tag == correct {
			//正解
			sender.isEnabled = false
			print("正解")
			SoundManager.shared.startSE(type: .seCorrect)	//SE再生
			isCorrect = true
		} else {
			//不正解
			if let bt = self.buttonBaseView.viewWithTag(correct) as? UIButton {
				bt.isEnabled = false
			}
			print("不正解")
			SoundManager.shared.startSE(type: .seFail)		//SE再生
			isCorrect = false
		}
		let dic: [String : Any] = ["word":correctWord, "time":self.time, "info":quest, "correct":isCorrect]
		self.resultList.append(dic)
		self.openResult(correct: isCorrect)
	}
	
	//MARK: 結果表示
	func openResult(correct: Bool) {
		
		//正解／不正解
		var image: UIImage!
		if correct {
			image = UIImage(named: "quiz_correct.png") 
		} else {
			image = UIImage(named: "quiz_incorrect.png") 
		}
		let resView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
		resView.image = image
		self.view.addSubview(resView)
		resView.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2)
		resView.contentMode = .scaleAspectFit
		resView.isUserInteractionEnabled = true
		
		UIView.animate(withDuration: 0.25, delay: 2.0, options: .curveEaseIn, animations: { 
			resView.alpha = 0
		}) { [weak self](stop) in
			guard let s = self else {
				return
			}
			resView.removeFromSuperview()
			if s.max == s.count {
				s.openLastResult()
			} else {
				s.setQuest()
			}
		}
	}
	//MARK: 最終結果表示
	func openLastResult() {
		
		self.timer?.invalidate()
		self.timer = nil
		
		self.recTime()
		
		let result = QuickQuestResultViewController.quickQuestResultViewController()
		result.list = resultList
		result.present(self) { 
			
		}
		result.handler = {[weak self]() in
			self?.remove()
			SoundManager.shared.startBGM(type: .bgmWait)		//BGM再生
		}
	}
	
}
