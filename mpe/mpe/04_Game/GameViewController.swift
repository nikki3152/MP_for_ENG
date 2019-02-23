//
//  GameViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

enum ObjDirection: Int {
	case up				= 0
	case upRight		= 1
	case right			= 2
	case downRight		= 3
	case down			= 4
	case downLeft		= 5
	case left			= 6
	case upLeft			= 7
}

enum QuestType: Int {
	case makeWords				= 0 		//英単語を◯個作る
	case fillAllCell			= 1 		//全てのマスを埋める
	case useAllFont				= 2 		//すべてのアルファベットを使う
	case makeWoredsCount		= 3 		//◯字数以上の英単語を◯個作る
	case hiScore				= 4 		//スコアを○点以上
	case useFontMakeCount		= 5 		//◯がつく英単語を○個作る
	func info(count: Int, words: Int, font: String) -> String {
		switch self {
		case .makeWords:
			return "英単語を\(count)個作れ!"
		case .fillAllCell:
			return "全てのマスを埋めろ！"
		case .useAllFont:
			return "すべてのアルファベットを使え！"
		case .makeWoredsCount:
			return "\(words)字数以上の英単語を\(count)個作る"
		case .hiScore:
			return "スコアを\(count)点以上"
		case .useFontMakeCount:
			return "\(font)がつく英単語を\(count)個作れ！"
		}
	}
}

struct QuestData {
	var filename: String = ""
	var questName: String = ""
	var time: Double = 0
	var questType: QuestType = .makeWords
	var questData: [String:Any] = ["count":1]
	var width: Int = 8
	var height: Int = 8
	var messages: [String] = ["もじぴったん"]
	var table: [String] = [
		"0","0","0","0","0","0","0","0",
		"0","0","0","0","0","0","0","0",
		"0","0","0","0","0","0","0","0",
		"0","0","0","0","0","0","0","0",
		"0","0","0","0","0","0","0","0",
		"0","0","0","0","0","0","0","0",
		"0","0","0","0","0","0","0","0",
		"0","0","0","0","0","0","0","0",]
	//DL: マス目の上に置かれたコマの点数が２倍になります。
	//TL: マス目の上に置かれたコマの点数が３倍になります。
	//DW: マス目にかかる単語全体の点数が２倍になります。
	//TW: マス目にかかる単語全体の点数が３倍になります。
	var tableType: [String] = [
		" "," "," "," "," "," "," "," ",
		" "," "," "," "," "," "," "," ",
		" "," "," "," "," "," "," "," ",
		" "," "," "," "," "," "," "," ",
		" "," "," "," "," "," "," "," ",
		" "," "," "," "," "," "," "," ",
		" "," "," "," "," "," "," "," ",
		" "," "," "," "," "," "," "," ",]
	var cards: [String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
	var wildCardLen: Int = 0
	
	//巻き戻し記録用
	var score: Int = 0		//スコア
	var count: Int = 0		//クリア条件カウント
	var answerWords: [String:String] = [:]
	
	init() {
		
	}
	init(dict: [String:Any]) {
		self.width = dict["width"] as! Int
		self.height = dict["height"] as! Int
		self.table = dict["table"] as! [String]
		if let msgs = dict["messages"] as? [String] {
			self.messages = msgs
		}
		if let type = dict["tableType"] as? [String] {
			self.tableType = type
		} else {
			self.tableType = []
			for _ in 0 ..<  table.count {
				self.tableType.append(" ")
			}
		}
		if let type = dict["questType"] as? Int {
			self.questType = QuestType(rawValue: type)!
		}
		if let data = dict["questData"] as? [String:Any] {
			self.questData = data
		}
		if let name = dict["questName"] as? String {
			self.questName = name
		}
		if let time = dict["time"] as? Double {
			self.time = time
		}
		self.cards = dict["cards"] as! [String]
		if let wildCardLen = dict["wildCardLen"] as? Int {
			self.wildCardLen = wildCardLen
		}
	}
	init(w: Int, h: Int, table: [String], cards: [String], tableType: [String]?, questType: QuestType, questData: [String:Any]?) {
		self.width = w
		self.height = h
		self.table = table
		self.cards = cards
		if let types = tableType {
			self.tableType = types
		} else {
			self.tableType = []
			for _ in 0 ..<  table.count {
				self.tableType.append(" ")
			}
		}
		self.questType = questType
		if let data = questData {
			self.questData = data
		}
	}
	func dict() -> [String:Any] {
		
		let dict: [String:Any] = [
			"width":self.width,
			"height":self.height,
			"table":self.table,
			"tableType":self.tableType,
			"cards":self.cards,
			"questType":self.questType.rawValue,
			"questData":self.questData,
			"questName":self.questName,
			"wildCardLen":self.wildCardLen,
			"time":self.time,
			"messages":self.messages,
		]
		return dict
	}
}

struct TableInfo {
	var index: Int		//テーブルのインデックス
	var moji: String	//文字
	var type: String	//得点タイプ
	init(index: Int, moji: String, type: String) {
		self.index = index
		self.moji = moji
		self.type = type
	}
}


//MARK: -
class GameViewController: BaseViewController, UIScrollViewDelegate, GameTableViewDelegate, FontCardViewDelegate {
	
	weak var selectCnt: StageSelectViewController!
	
	var _isInEffect = false
	var isInEffect: Bool {
		get {
			return _isInEffect
		}
		set {
			_isInEffect = newValue
			//self.view.isUserInteractionEnabled = !_isInEffect
		}
	}
	
	var questIndex: Int = 0
	let dataMrg = MPEDataManager()
	var questData: QuestData!
	//var questDataDef: QuestData!
	var questDataBKList: [QuestData] = []
	var questDataBKIndex: Int = 0
	var cardSelectIndex: Int!
	var answerWords: [String:String] = [:]
	var _questCount: Int = 2
	var questCount: Int {
		get {
			return _questCount
		}
		set {
			_questCount = newValue
			if _questCount < 0 {
				_questCount = 0
			}
			self.questSubLabel?.removeFromSuperview()
			var unit: String = ""
			if self.questData.questType == .fillAllCell {
				unit = "マス"
			}
			else if self.questData.questType == .hiScore {
				unit = "点"
			}
			else {
				unit = "個"
			}
			let qTextSub = "残り\(_questCount)\(unit)"
			let qSubLabel = makeVerticalLabel(size: self.questDisplayImageView.frame.size, font: UIFont.boldSystemFont(ofSize: 16), text: qTextSub)
			qSubLabel.textAlignment = .left
			qSubLabel.numberOfLines = 1
			self.questDisplay2ImageView.addSubview(qSubLabel)
			qSubLabel.center = CGPoint(x: self.questDisplayImageView.frame.size.width / 2, y: self.questDisplayImageView.frame.size.height / 2)
			self.questSubLabel = qSubLabel
			
		}
	}
	
	class func gameViewController(questData: QuestData) -> GameViewController {
		
		let storyboard = UIStoryboard(name: "GameViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! GameViewController
		baseCnt.questData = questData 
		return baseCnt
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.scoreLabel.outlineColor = UIColor.black
		self.scoreLabel.outlineWidth = 5
		
		self.nowScoreLabel.outlineColor = UIColor.black
		self.nowScoreLabel.outlineWidth = 5
		self.nowScore = 0
		
		self.timeLabel.outlineColor = UIColor.black
		self.timeLabel.outlineWidth = 5
		
		self.ballonImageView.alpha = 0
		self.ballonDisplayImageView.alpha = 0
		
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
		
		if self.gameTable == nil {
			
			if UIDevice.current.userInterfaceIdiom == .phone {
				let size = UIScreen.main.bounds
				if size.width >= 812 {
					self.cardBaseView.center = CGPoint(x: self.cardBaseView.center.x, y: self.cardBaseView.center.y - 22)
				}
			}
			
			self.startGameTimer()

		}
	}
	
	//背景
	@IBOutlet weak var backImageView: UIImageView!
	
	//問題文
	@IBOutlet weak var questBaseView: UIView!
	@IBOutlet weak var questBaseImageView: UIImageView!
	@IBOutlet weak var questDisplayImageView: UIImageView!
	@IBOutlet weak var questDisplay2ImageView: UIImageView!
	var questMainLabel: TTTAttributedLabel!
	var questSubLabel: TTTAttributedLabel!
	
	//テーブル
	var gameTable: GameTableView!
	@IBOutlet weak var mainScrollView: UIScrollView!
	var checkKomaSet: Set<TableKomaView> = []	//テーブルのビューを保存する
	//var checkTableInfo: [TableInfo] = []		//文字とインデックスを保存する
	var checkTableInfoH: [TableInfo] = []		//横方向の文字とインデックスを保存する
	var checkTableInfoV: [TableInfo] = []		//縦方向の文字とインデックスを保存する

	
	//手札
	var cardViewList: [FontCardView] = []
	@IBOutlet weak var cardScrolliew: UIScrollView!
	@IBOutlet weak var cardBaseView: UIView!
	
	//MARK: 手札左
	@IBOutlet weak var cardLeftButton: UIButton!
	@IBAction func cardLeftButtonAction(_ sender: UIButton) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
	}
	//MARK: 手札右
	@IBOutlet weak var cardRightButton: UIButton!
	@IBAction func cardRightButtonAction(_ sender: UIButton) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
	}
	
	//キャラクター
	@IBOutlet weak var charaBaseView: UIView!
	@IBOutlet weak var charaImageView: UIImageView!
	@IBOutlet weak var ballonImageView: UIImageView!
	@IBOutlet weak var ballonDisplayImageView: UIImageView!
	var ballonMainLabel: TTTAttributedLabel!
	var customChara: CustomChara = .mojikun_b
	var chaDefTimer: Timer!
	
	//トータルスコア
	@IBOutlet weak var scoreBaseView: UIView!
	@IBOutlet weak var scoreLabel: OutlineLabel!
	var _totalScore: Int = 0
	var totalScore: Int {
		get {
			return _totalScore
		}
		set {
			_totalScore = newValue
			self.scoreLabel.text = NSString(format: "%05d", _totalScore) as String
		}
	}
	//スコア
	@IBOutlet weak var nowScoreBaseView: UIView!
	@IBOutlet weak var nowScoreLabel: OutlineLabel!
	var _nowScore: Int = 0
	var nowScore: Int {
		get {
			return _nowScore
		}
		set {
			_nowScore = newValue
			self.nowScoreLabel.text = NSString(format: "%d", _nowScore) as String
			if _nowScore == 0 {
				nowScoreLabel.isHidden = true
			} else {
				nowScoreLabel.isHidden = false
			}
		}
	}
	func setNowScore(score: Int, last: Bool) {
		
		self.nowScore = score
		if last {
			nowScoreLabel.textColor = UIColor(displayP3Red: 250/255, green: 194/255, blue: 27/255, alpha: 1.0)
		} else {
			nowScoreLabel.textColor = UIColor.white
		}
	}
	
	//タイム
	@IBOutlet weak var timeBaseView: UIView!
	@IBOutlet weak var timeBackImageView: UIImageView!
	@IBOutlet weak var timeLabel: OutlineLabel!
	var gameTimer: Timer!
	var _time: Double = 99
	var time: Double {
		get {
			return _time
		}
		set {
			_time = newValue
			if _time == 0 {
				self.timeBaseView.isHidden = true
			} else {
				self.timeBaseView.isHidden = false
			}
			let m = Int(_time / 60)
			let s = Int(_time) % 60
			self.timeLabel?.text = "\(NSString(format: "%02d", m)) : \(NSString(format: "%02d", s))"
			//self.timeLabel.text = "\(Int(_time))"
		}
	}
	
	//コンボ
	@IBOutlet weak var chainImageView: UIImageView!
	func makeChainAnimation(num: Int) {
		
		print("コンボ: \(num)")
		if num >= 2 && num <= 9 {
			chainImageView.image = UIImage(named: "chain\(num)")
			chainImageView.alpha = 1
			let imgView = chainImageView
			UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [], animations: { 
				UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.15, animations: { 
					imgView!.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
				})
				UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.15, animations: { 
					imgView!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
				})
			}) {(stop) in
				imgView!.image = UIImage(named: "chain\(num)_anim")
				UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveLinear, animations: { 
					imgView!.alpha = 0
				}, completion: { (stop) in
				})
			}
		}
		else if num >= 10 {
			chainImageView.image = UIImage(named: "chainmax")
			chainImageView.alpha = 1
			let imgView = chainImageView
			UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [], animations: { 
				UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.15, animations: { 
					imgView!.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
				})
				UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.15, animations: { 
					imgView!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
				})
			}) {(stop) in
				UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveLinear, animations: { 
					imgView!.alpha = 0
				}, completion: { (stop) in
				})
			}
		}
	}
	
	
	
	//MARK: タイマースタート
	func startGameTimer() {
		
		self.answerWords = [:]
		self.totalScore = 0
		self.nowScore = 0
		
		self.isEnablePause = false
		self.isInEffect = false
		
		self.undoButton.isHidden = true
		//手札
		self.updateCardScroll()
		//ゲームテーブル
		self.updateGametable()
		//問題
		self.updateQuestString()
		//文字くんメッセージ
		//self.updateMojikunString()
		
		self.questData.score = self.totalScore
		self.questData.count = self.questCount
		self.questData.answerWords = self.answerWords
		self.questDataBKList.removeAll()
		self.questDataBKList.append(questData)
		self.questDataBKIndex = 0
		
		//BGM再生／背景変更
		if self.questIndex >= 0 && self.questIndex <= 19 {
			//初級
			SoundManager.shared.startBGM(type: .bgmEasy)		
			self.backImageView.image = UIImage(named: "stage_01")
		}
		else if self.questIndex >= 20 && self.questIndex <= 39 {
			//中級
			SoundManager.shared.startBGM(type: .bgmNormal)
			self.backImageView.image = UIImage(named: "stage_02")
		}
		else if self.questIndex >= 40 && self.questIndex <= 59 {
			//上級
			SoundManager.shared.startBGM(type: .bgmHard)
			self.backImageView.image = UIImage(named: "stage_03")
		}
		else if self.questIndex >= 60 && self.questIndex <= 79 {
			//神級
			SoundManager.shared.startBGM(type: .bgmGod)
			self.backImageView.image = UIImage(named: "stage_04")
		}
		else {
			SoundManager.shared.startBGM(type: .bgmEasy)		
			self.backImageView.image = UIImage(named: "stage_01")
		}
		
		self.time = self.questData.time
		
		//MARK: キャラクターアニメーション（通常）
		makeDefCharaAnimation()
		
		//雲アニメーション
		self.timeBackImageView.animationImages = [
			UIImage(named: "time_cloud_01")!,
			UIImage(named: "time_cloud_02")!,
		]
		self.timeBackImageView.animationDuration = 2.3
		self.timeBackImageView.startAnimating()
		
		let base = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
		self.view.addSubview(base)
		base.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
		base.backgroundColor = UIColor.clear
		// Ready!!
		let ready = UIImageView(frame: CGRect(x: 0, y: 0, width: 390, height: 118))
		ready.contentMode = .scaleAspectFit
		ready.image = UIImage(named: "Ready_")
		base.addSubview(ready)
		ready.center = CGPoint(x: base.frame.size.width/2, y: base.frame.size.height/2)
		
		UIView.animate(withDuration: 0.25, delay: 1.0, options: .curveEaseIn, animations: { 
			ready.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
			ready.alpha = 0
		}) { (stop) in
			ready.removeFromSuperview()
			// Go!!
			let go = UIImageView(frame: CGRect(x: 0, y: 0, width: 257, height: 100))
			go.contentMode = .scaleAspectFit
			go.image = UIImage(named: "GO!!")
			base.addSubview(go)
			go.center = CGPoint(x: base.frame.size.width/2, y: base.frame.size.height/2)
			UIView.animate(withDuration: 0.25, delay: 0.5, options: .curveEaseIn, animations: { 
				go.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
				go.alpha = 0
			}) { [weak self](stop) in
				base.removeFromSuperview()
				DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {[weak self]() -> Void in
					self?.isEnablePause = true
				})
				self?.gameTimer?.invalidate()
				if self!.time > 0 {
					self?.gameTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self](t) in
						guard let s = self else {
							return
						}
						if s.isInEditMode == false {
							if s.isGamePause == false {
								s.time -= 0.1
								if s.time <= 0 {
									s.gameOver()
								}
							}
						}
					})
				} else {
					self?.gameTimer = nil
				}
			}
		}
		
		makeBackAnimation()
	}
	
	
	//MARK: やりなおし
	func retry() {
		
		self.startGameTimer()
		
	}
	//MARK: 次の問題
	func nextQuest() {
		
		if self.selectCnt.questDatas.count - 1 > self.questIndex {
			self.questIndex += 1
			self.questData = self.selectCnt.questDatas[self.questIndex]
			self.retry()
		} else {
			self.remove()
			SoundManager.shared.startBGM(type: .bgmWait)		//BGM再生
		}
	}
	
	var isEnablePause: Bool = false
	
	//MARK: ゲームポーズ
	@IBOutlet weak var pauseButton: UIButton!
	@IBAction func pauseButtonAction(_ sender: Any) {
		if isEnablePause == false || self.isInEffect {
			return
		}
		SoundManager.shared.startSE(type: .sePause)	//SE再生
		self.gamePause()
	}
	
	//MARK: アンドゥ
	@IBOutlet weak var undoButton: UIButton!
	@IBAction func undoButtonAction(_ sender: Any) {
		if isEnablePause == false || self.isInEffect {
			return
		}
		if questDataBKList.count > 1 {
			SoundManager.shared.startSE(type: .seSelect)	//SE再生
			self.questDataBKIndex -= 1
			self.questData = self.questDataBKList[self.questDataBKIndex]
			self.questDataBKList.removeLast()
			//手札
			self.updateCardScroll()
			//ゲームテーブル
			self.updateGametable()
			//問題
			self.updateQuestString()
			//文字くんメッセージ
			//self.updateMojikunString()
			
			self.totalScore = questData.score
			self.questCount = questData.count
			self.answerWords = self.questData.answerWords
			
			if questDataBKList.count > 1 {
				self.undoButton.isHidden = false
			} else {
				self.undoButton.isHidden = true
			}
		} else {
			
		}
	}
	
	
	private func updateScrollInset() {
		
	}
	//MARK: 手札作成
	func updateCardScroll() {
		
		for v in self.cardScrolliew.subviews {
			v.removeFromSuperview()
		}
		
		var imageName = "orange_0"
		if self.questIndex >= 0 && self.questIndex <= 19 {
			imageName = "orange_0"
			self.cardRightButton.setBackgroundImage(UIImage(named: "orange_right"), for: .normal)
			self.cardLeftButton.setBackgroundImage(UIImage(named: "orange_left"), for: .normal)
		} else {
			imageName = "blue_0"
			self.cardRightButton.setBackgroundImage(UIImage(named: "blue_right"), for: .normal)
			self.cardLeftButton.setBackgroundImage(UIImage(named: "blue_left"), for: .normal)
		}
		
		self.cardViewList = []
		for i in 0 ..< self.questData.cards.count {
			let moji = self.questData.cards[i]
			let cardView = FontCardView.fontCardView(moji: moji)
			cardView.delegate = self
			cardView.tag = i
			self.cardScrolliew.addSubview(cardView)
			cardView.center = CGPoint(x: (cardView.frame.size.width / 2) + (CGFloat(i) * cardView.frame.size.width), y: self.cardScrolliew.frame.size.height / 2)
			if self.questData.wildCardLen > i {
				cardView.isWildCard = true
			} else {
				cardView.backImageView.image = UIImage(named: imageName)
			}
			self.cardViewList.append(cardView)
		}
		self.cardScrolliew.contentSize = CGSize(width: CGFloat(self.questData.cards.count) * 50, height: self.cardScrolliew.frame.size.height / 2)
		
	}
	//MARK: ゲームメインテーブルさ作成
	func updateGametable() {
		
		//ゲームテーブル
		for v in self.mainScrollView.subviews {
			v.removeFromSuperview()
		}
		self.gameTable?.removeFromSuperview()
		self.gameTable = GameTableView.gameTableView(size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height), 
													 width: self.questData.width, 
													 height: self.questData.height,
													 cellTypes: self.questData.table,
													 types: self.questData.tableType,
													 edit: false)
		let size = self.gameTable.frame.size
		self.gameTable.delegate = self
		self.mainScrollView.addSubview(self.gameTable)
		self.mainScrollView.contentSize = CGSize(width: self.gameTable.frame.size.width, height: self.gameTable.frame.size.height)
		self.mainScrollView.maximumZoomScale = 2.0
		self.mainScrollView.minimumZoomScale = 1.0
		self.mainScrollView.zoomScale = 1.0
		self.mainScrollView.contentOffset = CGPoint(x: size.width / 4, y: size.height / 4)
		self.view.sendSubview(toBack: self.mainScrollView)
		self.view.sendSubview(toBack: self.backImageView)
	}
	//クエスト文字作成
	func updateQuestString() {
		
		self.questMainLabel?.removeFromSuperview()
		
		var count: Int = 0
		if self.questData.questType == .fillAllCell {
			for koma in self.gameTable.komas {
				if koma.moji == "0" {
					count += 1
				}
			}
		} else {
			if let v = self.questData.questData["count"] as? Int {
				count = v
			}
		}
		
		var words: Int = 0
		if let v = self.questData.questData["words"] as? Int {
			words = v
		}
		
		var font: String = ""
		if let v = self.questData.questData["font"] as? String {
			font = v
		}
		let qText = self.questData.questType.info(count: count, words: words, font: font)
		let qLabel = makeVerticalLabel(size: self.questDisplayImageView.frame.size, font: UIFont.boldSystemFont(ofSize: 16), text: qText)
		qLabel.textAlignment = .left
		qLabel.numberOfLines = 2
		self.questDisplayImageView.addSubview(qLabel)
		qLabel.center = CGPoint(x: self.questDisplayImageView.frame.size.width / 2, y: self.questDisplayImageView.frame.size.height / 2)
		self.questMainLabel = qLabel
		
		self.questCount = count
		
	}
	//MARK: もじくんセリフ作成
	func updateMojikunString() {
		
		self.ballonMainLabel?.removeFromSuperview()
		var bText: String
		if self.questData.questName == "" {
			if self.questData.messages.count > 0 {
				bText = self.questData.messages[0]
			} else {
				bText = ""
			}
		} else {
			bText = self.questData.questName 
		}
		let bLabel = makeVerticalLabel(size: self.ballonDisplayImageView.frame.size, font: UIFont.boldSystemFont(ofSize: 14), text: bText)
		bLabel.textAlignment = .center
		bLabel.numberOfLines = 2
		self.ballonDisplayImageView.addSubview(bLabel)
		bLabel.center = CGPoint(x: self.ballonDisplayImageView.frame.size.width / 2, y: self.ballonDisplayImageView.frame.size.height / 2)
		self.ballonMainLabel = bLabel
		
		self.ballonImageView.alpha = 1
		self.ballonDisplayImageView.alpha = 1
		UIView.animate(withDuration: 0.25, delay: 2.0, options: .curveLinear, animations: { 
			self.ballonImageView.alpha = 0
			self.ballonDisplayImageView.alpha = 0
		}) { (stop) in
			
		}
	}
	
	
	//MARK: 横方向の単語検索
	func checkWordH(startIndex: Int) -> String {
		
		var ward: String = ""
		let moji = self.questData.table[startIndex]
		if moji != "" && moji != " " && moji != "0" {
			let x = startIndex % self.questData.width
			let y = startIndex / self.questData.width
			var startX: Int = x
			while startX != 0 {
				startX -= 1
				let idx = startX + (self.questData.width * y)
				let moji = self.questData.table[idx]
				if moji == "" || moji == " " || moji == "0" {
					startX += 1
					break
				}
			}
			
			while startX < self.questData.width {
				let idx = startX + (self.questData.width * y)
				let moji = self.questData.table[idx]
				if moji != "" && moji != " " && moji != "0" {
					ward.append(moji)
					self.checkKomaSet.insert(self.gameTable.komas[idx])
					
					//テーブル情報取得
					var infoAdd = true
					for info in self.checkTableInfoH {
						if info.index == idx {
							infoAdd = false
							break
						}
					}
					if infoAdd {
						let type = self.questData.tableType[idx]
						self.checkTableInfoH.append(TableInfo(index: idx, moji: moji, type: type)) 
					}
					
					startX += 1
				} else {
					break
				}
			}
		} 
		
		return ward
	}
	//MARK: 縦方向の単語検索
	func checkWordV(startIndex: Int) -> String {
		
		var ward: String = ""
		let moji = self.questData.table[startIndex]
		if moji != "" && moji != " " && moji != "0" {
			let x = startIndex % self.questData.width
			let y = startIndex / self.questData.width
			var startY: Int = y
			while startY != 0 {
				startY -= 1
				let idx = x + (self.questData.width * startY)
				let moji = self.questData.table[idx]
				if moji == "" || moji == " " || moji == "0" {
					startY += 1
					break
				}
			}
			
			while startY < self.questData.height {
				let idx = x + (self.questData.width * startY)
				let moji = self.questData.table[idx]
				if moji != "" && moji != " " && moji != "0" {
					ward.append(moji)
					self.checkKomaSet.insert(self.gameTable.komas[idx])
					
					//テーブル情報取得
					var infoAdd = true
					for info in self.checkTableInfoV {
						if info.index == idx {
							infoAdd = false
							break
						}
					}
					if infoAdd {
						let type = self.questData.tableType[idx]
						self.checkTableInfoV.append(TableInfo(index: idx, moji: moji, type: type)) 
					}
					
					startY += 1
				} else {
					break
				}
			}
		} 
		
		return ward
	}
	
	//テーブルタップエフェクト
	func tableTapEffect(komas: [TableKomaView]) {
		
		for koma in komas {
			if let superview = koma.superview {
				superview.bringSubview(toFront: koma)
			}
			
			let backImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: koma.frame.size.width, height: koma.frame.size.height))
			backImageView.image = UIImage(named: "orange_0")
			koma.addSubview(backImageView)
			//フォント
			let fontImageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: koma.frame.size.width, height: koma.frame.size.height))
			fontImageView.image = UIImage(named: "anim_\(koma.moji)")
			koma.addSubview(fontImageView)
			fontImageView.center = CGPoint(x: koma.frame.size.width / 2, y: koma.frame.size.height / 2)
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { 
				let effectImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
				koma.addSubview(effectImageView)
				effectImageView.center = CGPoint(x: koma.frame.size.width / 2, y: koma.frame.size.height / 2)
				effectImageView.animationImages = [
					UIImage(named: "cell_anime1")!,
					UIImage(named: "cell_anime2")!,
					UIImage(named: "cell_anime3")!,
					UIImage(named: "cell_anime4")!,
					UIImage(named: "cell_anime5")!,
					UIImage(named: "cell_anime6")!,
					UIImage(named: "cell_anime7")!,
					UIImage(named: "cell_anime8")!,
					UIImage(named: "cell_anime9")!,
					UIImage(named: "cell_anime10")!,
					UIImage(named: "cell_anime11")!,
					UIImage(named: "cell_anime12")!,
					UIImage(named: "cell_anime13")!,
					UIImage(named: "cell_anime14")!,
					UIImage(named: "cell_anime15")!,
				]
				
				effectImageView.animationDuration = 0.5
				effectImageView.animationRepeatCount = 1
				//数字を乗せて拡大縮小アニメーション
				UIView.animate(withDuration: 0.2, animations: { 
					fontImageView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
				}, completion: { (stop) in
					UIView.animate(withDuration: 0.25, animations: { 
						fontImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
					}, completion: { (stop) in
					})
				})
				effectImageView.startAnimating()
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { 
					fontImageView.removeFromSuperview()
					effectImageView.removeFromSuperview()
					backImageView.removeFromSuperview()
				}
			}
		}
	}
	
	//MARK: 編集（デバッグ）
	var isInEditMode = false
	@IBOutlet weak var editButton: UIButton!
	@IBAction func editButtonAction(_ sender: UIButton) {
		
		SoundManager.shared.pauseBGM(true)		//BGMポーズ（停止）
		self.isInEditMode = true
		let edit = EditViewController.editViewController(questData: self.questData)
		self.present(edit, animated: true) { 
			
		}
		edit.finishedHandler = {[weak self](data) in
			SoundManager.shared.pauseBGM(false)		//BGMポーズ（解除）
			self?.isInEditMode = false
			if let data = data {
				self?.questData = data
				//手札
				self?.updateCardScroll()
				//ゲームテーブル
				self?.updateGametable()
				//問題
				self?.updateQuestString()
				//文字くんメッセージ
				//self?.updateMojikunString()
			}
		}
	}
	
	
	func buildWord(moji: [TableInfo]) -> String {
		
		var word: String = ""
		for info in moji {
			word.append(info.moji)
		}
		return word.lowercased()
	}
	
	//MARK: - キャラクターアニメーション
	func makeDefCharaAnimation() {
		
		self.charaImageView.image = UIImage(named: "\(self.customChara.rawValue)_01") 
		if self.customChara == .mojikun_b {
			//もじくん（新）
			DataManager.animationFuwa(v: charaImageView, dy: 20, speed: 4)
		}
		else if self.customChara == .mojichan {
			//もじちゃん
			self.charaImageView.animationImages = [
				UIImage(named: "\(self.customChara.rawValue)_01_a")!,
				UIImage(named: "\(self.customChara.rawValue)_01_b")!,
				UIImage(named: "\(self.customChara.rawValue)_01_a")!,
				UIImage(named: "\(self.customChara.rawValue)_01_c")!,
			]
			self.charaImageView.animationDuration = 6.0
			self.charaImageView.startAnimating()
		}
		else if self.customChara == .taiyokun {
			//太陽
			charaImageView.image = UIImage(named: "taiyokun_01") 
			if let shipo = charaImageView.viewWithTag(100) as? UIImageView{
				shipo.removeFromSuperview()
			}
			let shipo = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
			shipo.tag = 100
			shipo.image = UIImage(named: "taiyokun_shippo_01")
			charaImageView.addSubview(shipo)
			DataManager.animationInfinityRotate(v: shipo, speed: 0.1)
			DataManager.animationFuwa(v: charaImageView, dy: 20, speed: 4)
		}
		else if self.customChara == .tsukikun {
			//月
			charaImageView.image = UIImage(named: "tsukikun_01")
			DataManager.animationFuwa(v: charaImageView, dy: 20, speed: 4)
		}
		else if self.customChara == .kumokun {
			//雲
			DataManager.animationFuwa(v: charaImageView, dy: 20, speed: 4)
		}
		else if self.customChara == .mojikun_a {
			//もじくん（旧）
			self.charaImageView.animationImages = [
				UIImage(named: "\(self.customChara.rawValue)_01")!,
				UIImage(named: "\(self.customChara.rawValue)_02")!,
			]
			self.charaImageView.animationDuration = 3.5
			self.charaImageView.startAnimating()
		}
		else if self.customChara == .pack {
			self.chaDefTimer?.invalidate()
			self.chaDefTimer = Timer.scheduledTimer(withTimeInterval: 4.5, repeats: true, block: { [weak self](t) in
				guard let s = self else {
					return
				}
				DataManager.animationJump(v: s.charaImageView, height: 15, speed: 0.5, isRepeat: false)
			})
		}
		else if self.customChara == .ouji {
			//王子
			self.charaImageView.animationImages = [
				UIImage(named: "\(self.customChara.rawValue)_01")!,
				UIImage(named: "\(self.customChara.rawValue)_02")!,
			]
			self.charaImageView.animationDuration = 7.0
			self.charaImageView.startAnimating()
		}
		else if self.customChara == .driller {
			//ドリラー
			self.charaImageView.animationImages = [
				UIImage(named: "\(self.customChara.rawValue)_01")!,
				UIImage(named: "\(self.customChara.rawValue)_02")!,
			]
			self.charaImageView.animationDuration = 7.0
			self.charaImageView.startAnimating()
		}
		else if self.customChara == .galaga {
			//ギャラガ
			let x = charaImageView.center.x
			let y = charaImageView.center.y
			let animation = CAKeyframeAnimation(keyPath: "position")
			animation.duration = 2.0
			animation.repeatCount = 100000
			animation.keyTimes = [0.0, 0.25, 0.5, 0.75, 0.8]
			animation.values = [
				CGPoint(x: x, y: y),
				CGPoint(x: x + 20, y: y),
				CGPoint(x: x + 20, y: y + 20),
				CGPoint(x: x, y: y + 20),
				CGPoint(x: x, y: y),
			]
			self.charaImageView.layer.add(animation, forKey: nil)
		}
	}
	func makeHitCharaAnimation() {
		
		if self.customChara == .mojikun_b || self.customChara == .mojikun_a {
			//もじくん（新／旧）
			//回転ジャンプ
			let height = 100.0
			let speed = 0.8
			let y = self.charaImageView.center.y
			UIView.animateKeyframes(withDuration: 1.0 * Double(speed), delay: 0.0, options: [], animations: { 
				UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3 * Double(speed), animations: { 
					self.charaImageView.center.y = y - CGFloat(height * 0.8)
				})
				UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.1 * Double(speed), animations: { 
					self.charaImageView.center.y = y - CGFloat(height)
				})
				UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2 * Double(speed), animations: { 
					self.charaImageView.center.y = y
				})
				UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.4 * Double(speed), animations: { 
					self.charaImageView.center.y = y
				})
				
			}) { (stop) in
			}
			let animation:CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
			animation.toValue = Double.pi
			animation.duration = 0.125
			animation.repeatCount = 4
			animation.isCumulative = true
			self.charaImageView.layer.add(animation, forKey: "ImageViewRotation")
			self.charaImageView.layer.speed = 1.0
			
		}
		else if self.customChara == .mojichan {
			//もじちゃん
			charaImageView.stopAnimating()
			charaImageView.image = UIImage(named: "\(self.customChara.rawValue)_01_a")
			DataManager.animationJump(v: charaImageView, height: 50, speed: 0.25, isRepeat: false)
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {[weak self]() -> Void in
				self?.charaImageView.image = UIImage(named: "\(self!.customChara.rawValue)_01_a")
				let imgv = UIImageView(frame: self!.charaImageView.bounds)
				self?.charaImageView.addSubview(imgv)
				imgv.center = CGPoint(x: self!.charaImageView.bounds.size.width / 2, y: self!.charaImageView.bounds.size.height/2)
				imgv.image = UIImage(named: "\(self!.customChara.rawValue)_02")
				DataManager.animationFuwa(v: imgv, dy: 20, speed: 1.0)
				UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveLinear, animations: { 
					imgv.alpha = 0
				}, completion: { (stop) in
					imgv.removeFromSuperview()
				})
			})
		}
		else if self.customChara == .taiyokun {
			//太陽
			charaImageView.image = UIImage(named: "taiyokun_02")
			if let shipo = charaImageView.viewWithTag(100) as? UIImageView{
				shipo.image = UIImage(named: "taiyokun_shippo_02")
				DataManager.animationInfinityRotate(v: shipo, speed: 0.3)
			}
		}
		else if self.customChara == .tsukikun {
			//月
			charaImageView.image = UIImage(named: "tsukikun_02")
		}
		else if self.customChara == .kumokun {
			//雲
			//let x = charaImageView.center.x
			//let y = charaImageView.center.y
			// CAKeyframeAnimationオブジェクトを生成
			let animation = CAKeyframeAnimation(keyPath: "position")
			animation.fillMode = kCAFillModeForwards
			animation.isRemovedOnCompletion = true
			animation.duration = 1.0
			// 放物線のパスを生成
			let path = CGMutablePath()
			path.addArc(center: charaImageView.center, radius: 20, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
			// パスをCAKeyframeAnimationオブジェクトにセット
			animation.path = path
			// レイヤーにアニメーションを追加
			charaImageView.layer.add(animation, forKey: "CircleAnimation")
		}
		else if self.customChara == .pack {
			//パックマン
			MPEDataManager.animationJump(v: charaImageView, height: 50, speed: 0.5)
		}
		else if self.customChara == .ouji {
			//王子
			
		}
		else if self.customChara == .driller {
			//ドリラー
			MPEDataManager.animationJump(v: charaImageView, height: 50, speed: 0.5)
		}
		else if self.customChara == .galaga {
			//ギャラガー
			
		}
		
	}
	
	//MARK: - 背景アニメーション
	var backgroundTimer: Timer!
	var objDirection: ObjDirection = .downLeft
	
	func makeBackAnimation() {
		
		func make_obj(x: Int, y: Int, tag: Int, objNames: [String], animation: Bool) {
			
			if animation {
				let _ = self.makeObjAnimation(parent: backImageView, tag: tag, x: x, y: y, images: objNames)
			} 
			else {
				var objName: String = ""
				if objNames.count == 0 {
					objName = objNames[0]
				} else {
					let index = Int.random(in: 0 ..< objNames.count)
					objName = objNames[index]
				}
				let _ = self.makeObj(parent: backImageView, tag: tag, x: x, y: y, image: objName)
			}
		}
		
		var objNames: [String] = ["obj_flower_01"]
		var direction: String = "LD"
		let dd: CGFloat = 0.1
		var dx: CGFloat = -0.1
		var dy: CGFloat = 0.1
		var animation: Bool = false
		let stage = questIndex + 1
		if stage == 1 || stage == 6 || stage == 11 || stage == 16 {
			objNames = ["obj_flower_01"]
			direction = "LD"
		}
		else if stage == 2 || stage == 7 || stage == 12 || stage == 17 {
			objNames = ["obj_balloon_01","obj_balloon_02","obj_balloon_03","obj_balloon_04","obj_balloon_05","obj_balloon_06"]
			direction = "U"
		}
		else if stage == 3 || stage == 8 || stage == 13 || stage == 18 {
			objNames = ["obj_egg_01","obj_egg_02"]
			animation = true
			direction = "L"
		}
		else if stage == 4 || stage == 9 || stage == 14 || stage == 19 {
			objNames = ["obj_mush","obj_mush_01"]
			animation = true
			direction = "R"
		}
		else if stage == 5 || stage == 10 || stage == 15 || stage == 20 {
			objNames = ["obj_leaf_01","obj_leaf_02"]
			animation = true
			direction = "D"
		}
		else if stage == 21 || stage == 26 || stage == 31 || stage == 36 {
			objNames = ["obj_parasol_01","obj_parasol_02","obj_parasol_03","obj_parasol_04"]
			direction = "U"
		}
		else if stage == 22 || stage == 27 || stage == 32 || stage == 37 {
			objNames = ["obj_fish_01","obj_fish_02"]
			direction = "L"
		}
		else if stage == 23 || stage == 28 || stage == 33 || stage == 38 {
			objNames = ["obj_down_01","obj_down_02","obj_down_03"]
			animation = true
			direction = "D"
		}
		else if stage == 24 || stage == 29 || stage == 34 || stage == 39 || stage == 45 || stage == 50 || stage == 55 || stage == 60 || stage == 65 || stage == 70 || stage == 75 || stage == 80 {
			objNames = ["obj_flowerpost_01","obj_flowerpost_02"]
			animation = true
			direction = "LU"
		}
		else if stage == 25 || stage == 30 || stage == 35 || stage == 40 {
			objNames = ["obj_mojikun_01"]
			direction = "LD"
		}
		else if stage == 41 || stage == 46 || stage == 51 || stage == 56 {
			objNames = ["obj_cloud_01","obj_cloud_02"]
			animation = true
			direction = "L"
		}
		else if stage == 42 || stage == 47 || stage == 52 || stage == 57 {
			objNames = ["obj_yurei_01","obj_yurei_02"]
			animation = true
			direction = "RD"
		}
		else if stage == 43 || stage == 48 || stage == 53 || stage == 58 {
			objNames = ["obj_flash_01","obj_flash_02"]
			animation = true
			direction = "LD"
		}
		else if stage == 44 || stage == 49 || stage == 54 || stage == 59 {
			objNames = ["obj_ghost_01","obj_ghost_02"]
			animation = true
			direction = "RU"
		}
		else if stage == 61 || stage == 66 || stage == 71 || stage == 76 {
			objNames = ["obj_stripes_01"]
			direction = "U"
		}
		else if stage == 62 || stage == 67 || stage == 72 || stage == 77 {
			objNames = ["obj_stone_01","obj_stone_02"]
			animation = true
			direction = "D"
		}
		else if stage == 63 || stage == 68 || stage == 73 || stage == 78 {
			objNames = ["obj_up_01","obj_up_02","obj_up_03"]
			animation = true
			direction = "U"
		}
		else if stage == 64 || stage == 69 || stage == 74 || stage == 79 {
			objNames = ["obj_fireworks_01","obj_fireworks_02","obj_fireworks_03"]
			animation = true
			direction = "RU"
		}
		
		if direction == "LD" {
			dx = -dd
			dy = dd
		}
		else if direction == "RD" {
			dx = dd
			dy = dd
		}
		else if direction == "LU" {
			dx = -dd
			dy = -dd
		}
		else if direction == "RU" {
			dx = dd
			dy = -dd
		}
		else if direction == "L" {
			dx = -dd
			dy = 0
		}
		else if direction == "R" {
			dx = dd
			dy = 0
		}
		else if direction == "U" {
			dx = 0
			dy = -dd
		}
		else if direction == "D" {
			dx = 0
			dy = dd
		}
		
		for v in backImageView.subviews {
			v.removeFromSuperview()
		}
		let size = self.backImageView.frame.size
		for i in 0 ..< 15 {
			let y = Int.random(in: 0 ..< Int(size.height))
			let x = Int.random(in: 0 ..< Int(size.width))
			make_obj(x: x, y: y, tag: i + 100, objNames: objNames, animation: animation)
		}
		backgroundTimer?.invalidate()
		backgroundTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60, repeats: true, block: { [weak self](t) in
			guard let s = self else {
				return
			}
			let size = s.backImageView.frame.size
			let stars = s.backImageView.subviews
			for star in stars {
				let tag = star.tag
				star.center = CGPoint(x: star.center.x + dx, y: star.center.y + dy)
				if direction == "LD" {
					if star.center.y > size.height + 40 {
						star.removeFromSuperview()
						let x = Int.random(in: Int(size.width / 4) ..< Int(size.width * 1.25))
						let y = -40
						make_obj(x: x, y: y, tag: tag, objNames: objNames, animation: animation)
					} 
				}
				else if direction == "LU" {
					if star.center.y < -40 {
						star.removeFromSuperview()
						let x = Int.random(in: Int(size.width / 4) ..< Int(size.width * 1.25))
						let y = Int(size.height + 40)
						make_obj(x: x, y: y, tag: tag, objNames: objNames, animation: animation)
					} 
				}
				else if direction == "RU" {
					if star.center.y < -40 {
						star.removeFromSuperview()
						let x = Int.random(in: -Int(size.width / 4) ..< Int(size.width * 0.75))
						let y = Int(size.height + 40)
						make_obj(x: x, y: y, tag: tag, objNames: objNames, animation: animation)
					} 
				}
				else if direction == "RD" {
					if star.center.y > size.height + 40 {
						star.removeFromSuperview()
						let x = Int.random(in: Int(size.width / 4) ..< Int(size.width * 1.25))
						let y = -40
						make_obj(x: x, y: y, tag: tag, objNames: objNames, animation: animation)
					} 
				}
				else if direction == "U" {
					if star.center.y < -40 {
						star.removeFromSuperview()
						let x = Int.random(in: 80 ..< Int(size.width - 80))
						let y = Int.random(in: 40 ..< 80)
						make_obj(x: x, y: Int(size.height + CGFloat(y)), tag: tag, objNames: objNames, animation: animation)
					} 
				}
				else if direction == "D" {
					if star.center.y > size.height + 40 {
						star.removeFromSuperview()
						let x = Int.random(in: 80 ..< Int(size.width - 80))
						let y = Int.random(in: 40 ..< 80)
						make_obj(x: x, y: -y, tag: tag, objNames: objNames, animation: animation)
					} 
				}
				else if direction == "R" {
					if star.center.x > size.width + 40 {
						star.removeFromSuperview()
						let x = Int.random(in: 40 ..< 80)
						let y = Int.random(in: 0 ..< Int(size.height))
						make_obj(x: -x, y: y, tag: tag, objNames: objNames, animation: animation)
					} 
				}
				else if direction == "L" {
					if star.center.x < -40 {
						star.removeFromSuperview()
						let x = Int.random(in: 40 ..< 80)
						let y = Int.random(in: 0 ..< Int(size.height))
						make_obj(x: Int(size.width) + x, y: y, tag: tag, objNames: objNames, animation: animation)
					} 
				}
			}
		})
		
	}
	func makeObj(parent: UIView, tag: Int, x: Int, y: Int, image: String) -> UIImageView {
		
		let star = UIImageView(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
		star.contentMode = .scaleAspectFit
		star.tag = tag 
		star.image = UIImage(named: image)
		parent.addSubview(star)
		star.center = CGPoint(x: x, y: y)
		
		return star
	}
	func makeObjAnimation(parent: UIView, tag: Int, x: Int, y: Int, images: [String]) -> UIImageView {
		
		var imgs: [UIImage] = []
		for name in images {
			imgs.append(UIImage(named: name)!)
		}
		let star = UIImageView(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
		star.contentMode = .scaleAspectFit
		star.tag = tag 
		star.animationImages = imgs
		star.animationDuration = 1.0
		parent.addSubview(star)
		star.center = CGPoint(x: x, y: y)
		star.startAnimating()
		return star
	}
	
	//MARK: - スコア計算
	//文字から得点計算
	func makeScore(moji: [TableInfo]) -> Int {
		
		var score = 0
		var bw: Int = 1
		for info in moji {
			let c = info.moji.lowercased()
			let t = info.type
			//テーブル値による加算
			var bc: Int = 1
			if t == "DL" {
				bc = 2
			}
			else if t == "TL" {
				bc = 3
			}
			if t == "DL" {
				bw = 2
			}
			else if t == "TL" {
				bw = 3
			}
			
			if c == "a" || c == "e" || c == "i" || c == "l" || c == "n" || c == "o" || c == "r" || c == "s" || c == "t" || c == "u" {
				score += 1 * bc
			}
			else if c == "d" || c == "g" {
				score += 2 * bc
			}
			else if c == "b" || c == "c" || c == "m" || c == "p" {
				score += 3 * bc
			}
			else if c == "f" || c == "h" || c == "v" || c == "m" || c == "y" {
				score += 4 * bc 
			}
			else if c == "k" {
				score += 5 * bc 
			}
			else if c == "j" || c == "x" {
				score += 8 * bc 
			}
			else if c == "q" || c == "z" {
				score += 10 * bc 
			}
		}
		return score * bw * 10
	}
	func score(word: String) -> Int {
		
		var score = 0
		for i in 0 ..< word.count {
			let c = word[word.index(word.startIndex, offsetBy: i)]
			if c == "a" || c == "e" || c == "i" || c == "l" || c == "n" || c == "o" || c == "r" || c == "s" || c == "t" || c == "u" {
				score += 1
			}
			else if c == "d" || c == "g" {
				score += 2
			}
			else if c == "b" || c == "c" || c == "m" || c == "p" {
				score += 3 
			}
			else if c == "f" || c == "h" || c == "v" || c == "m" || c == "y" {
				score += 4 
			}
			else if c == "k" {
				score += 5 
			}
			else if c == "j" || c == "x" {
				score += 8 
			}
			else if c == "q" || c == "z" {
				score += 10 
			}
		}
		return score * 10
	}
	//MARK: -
	
	
	//２文字以上の単語を複数のサブテキストに分割
	func separate(word: String, info: [TableInfo]) -> [[TableInfo]] {
		
		var ret_info: [[TableInfo]] = []
		if info.count >= 2 {
			for startIndex in 0 ..< info.count - 1 {
				for endIndex in startIndex + 1 ..< info.count {
					var mojiCount = 0
					var ret: [TableInfo] = []
					for _ in startIndex ... endIndex {
						let index = startIndex + mojiCount
						let infoData = info[index]
						ret.append(infoData)
						mojiCount += 1
					}
					if ret.count > 1 {
						ret_info.append(ret)
					}
				}
			}
		}
		
		for infos in ret_info {
			print("------------------------------------------------------------")
			for info in infos {
				print("[\(info)")
			}
		}
		return ret_info
		
		//文字をセパレート
//		var ret: [String] = []
//		if word.count >= 2 {
//			for i in 0 ..< word.count {
//				for ii in i + 1 ... word.count {
//					let c = word[word.index(word.startIndex, offsetBy: i) ..< word.index(word.startIndex, offsetBy: ii)]
//					let s = String(c)
//					if s.count > 1 {
//						ret.append(s)
//					}
//				}
//			}
//		}
//		return ret
	}
	
	
	//MARK:- FontCardViewDelegate
	
	func fontCardViewTap(font: FontCardView) {
		
		if self.isInEffect {
			return
		}
		self.cardSelectIndex = font.tag
		//let moji = self.questData.cards[self.cardSelectIndex]
		//print("\(moji)")
		for cardView in self.cardViewList {
			if cardView.tag == self.cardSelectIndex {
				cardView.isSelected = true
			} else {
				cardView.isSelected = false
			}
		}
	}
	
	//MARK:- UIScrollViewDelegate
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		
		return self.gameTable
	}
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		
		updateScrollInset()
	}
	
	
	
	//MARK: - GameTableViewDelegate
	func gameTableViewToucheDown(table: GameTableView, koma: TableKomaView) {
		
		self.mainScrollView.isScrollEnabled = false
	}
	func gameTableViewToucheUp(table: GameTableView, koma: TableKomaView) {
		
		if self.isInEffect {
			return
		}
		//MARK: 得点計算
		let tableIndex = koma.tag
		self.checkKomaSet = []
		self.checkTableInfoH = []
		self.checkTableInfoV = []
		self.mainScrollView.isScrollEnabled = true
		if let index = self.cardSelectIndex {
			let moji = self.questData.cards[index]
			koma.setFont(moji: moji, type: nil)
			self.questData.table[tableIndex] = moji
			if self.questData.wildCardLen < index + 1 {
				//ワイルドカード使用
				self.questData.cards.remove(at: index)
				for v in self.cardScrolliew.subviews {
					v.removeFromSuperview()
				}
				self.updateCardScroll()
				self.cardSelectIndex = nil
			}
			
			var infoList: [[TableInfo]] = []
			var list: [[String:[String]]] = []
			//横の検索
			let wordHline = self.checkWordH(startIndex: tableIndex)
			//縦の検索
			let wordVline = self.checkWordV(startIndex: tableIndex)
			//ワードを２文字以上に分割する
			let hWords: [[TableInfo]] = self.separate(word: wordHline, info: self.checkTableInfoH)
			let vWords: [[TableInfo]] = self.separate(word: wordVline, info: self.checkTableInfoV)
			let allWords: [[TableInfo]] = hWords + vWords
			for wordInfos in allWords {
				var word: String = ""
				for info in wordInfos {
					let c = info.moji
					word.append(c)
				}
				let listH = dataMrg.search(word: word.lowercased(), match: .perfect)
				if listH.count > 0 {
					infoList.append(wordInfos)
				}
				list += listH
			}
			
			var hitWords: [String] = []
			var infoText: [String] = []
			for dic in list {
				let keys = dic.keys
				for key in keys {
					hitWords.append(key)
					let values = dic[key]!
					var value: String = "---"
					if values.count > 0 {
						value = values[0]
						//print(" >【\(key)】\(value)")
						infoText.append(value)
					} else {
						infoText.append("【\(key)】---")
					}
				}
			}
			
			
			
			if hitWords.count > 0 {
				SoundManager.shared.startSE(type: .seCorrect)	//SE再生
				//あたり
				//print("単語数: \(hitWords.count)")
				var delay: Double = 0.2
				var effectCount = 0
				var okWords = 0
				var scores: [Int] = []
				for i in 0 ..< hitWords.count {
					let hitWord = hitWords[i]
					let info = infoText[i]
					let infoData = infoList[i]
					if nil == self.answerWords[hitWord] {
						//!!!!!!!!!!!!!!
						//有効ヒット！！
						//!!!!!!!!!!!!!!
						okWords += 1
						self.answerWords[hitWord] = info	//回答済み単語入り
						//スコア計算
						let score = self.makeScore(moji: infoData)
						scores.append(score)
						//コマの特定
						var komas: [TableKomaView] = []
						for info in infoData {
							let koma = self.gameTable.komas[info.index]
							komas.append(koma)
						}
						
						let mojiCount = hitWord.count
						//print("文字数: \(mojiCount)[\(hitWord)]")
						DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
							if self.isGameEnd == false {
								
								effectCount += 1
								
								//スコア表示更新
								var isLast = false
								if effectCount >= okWords {
									isLast = true
								}
								let nScore = scores[effectCount - 1]
								self.totalScore += nScore
								self.setNowScore(score: self.nowScore + nScore, last: isLast)
								
								if self.questData.questType == .makeWoredsCount {
									//+++++++++++++++++++++++++
									//◯字数以上の英単語を◯個作る
									//+++++++++++++++++++++++++
									var words: Int = 0
									if let v = self.questData.questData["words"] as? Int {
										words = v
									}
									if mojiCount >= words {
										self.questCount -= 1
										//print("\(words)字数以上の英単語を\(self.questCount)個作る")
									}
								}
								else if self.questData.questType == .useFontMakeCount {
									//+++++++++++++++++++++++++
									//◯がつく英単語を○個作る
									//+++++++++++++++++++++++++
									var font: String = ""
									if let v = self.questData.questData["font"] as? String {
										font = v
									}
									if hitWord.contains(font.lowercased()) {
										self.questCount -= 1
									}
								}
								else if self.questData.questType == .hiScore {
									//+++++++++++++++++++++++++
									//スコアを○点以上
									//+++++++++++++++++++++++++
									self.questCount -= score
									//print("残り\(self.questCount)点")
								}
								else {
									self.questCount -= 1
									//print("残り\(self.questCount)個")
								}
								self.tableTapEffect(komas: komas)	//エフェクト
								let hitView = HitInfoView.hitInfoView()
								SoundManager.shared.startComboSE(effectCount)	//SE再生
								self.makeChainAnimation(num: effectCount)		//コンボアニメーション
								//print("effectCount: \(effectCount)")
								self.isInEffect = true
								//MARK: 正解単語表示
								hitView.open(title: hitWord.uppercased(), info: info, parent: self.view, finished: {[weak self]() in
									guard let s = self else {
										return
									}
									if effectCount >= okWords && s.nowScore > 0 {
										self?.nowScore = 0
										self?.isInEffect = false
										self?.charaImageView.layer.removeAllAnimations()
										self?.makeDefCharaAnimation()
										//MARK: クリア判定
										if s.checkGame() {
											return
										} else {
											s.record()
										}
									}
								})
								self.makeHitCharaAnimation()	//キャラクターアニメーション
							}
						}
						delay += 1.2
					} else {
						if i == hitWords.count - 1 {
							DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { 
								//ハズレ
								if (self.emptyTableCount() == 0 || self.cardViewList.count == 0) && self.isInEffect == false {
									//ゲームオーバー
									self.gameOver()
									return
								} else {
									self.record()
								}
							}
						}
					}
				}
			} else {
				//ハズレ
				SoundManager.shared.startSE(type: .seKomaPut)	//SE再生
				if emptyTableCount() == 0 || cardViewList.count == 0 {
					//ゲームオーバー
					self.gameOver()
				} else {
					self.record()
				}
			}
		}
	}
	
	//ゲームチェック
	func checkGame() -> Bool {
		
		var ret = false
		if self.questData.questType == .makeWords {
			//+++++++++++++++++++++++++
			//英単語を◯個作る
			//+++++++++++++++++++++++++
			if self.questCount <= 0 {
				//クリア
				self.gameClear()
				ret = true
			} else {
				if emptyTableCount() == 0 || cardViewList.count == 0 {
					//ゲームオーバー
					self.gameOver()
					ret = true
				}
			}
		}
		else if self.questData.questType == .fillAllCell {
			//+++++++++++++++++++++++++
			//全てのマスを埋める
			//+++++++++++++++++++++++++
			var count = 0
			for koma in self.gameTable.komas {
				if koma.moji == "0" {
					count += 1
				}
			}
			self.questCount = count
			if self.questCount <= 0 {
				//クリア
				self.gameClear()
				ret = true
			} else {
				if cardViewList.count == 0 {
					//ゲームオーバー
					self.gameOver()
					ret = true
				}
			}
		}
		else if self.questData.questType == .useAllFont {
			//+++++++++++++++++++++++++
			//すべてのアルファベットを使う
			//+++++++++++++++++++++++++
			//print("cardViewList count: \(cardViewList.count)")
			//手札が空
			if cardViewList.count == 0 {
				//クリア
				self.gameClear()
				ret = true
			} else {
				var wc = 0
				for t in cardViewList {
					if t.isWildCard {
						wc += 1
					}
				}
				//ワイルドカードだけが残っている
				if wc == cardViewList.count {
					//クリア
					self.gameClear()
					ret = true
				} else {
					if emptyTableCount() == 0 {
						//ゲームオーバー
						self.gameOver()
						ret = true
					}
				}
			}
		}
		else if self.questData.questType == .makeWoredsCount {
			//+++++++++++++++++++++++++
			//◯字数以上の英単語を◯個作る
			//+++++++++++++++++++++++++
			if self.questCount <= 0 {
				//クリア
				self.gameClear()
				ret = true
			} else {
				if emptyTableCount() == 0 || cardViewList.count == 0 {
					//ゲームオーバー
					self.gameOver()
					ret = true
				}
			}
		}
		else if self.questData.questType == .hiScore {
			//+++++++++++++++++++++++++
			//スコアを○点以上
			//+++++++++++++++++++++++++
			var count: Int = 0
			if let v = self.questData.questData["count"] as? Int {
				count = v
			}
			if self.totalScore >= count {
				//クリア
				self.gameClear()
				ret = true
			} else {
				if emptyTableCount() == 0 || cardViewList.count == 0 {
					//ゲームオーバー
					self.gameOver()
					ret = true
				}
			}
		}
		else if self.questData.questType == .useFontMakeCount {
			//+++++++++++++++++++++++++
			//◯がつく英単語を○個作る
			//+++++++++++++++++++++++++
			if self.questCount <= 0 {
				//クリア
				self.gameClear()
				ret = true
			} else {
				if emptyTableCount() == 0 || cardViewList.count == 0 {
					//ゲームオーバー
					self.gameOver()
					ret = true
				}
			}
		}
		print("クリア判定 > \(ret)")
		return ret
	}
	
	
	//空きテーブル数を返す
	func emptyTableCount() -> Int {
		
		var count = 0
		for koma in self.gameTable.komas {
			if koma.moji == "0" {
				count += 1
			}
		}
		return count
	}
	
	//MARK: ゲームポーズ
	var isGamePause: Bool = false
	func gamePause() {
		
		SoundManager.shared.pauseBGM(true)		//BGMポーズ（停止）

		self.isGamePause = true
		let pause = PauseView.pauseView()
		var wordList: [[String:String]] = []
		let keys = self.answerWords.keys
		for key in keys {
			if let info = self.answerWords[key] {
				let dic = ["word":key,"info":info]
				wordList.append(dic)
			}
		}
		pause.wordList = wordList
		self.view.addSubview(pause)
		pause.closeHandler = {[weak self](res) in
			self?.isGamePause = false
			switch res {
			case .continueGame:		//続ける
				print("ゲームをつづける")
				SoundManager.shared.pauseBGM(false)		//BGMポーズ（解除）
			case .retry:			//やりなおす
				self?.gameTimer?.invalidate()
				self?.gameTimer = nil
				self?.chaDefTimer?.invalidate()
				self?.chaDefTimer = nil
				self?.retry()
			case .giveup:			//あきらめる
				self?.gameTimer?.invalidate()
				self?.gameTimer = nil
				self?.chaDefTimer?.invalidate()
				self?.chaDefTimer = nil
				self?.remove()
				SoundManager.shared.startBGM(type: .bgmWait)		//BGM再生
			}
		}
	}
	
	//MARK: ゲームクリア
	var isGameEnd = false
	func gameClear() {
		if isGameEnd {
			return
		}
		isEnablePause = false
		SoundManager.shared.startBGM(type: .bgmStageClear)	//ジングル再生
		
		isGameEnd = true
		self.gameTimer?.invalidate()
		self.gameTimer = nil
		chaDefTimer?.invalidate()
		chaDefTimer = nil
		
		var effectTimer: Timer!
		DataManager.animationJump(v: charaImageView, height: 40, speed: 1.0)	//ジャンプアニメーション
		
		let base = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
		self.view.addSubview(base)
		base.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
		base.backgroundColor = UIColor.clear
		
		let gameclear = UIImageView(frame: CGRect(x: 0, y: 0, width: 520, height: 200))
		gameclear.contentMode = .scaleAspectFit
		gameclear.image = UIImage(named: "gameclear_anim_logo.png")
		base.addSubview(gameclear)
		gameclear.center = CGPoint(x: base.frame.size.width/2, y: base.frame.size.height/2 - 20)
		gameclear.transform = CGAffineTransform(scaleX: 0, y: 0)
		UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseInOut, animations: { 
			gameclear.transform = CGAffineTransform(scaleX: 1, y: 1)
		}) { (stop) in
			UIView.animate(withDuration: 0.25, delay: 3.0, options: .curveEaseInOut, animations: { 
				gameclear.alpha = 0
			}) { [weak self](stop) in
				guard let s = self else {
					return
				}
				for v in base.subviews {
					v.layer.removeAllAnimations()
					v.removeFromSuperview()
				}
				base.removeFromSuperview()
				
				effectTimer.invalidate()
				effectTimer = nil
				s.charaImageView.layer.removeAllAnimations()	//アニメーション停止
				
				s.charaBaseView.isHidden = true
				let clear = GameClearView.gameClearView()
				var wordList: [[String:String]] = []
				let keys = s.answerWords.keys
				for key in keys {
					if let info = s.answerWords[key] {
						let dic = ["word":key,"info":info]
						wordList.append(dic)
					}
				}
				clear.wordList = wordList
				s.view.addSubview(clear)
				clear.closeHandler = {[weak self](res) in
					self?.isGameEnd = false
					self?.charaBaseView.isHidden = false
					switch res {
					case .next:				//次の問題へ進む
						clear.closeHandler = nil
						clear.removeFromSuperview()
						self?.nextQuest()
					case .select:			//セレクト画面に戻る
						self?.gameTimer?.invalidate()
						self?.gameTimer = nil
						self?.chaDefTimer?.invalidate()
						self?.chaDefTimer = nil
						clear.closeHandler = nil
						clear.removeFromSuperview()
						self?.remove()
						SoundManager.shared.startBGM(type: .bgmWait)		//BGM再生
					case .dict:				//辞書モードで復習！
						print("辞書モードで復習！")
					}
				}
			}
		}
		
		//アンダーバー
		let gameclear_ub = UIImageView(frame: CGRect(x: 0, y: 0, width: 520, height: 80))
		gameclear_ub.contentMode = .scaleAspectFit
		gameclear_ub.image = UIImage(named: "gameclear_anim_underbar")
		base.addSubview(gameclear_ub)
		gameclear_ub.center = CGPoint(x: base.frame.size.width/2, y: (base.frame.size.height/2) + (gameclear.frame.size.height / 2) + 40)
		//文字(game clear!!)
		for i in 1 ... 11 {
			let num = NSString(format: "%02d", i)
			let name = "gameclear_anim_word\(num)"
			let gameclear_logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 510, height: 66))
			gameclear_logo.contentMode = .scaleAspectFit
			gameclear_logo.image = UIImage(named: name)
			base.addSubview(gameclear_logo)
			gameclear_logo.center = CGPoint(x: base.frame.size.width/2, y: (base.frame.size.height/2) + (gameclear.frame.size.height / 2) + 33)
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { 
				DataManager.animationJump(v: gameclear_logo, height: 25, speed: 0.5)
			}
		}
		
		//火花エフェクト
		let images: [UIImage] = [
			UIImage(named: "gameclear_anim_effect0.png")!,
			UIImage(named: "gameclear_anim_effect1.png")!,
			UIImage(named: "gameclear_anim_effect2.png")!,
			UIImage(named: "gameclear_anim_effect3.png")!,
			UIImage(named: "gameclear_anim_effect4.png")!,
			UIImage(named: "gameclear_anim_effect5.png")!,
			UIImage(named: "gameclear_anim_effect6.png")!,
			UIImage(named: "gameclear_anim_effect7.png")!,
			UIImage(named: "gameclear_anim_effect8.png")!,
			UIImage(named: "gameclear_anim_effect9.png")!,
			UIImage(named: "gameclear_anim_effect10.png")!,
			UIImage(named: "gameclear_anim_effect11.png")!,
			UIImage(named: "gameclear_anim_effect12.png")!,
			UIImage(named: "gameclear_anim_effect13.png")!,
			UIImage(named: "gameclear_anim_effect14.png")!,
			UIImage(named: "gameclear_anim_effect15.png")!,
			UIImage(named: "gameclear_anim_effect16.png")!,
			UIImage(named: "gameclear_anim_effect17.png")!,
			UIImage(named: "gameclear_anim_effect18.png")!,
			UIImage(named: "gameclear_anim_effect19.png")!,
			UIImage(named: "gameclear_anim_effect20.png")!,
			UIImage(named: "gameclear_anim_effect21.png")!,
		]
		let size = base.frame.size
		effectTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (t) in
			let effect = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
			base.addSubview(effect)
			let y = Int.random(in: 50 ..< Int(size.height - 50))
			let x = Int.random(in: 50 ..< Int(size.width - 50))
			effect.center = CGPoint(x: x, y: y)
			effect.animationImages = images
			effect.animationDuration = 1.0
			effect.startAnimating()
		})
	}
	//MARK: ゲームオーバー
	func gameOver() {
		if isGameEnd {
			return
		}
		isEnablePause = false
		SoundManager.shared.startBGM(type: .bgmFail)	//BGM再生
		
		//ゲームオーバー雲
		self.timeBackImageView.stopAnimating()
		self.timeBackImageView.image = UIImage(named: "time_cloud_gameover")
		
		isGameEnd = true
		self.gameTimer?.invalidate()
		self.gameTimer = nil
		chaDefTimer?.invalidate()
		chaDefTimer = nil
		
		let base = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
		self.view.addSubview(base)
		base.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
		base.backgroundColor = UIColor.clear
		
		let gameover = UIImageView(frame: CGRect(x: 0, y: 0, width: 590, height: 87))
		gameover.contentMode = .scaleAspectFit
		gameover.image = UIImage(named: "gameover_anim_word.png")
		base.addSubview(gameover)
		gameover.center = CGPoint(x: base.frame.size.width/2, y: -gameover.frame.size.height)
		
		//キャラクターアニメーション停止
		charaImageView.stopAnimating()
		charaImageView.image = UIImage(named: "\(self.customChara.rawValue)_03")
		charaImageView.layer.removeAllAnimations()
		
		UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseInOut, animations: { 
			gameover.center = CGPoint(x: base.frame.size.width/2, y: base.frame.size.height/2)
		}) { (stop) in
			UIView.animate(withDuration: 0.25, delay: 3.0, options: .curveEaseInOut, animations: {
				gameover.alpha = 0
			}) { [weak self](stop) in
				base.removeFromSuperview()
				guard let s = self else {
					return
				}
				s.charaBaseView.isHidden = true
				s.charaImageView.transform = CGAffineTransform(rotationAngle: 0)
				let over = GameOverView.gameOverView()
				var wordList: [[String:String]] = []
				let keys = s.answerWords.keys
				for key in keys {
					if let info = s.answerWords[key] {
						let dic = ["word":key,"info":info]
						wordList.append(dic)
					}
				}
				over.wordList = wordList
				s.view.addSubview(over)
				over.closeHandler = {[weak self](res) in
					self?.isGameEnd = false
					self?.charaBaseView.isHidden = false
					switch res {
					case .retry:				//やりなおす
						over.closeHandler = nil
						over.removeFromSuperview()
						self?.retry()
					case .timeDouble:			//Timeを倍にする（動画）
						print("Timeを倍にする（動画）")
					case .next:					//次の問題へ進む（動画）
						print("Timeを倍にする（動画）")
					case .giveup:				//諦める
						self?.gameTimer?.invalidate()
						self?.gameTimer = nil
						over.closeHandler = nil
						over.removeFromSuperview()
						self?.remove()
						SoundManager.shared.startBGM(type: .bgmWait)		//BGM再生
					}
				}
			}
		}
		
		//キャラクターアニメーション（ジャンプ反転）
		let height = 140.0
		let speed = 0.8
		let x = self.charaImageView.center.x
		let y = self.charaImageView.center.y
		UIView.animateKeyframes(withDuration: 1.0 * Double(speed), delay: 0.0, options: [], animations: { 
			UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3 * Double(speed), animations: { 
				self.charaImageView.center.y = y - CGFloat(height * 0.8)
				self.charaImageView.center.x = x - 10
			})
			UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.1 * Double(speed), animations: { 
				self.charaImageView.center.y = y - CGFloat(height)
				self.charaImageView.center.x = x
			})
			UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2 * Double(speed), animations: { 
				self.charaImageView.center.y = y
				self.charaImageView.center.x = x + 10
			})
			UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.4 * Double(speed), animations: { 
				self.charaImageView.center.y = y
				self.charaImageView.center.x = x
			})
			
			UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5 * Double(speed), animations: { 
				self.charaImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
			})
		}) { (stop) in
		}
		
	}
	
	//MARK: ゲーム記録
	func record() {
		print("ゲーム記録: SCORE:\(self.totalScore) COUNT:\(questCount)")
		self.questData.score = self.totalScore
		self.questData.count = self.questCount
		self.questData.answerWords = self.answerWords
		self.questDataBKList.append(self.questData)
		self.questDataBKIndex += 1
		
		self.undoButton.isHidden = false
	}
}
