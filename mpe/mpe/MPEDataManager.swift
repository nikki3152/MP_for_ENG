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
let kSelectedCharaType: String = "kSelectedCharaType"
let kHiscore: String = "kHiscore"

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

