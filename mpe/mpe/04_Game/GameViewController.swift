//
//  GameViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

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
			//self.mainScrollView.isUserInteractionEnabled = !_isInEffect
		}
	}
	
	var questIndex: Int = 0
	let dataMrg = MPEDataManager()
	var questData: QuestData!
	var questDataDef: QuestData!
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
			let qSubLabel = self.makeVerticalLabel(size: self.questDisplayImageView.frame.size, font: UIFont.boldSystemFont(ofSize: 16), text: qTextSub)
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
		baseCnt.questDataDef = questData 
		return baseCnt
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.scoreLabel.outlineColor = UIColor.black
		self.scoreLabel.outlineWidth = 3
		
		self.timeLabel.outlineColor = UIColor.black
		self.timeLabel.outlineWidth = 3
    }
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		if self.gameTable == nil {
			
			//手札
			self.updateCardScroll()
			//ゲームテーブル
			self.updateGametable()
			//問題
			self.updateQuestString()
			//文字くんメッセージ
			self.updateMojikunString()
			
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
	
	@IBOutlet weak var cardLeftButton: UIButton!
	@IBAction func cardLeftButtonAction(_ sender: UIButton) {
		
	}
	@IBOutlet weak var cardRightButton: UIButton!
	@IBAction func cardRightButtonAction(_ sender: UIButton) {
		
	}
	
	//キャラクター
	@IBOutlet weak var charaBaseView: UIView!
	@IBOutlet weak var charaImageView: UIImageView!
	@IBOutlet weak var ballonImageView: UIImageView!
	@IBOutlet weak var ballonDisplayImageView: UIImageView!
	var ballonMainLabel: TTTAttributedLabel!
	
	
	//スコア
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
	
	//タイム
	@IBOutlet weak var timeLabel: OutlineLabel!
	var gameTimer: Timer!
	var _time: Double = 99
	var time: Double {
		get {
			return _time
		}
		set {
			_time = newValue
			self.timeLabel.text = "\(Int(_time))"
		}
	}
	
	func startGameTimer() {
		
		self.time = 99
		
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
				
				self?.gameTimer?.invalidate()
				self?.gameTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self](t) in
					guard let s = self else {
						return
					}
					if s.isGamePause == false {
						s.time -= 0.1
						if s.time <= 0 {
							s.gameOver()
						}
					}
				})
			}
		}
		
	}
	
	
	//MARK: やりなおし
	func retry() {
		
		self.startGameTimer()
		
		self.answerWords = [:]
		self.totalScore = 0
		self.questData = self.questDataDef
		//手札
		self.updateCardScroll()
		//ゲームテーブル
		self.updateGametable()
		//問題
		self.updateQuestString()
		//文字くんメッセージ
		self.updateMojikunString()
		
	}
	//MARK: 次の問題
	func nextQuest() {
		
		if self.selectCnt.questDatas.count - 1 > self.questIndex {
			self.questIndex += 1
			self.questDataDef = self.selectCnt.questDatas[self.questIndex]
			self.retry()
		} else {
			self.remove()
		}
	}
	
	
	//戻る
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		
		self.gamePause()
	}
	
	
	private func updateScrollInset() {
		
	}
	
	func updateCardScroll() {
		
		for v in self.cardScrolliew.subviews {
			v.removeFromSuperview()
		}
		self.cardViewList = []
		for i in 0 ..< self.questData.cards.count {
			let moji = self.questData.cards[i]
			let cardView = FontCardView.fontCardView(moji: moji)
			cardView.delegate = self
			cardView.tag = i
			self.cardScrolliew.addSubview(cardView)
			//card1.backImageView.image = UIImage(named: "orange_\(i+1)")
			cardView.center = CGPoint(x: (cardView.frame.size.width / 2) + (CGFloat(i) * cardView.frame.size.width), y: self.cardScrolliew.frame.size.height / 2)
			if self.questData.wildCardLen > i {
				cardView.isWildCard = true
			}
			self.cardViewList.append(cardView)
		}
		self.cardScrolliew.contentSize = CGSize(width: CGFloat(self.questData.cards.count) * 50, height: self.cardScrolliew.frame.size.height / 2)
		
	}
	
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
		let qLabel = self.makeVerticalLabel(size: self.questDisplayImageView.frame.size, font: UIFont.boldSystemFont(ofSize: 16), text: qText)
		qLabel.textAlignment = .left
		qLabel.numberOfLines = 2
		self.questDisplayImageView.addSubview(qLabel)
		qLabel.center = CGPoint(x: self.questDisplayImageView.frame.size.width / 2, y: self.questDisplayImageView.frame.size.height / 2)
		self.questMainLabel = qLabel
		
		self.questCount = count
		
	}
	
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
		let bLabel = self.makeVerticalLabel(size: self.ballonDisplayImageView.frame.size, font: UIFont.boldSystemFont(ofSize: 14), text: bText)
		bLabel.textAlignment = .center
		bLabel.numberOfLines = 2
		self.ballonDisplayImageView.addSubview(bLabel)
		bLabel.center = CGPoint(x: self.ballonDisplayImageView.frame.size.width / 2, y: self.ballonDisplayImageView.frame.size.height / 2)
		self.ballonMainLabel = bLabel
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
	@IBOutlet weak var editButton: UIButton!
	@IBAction func editButtonAction(_ sender: UIButton) {
		
		let edit = EditViewController.editViewController(questData: self.questData)
		self.present(edit, animated: true) { 
			
		}
		edit.finishedHandler = {(data) in
			self.questData = data
			//手札
			self.updateCardScroll()
			//ゲームテーブル
			self.updateGametable()
			//問題
			self.updateQuestString()
			//文字くんメッセージ
			self.updateMojikunString()
		}
	}
	
	
	func makeVerticalLabel(size: CGSize, font: UIFont, text: String?) -> TTTAttributedLabel {
		
		let label: TTTAttributedLabel = TTTAttributedLabel(frame: CGRect(x: 0, y: 0, width: size.height, height: size.width))
		label.backgroundColor = UIColor.clear
		label.textColor = UIColor.black
		label.numberOfLines = 0
		label.font = font
		label.textAlignment = .center
		label.contentScaleFactor = 0.5
		let angle = Double.pi / 2
		label.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
		label.setText(text) { (mutableAttributedString) -> NSMutableAttributedString? in
			mutableAttributedString?.addAttribute(NSAttributedStringKey(rawValue: kCTVerticalFormsAttributeName as String as String), value: true, range: NSMakeRange(0,(mutableAttributedString?.length)!))
			return mutableAttributedString
		}
		return label
	}
	
	func buildWord(moji: [TableInfo]) -> String {
		
		var word: String = ""
		for info in moji {
			word.append(info.moji)
		}
		return word.lowercased()
	}
	
	//MARK: - スコア計算
	//文字から得点計算
	func score(moji: [TableInfo]) -> Int {
		
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
						print(" >【\(key)】\(value)")
						infoText.append(value)
					} else {
						infoText.append("【\(key)】---")
					}
				}
			}
			
			
			
			if hitWords.count > 0 {
				//あたり
				print("単語数: \(hitWords.count)")
				var delay: Double = 0
				//self.isInEffect = true
				var effectCount = 0
				var okWords = 0
				for i in 0 ..< hitWords.count {
					let hitWord = hitWords[i]
					let info = infoText[i]
					let infoData = infoList[i]
					if nil == self.answerWords[hitWord] {
						okWords += 1
						self.answerWords[hitWord] = info	//回答済み単語入り
						//スコア計算
						let score = self.score(moji: infoData)
						self.totalScore += score
						//コマの特定
						var komas: [TableKomaView] = []
						for info in infoData {
							let koma = self.gameTable.komas[info.index]
							komas.append(koma)
						}
						
						let mojiCount = hitWord.count
						print("文字数: \(mojiCount)[\(hitWord)]")
						effectCount += 1
						DispatchQueue.main.asyncAfter(deadline: .now() + delay) { 
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
									print("\(words)字数以上の英単語を\(self.questCount)個作る")
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
								if hitWord.contains(font) {
									self.questCount -= 1
								}
							}
							else {
								self.questCount -= 1
								print("残り\(self.questCount)個")
							}
							self.isInEffect = false
							self.tableTapEffect(komas: komas)	//エフェクト
							let hitView = HitInfoView.hitInfoView()
							hitView.open(title: hitWord.uppercased(), info: info, parent: self.view, finished: {[weak self]() in
								print("effectCount: \(effectCount)")
								guard let s = self else {
									return
								}
								if effectCount >= okWords {
									//MARK: クリア判定
									if s.checkGame() {
										return
									}
								}
							})
						}
						delay += 1.3
					} else {
						if i == hitWords.count - 1 {
							self.isInEffect = false
							//ハズレ
							if emptyTableCount() == 0 || cardViewList.count == 0 {
								//ゲームオーバー
								self.gameOver()
								return
							}
						}
					}
				}
			} else {
				self.isInEffect = false
				//ハズレ
				if emptyTableCount() == 0 || cardViewList.count == 0 {
					//ゲームオーバー
					self.gameOver()
				}
			}
		}
	}
	
	//ゲームチェック
	func checkGame() -> Bool {
		
		var ret = false
		print("クリア判定！！")
		if self.questData.questType == .makeWords {
			//+++++++++++++++++++++++++
			//英単語を◯個作る
			//+++++++++++++++++++++++++
			self.questCount -= 1
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
			print("cardViewList count: \(cardViewList.count)")
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
			if self.totalScore <= count {
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
		
		self.isGamePause = true
		let pause = PauseView.pauseView()
		self.view.addSubview(pause)
		pause.closeHandler = {(res) in
			self.isGamePause = false
			switch res {
			case .continueGame:		//続ける
				print("ゲームをつづける")
			case .retry:			//やりなおす
				self.gameTimer?.invalidate()
				self.gameTimer = nil
				self.retry()
			case .giveup:			//あきらめる
				self.gameTimer?.invalidate()
				self.gameTimer = nil
				self.remove()
			}
		}
	}
	
	//MARK: ゲームクリア
	var isGameEnd = false
	func gameClear() {
		if isGameEnd {
			return
		}
		isGameEnd = true
		self.gameTimer?.invalidate()
		self.gameTimer = nil
		
		let base = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
		self.view.addSubview(base)
		base.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
		base.backgroundColor = UIColor.clear
		
		let gameclear = UIImageView(frame: CGRect(x: 0, y: 0, width: 539, height: 277))
		gameclear.contentMode = .scaleAspectFit
		gameclear.image = UIImage(named: "gameclear_anim_logo.png")
		base.addSubview(gameclear)
		gameclear.center = CGPoint(x: base.frame.size.width/2, y: base.frame.size.height/2)
		gameclear.transform = CGAffineTransform(scaleX: 0, y: 0)
		UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseInOut, animations: { 
			gameclear.transform = CGAffineTransform(scaleX: 1, y: 1)
		}) { (stop) in
			UIView.animate(withDuration: 0.25, delay: 3.0, options: .curveEaseInOut, animations: { 
				gameclear.alpha = 0
			}) { (stop) in
				base.removeFromSuperview()
				
				self.charaBaseView.isHidden = true
				let clear = GameClearView.gameClearView()
				self.view.addSubview(clear)
				clear.closeHandler = {[weak self](res) in
					self?.isGameEnd = false
					self?.charaBaseView.isHidden = false
					switch res {
					case .next:				//次の問題へ進む
						self?.nextQuest()
					case .select:			//セレクト画面に戻る
						self?.remove()
					case .dict:				//辞書モードで復習！
						print("辞書モードで復習！")
					}
				}
			}
		}
		
	}
	//MARK: ゲームオーバー
	func gameOver() {
		if isGameEnd {
			return
		}
		isGameEnd = true
		self.gameTimer?.invalidate()
		self.gameTimer = nil
		
		let base = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
		self.view.addSubview(base)
		base.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
		base.backgroundColor = UIColor.clear
		
		let gameover = UIImageView(frame: CGRect(x: 0, y: 0, width: 590, height: 87))
		gameover.contentMode = .scaleAspectFit
		gameover.image = UIImage(named: "gameover_anim_word.png")
		base.addSubview(gameover)
		gameover.center = CGPoint(x: base.frame.size.width/2, y: -gameover.frame.size.height)
		
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
				let over = GameOverView.gameOverView()
				s.view.addSubview(over)
				over.closeHandler = {[weak self](res) in
					self?.isGameEnd = false
					self?.charaBaseView.isHidden = false
					switch res {
					case .retry:				//やりなおす
						self?.retry()
					case .timeDouble:			//Timeを倍にする（動画）
						print("Timeを倍にする（動画）")
					case .next:					//次の問題へ進む（動画）
						print("Timeを倍にする（動画）")
					case .giveup:				//諦める
						self?.remove()
					}
				}
			}
		}
		
//		let animation = CAKeyframeAnimation(keyPath: "position.y")
//		animation.duration = 0.75
//		animation.keyTimes = [0.0, 0.5, 0.85, 0.95]
//		animation.values = [
//			base.frame.size.height/2,
//			base.frame.size.height/2 + 10,
//			base.frame.size.height/2,
//			base.frame.size.height/2 + 5,
//			base.frame.size.height/2,
//		]
//		gameover.layer.add(animation, forKey: nil)
		
	}
}
