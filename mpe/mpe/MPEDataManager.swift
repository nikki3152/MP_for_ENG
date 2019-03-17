//
//  MPEDataManager.swift
//  mpe
//
//  Created by 北村 真二 on 2018/08/20.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

//初期設定
let kBGMOn: String = "kBGMOn"
let kSEOn: String = "kSEOn"
let kVoiceOn: String = "kVoiceOn"
let kEnableCharaArry: String = "kEnableCharaArry"
let kEnableStageArry: String = "kEnableStageArry"
let kEnableDictionary: String = "kEnableDictionary"
let kSelectedCharaType: String = "kSelectedCharaType"
//let kHiscore: String = "kHiscore"
let kStageHiscores: String = "kStageHiscores"
let kPPPoint: String = "kPPPoint"
let kCurrentQuestIndex: String = "kCurrentQuestIndex"

//データ集計
let kTotalScore: String = "kTotalScore"
let kAlllPlayTimes: String = "kAlllPlayTimes"
let kGameClearCount: String = "kGameClearCount"
let kGameOverCount: String = "kGameOverCount"
let kGameWordsCount: String = "kGameWordsCount"

let kRandomWordPlayCount: String = "kRandomWordPlayCount"
let kRandomWordClearCount: String = "kRandomWordClearCount"
let kRandomScorePlayCount: String = "kRandomScorePlayCount"
let kRandomScoreClearCount: String = "kRandomScoreClearCount"

let kQuickBiginnerTimes: String = "kQuickBiginnerTimes"
let kQuickBiginnerCount: String = "kQuickBiginnerCount"
let kQuickBiginnerCorrectCount: String = "kQuickBiginnerCorrectCount"
let kQuickIntermediateTimes: String = "kQuickIntermediateTimes"
let kQuickIntermediateCount: String = "kQuickIntermediateCount"
let kQuickIntermediateCorrectCount: String = "kQuickIntermediateCorrectCount"
let kQuickAdvancedTimes: String = "kQuickAdvancedTimes"
let kQuickAdvancedCount: String = "kQuickAdvancedCount"
let kQuickAdvancedCorrectCount: String = "kQuickAdvancedCorrectCount"
let kQuickGodTimes: String = "kQuickGodTimes"
let kQuickGodCount: String = "kQuickGodCount"
let kQuickGodCorrectCount: String = "kQuickGodCorrectCount"
let kQuickRandomTimes: String = "kQuickRandomTimes"
let kQuickRandomCount: String = "kQuickRandomCount"
let kQuickRandomCorrectCount: String = "kQuickRandomCorrectCount"

let kUsedFontDict: String = "kUsedFontDict"


//アプリ内課金プロダクトID
let kProductID10: String = "mpe"
let kProductID50: String = "mpe50"
let kProductID100: String = "mpe100"

enum CustomChara: String {
	case mojikun_b		= "mojikun_b"		//もじくん（新）
	case mojichan		= "mojichan"		//もじちゃん
	case taiyokun		= "taiyokun"		//太陽
	case tsukikun		= "tsukikun"		//月
	case kumokun		= "kumokun"			//雲
	case mojikun_a		= "mojikun_a"		//もじくん（旧）
	case pack			= "pack"			//パックマン
	case ouji			= "ouji"			//王子
	case driller		= "driller"			//ドリラー
	case galaga			= "galaga"			//ギャラガ
	
}


enum MatchType: Int {
	case perfect			//完全一致
	case foward				//前方一致
	case contains			//単語を含む
}

class MPEDataManager: DataManager {
	
	class func mojiValue(c: String) -> Int {
		
		let cc = c.lowercased()
		var value: Int = 0
		if cc == "a" || cc == "e" || cc == "i" || cc == "l" || cc == "n" || cc == "o" || cc == "r" || cc == "s" || cc == "t" || cc == "u" {
			value = 1
		}
		else if cc == "d" || cc == "g" {
			value = 2
		}
		else if cc == "b" || cc == "c" || cc == "m" || cc == "p" {
			value = 3
		}
		else if cc == "f" || cc == "h" || cc == "v" || cc == "w" || cc == "y" {
			value = 4 
		}
		else if cc == "k" {
			value = 5 
		}
		else if cc == "j" || cc == "x" {
			value = 8 
		}
		else if cc == "q" || cc == "z" {
			value = 10 
		}
		return value
	}
	
	class func updatePP(pp: Int) {
		
		var setPP = pp
		if setPP > 100 {
			setPP = 100
		}
		UserDefaults.standard.set(setPP, forKey: kPPPoint)
		if setPP >= 100 {
			var stageFlgs = UserDefaults.standard.object(forKey: kEnableStageArry) as! [Bool]
			stageFlgs[0] = true		//初級
			stageFlgs[20] = true	//中級
			stageFlgs[40] = true	//上級
			stageFlgs[60] = true	//神級
			stageFlgs[80] = true	//ランダム
			UserDefaults.standard.set(stageFlgs, forKey: kEnableStageArry)
			UserDefaults.standard.set(true, forKey: kEnableDictionary)
		}
		else if setPP >= 90 {
			var stageFlgs = UserDefaults.standard.object(forKey: kEnableStageArry) as! [Bool]
			stageFlgs[0] = true		//初級
			stageFlgs[20] = true	//中級
			stageFlgs[40] = true	//上級
			stageFlgs[60] = true	//神級
			UserDefaults.standard.set(stageFlgs, forKey: kEnableStageArry)
			UserDefaults.standard.set(true, forKey: kEnableDictionary)
		}
		else if setPP >= 80 {
			var stageFlgs = UserDefaults.standard.object(forKey: kEnableStageArry) as! [Bool]
			stageFlgs[0] = true		//初級
			stageFlgs[20] = true	//中級
			stageFlgs[40] = true	//上級
			stageFlgs[60] = true	//神級
			UserDefaults.standard.set(stageFlgs, forKey: kEnableStageArry)
			UserDefaults.standard.set(true, forKey: kEnableDictionary)
		}
		else if setPP >= 60 {
			var stageFlgs = UserDefaults.standard.object(forKey: kEnableStageArry) as! [Bool]
			stageFlgs[0] = true		//初級
			stageFlgs[20] = true	//中級
			stageFlgs[40] = true	//上級
			stageFlgs[60] = true	//神級
			UserDefaults.standard.set(stageFlgs, forKey: kEnableStageArry)
		}
		else if setPP >= 40 {
			var stageFlgs = UserDefaults.standard.object(forKey: kEnableStageArry) as! [Bool]
			stageFlgs[0] = true		//初級
			stageFlgs[20] = true	//中級
			stageFlgs[40] = true	//上級
			UserDefaults.standard.set(stageFlgs, forKey: kEnableStageArry)
		}
		else if setPP >= 20 {
			var stageFlgs = UserDefaults.standard.object(forKey: kEnableStageArry) as! [Bool]
			stageFlgs[0] = true		//初級
			stageFlgs[20] = true	//中級
			UserDefaults.standard.set(stageFlgs, forKey: kEnableStageArry)
		}
		else if setPP == 0 {
			var stageFlgs = UserDefaults.standard.object(forKey: kEnableStageArry) as! [Bool]
			for i in 1 ..< stageFlgs.count {
				stageFlgs[i] = false
			}
			UserDefaults.standard.set(stageFlgs, forKey: kEnableStageArry)
			UserDefaults.standard.set(false, forKey: kEnableDictionary)
		}
	}
	
	class func loadStringList(name: String, type: String) -> [String] {
		
		var ret: [String] = []
		if let path = Bundle.main.path(forResource: name, ofType: type) {
			let url = URL(fileURLWithPath: path)
			guard let data = try? Data(contentsOf: url) else { return ret}
			if let t = String(bytes: data, encoding: .utf8) {
				let records = t.components(separatedBy: .newlines)
				for str in records {
					if str.count > 0 {
						ret.append(str)
					}
				}
			}
		}
		return ret
	}
	
	func loadQuickQuest(name: String) -> [String] {
		
		var ret: [String] = []
		if let path = Bundle.main.path(forResource: name, ofType: "txt") {
			let url = URL(fileURLWithPath: path)
			guard let data = try? Data(contentsOf: url) else { return ret}
			if let t = String(bytes: data, encoding: .utf8) {
				let records = t.components(separatedBy: .newlines)
				for str in records {
					if str.count > 0 {
						ret.append(str)
					}
				}
			}
		}
		return ret
	}
	
	func loadAllDBWord() -> [String] {
		
		var ret: [String] = []
		let ary = self.load(arrayName: "wordlist.plist", dir: "database")
		if let list = ary as? [String] {
			ret = list
		} else {
			let mojis = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
			for moji in mojis {
				if let dic = self.load(name: "\(moji).plist", dir: "database") {
					let keys = dic.keys
					for key in keys {
						ret.append(key)
					}
				}
			}
			if self.save(array: ret, name: "wordlist.plist", dir: "database") {
				print("単語リスト保存")
			}
		}
		return ret
	}
	
	func loadJsonDB() -> [String:[String]] {
		
		var db: [String:[String]] = [:]
		if let path = Bundle.main.path(forResource: "ejdic-hand-utf8", ofType: "txt") {
			let url = URL(fileURLWithPath: path)
			guard let data = try? Data(contentsOf: url) else { return [:] }
			if let t = String(bytes: data, encoding: .utf8) {
				let records = t.components(separatedBy: "\n")
				for dic in records {
					let dict = dic.components(separatedBy: "\t")
					let word = dict[0].lowercased()
					if dict.count > 1 {
						let contents = dict[1].components(separatedBy: "/")
						db[word] = contents
					} else {
						db[word] = []
					}
				}
			}
		}
		return db
	}
	func makeDB() {
		
		let db = self.loadJsonDB()
		let keys = db.keys
		let mojis = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
		for moji in mojis {
			var aDic: [String:[String]] = [:]
			for key in keys {
				if key.hasPrefix(moji) {
					if let value = db[key] {
						aDic[key] = value
					}
				}
			}
			if self.save(dict: aDic, name: "\(moji).plist", dir: "database") {
				do {
					let jsonData = try JSONSerialization.data(withJSONObject: aDic, options: [])
					self.saveData(name: "\(moji).json", subPath: "database", data: jsonData)
				}
				catch let error {
					print("\(error.localizedDescription)")
				}
			}
		}
	}
	// mode: 0=完全一致 1=前方一致 2=wordを含む 
	func search(word: String, match: MatchType) -> [[String:[String]]] {
		
		let searchWord = word.lowercased()
		var ret: [[String:[String]]] = []
		//先頭１文字
		let moji = String(searchWord.prefix(1))
		if let dic = self.load(name: "\(moji).plist", dir: "database") {
			if match == .perfect {
				if let value = dic[searchWord] as? [String] {
					var d: [String:[String]] = [:]
					d[searchWord] = value
					ret.append(d)
				}
			} else {
				let keys = dic.keys
				for key in keys {
					if match == .foward {
						//wordが先頭
						if key.hasPrefix(word) {
							if let value = dic[key] as? [String] {
								var d: [String:[String]] = [:]
								d[key] = value
								ret.append(d)
							}
						}
					} else if match == .contains {
						//wordを含む
						if key.contains(searchWord) {
							if let value = dic[key] as? [String] {
								var d: [String:[String]] = [:]
								d[key] = value
								ret.append(d)
							}
						}
					}
				}
			}
		}
		return ret
	}
	
	func questList(mode: String) -> [[String:String]] {
		
		var ret:  [[String:String]] = []
		if let path = Bundle.main.path(forResource: "QuestList_\(mode)", ofType: "plist") {
			if let ary = NSArray(contentsOfFile: path) {
				ret = ary as! [[String : String]]
			}
		}
		return ret
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

