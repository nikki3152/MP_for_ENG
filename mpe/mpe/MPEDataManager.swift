//
//  MPEDataManager.swift
//  mpe
//
//  Created by 北村 真二 on 2018/08/20.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

enum MatchType: Int {
	case perfect			//完全一致
	case foward				//前方一致
	case contains			//単語を含む
}

class MPEDataManager: DataManager {
	
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
	
	func questList() -> [[String:String]] {
		
		var ret:  [[String:String]] = []
		
		if let path = Bundle.main.path(forResource: "QuestList", ofType: "plist") {
			if let ary = NSArray(contentsOfFile: path) {
				ret = ary as! [[String : String]]
			}
		}
		return ret
	}
}
