//
//  MPEDataManager.swift
//  mpe
//
//  Created by 北村 真二 on 2018/08/20.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

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
	func search(word: String, mode: Int) -> [[String:[String]]] {
		
		var ret: [[String:[String]]] = []
		//先頭１文字
		let moji = String(word.prefix(1))
		if let dic = self.load(name: "\(moji).plist", dir: "database") {
			if mode == 0 {
				if let value = dic[word] as? [String] {
					var d: [String:[String]] = [:]
					d[word] = value
					ret.append(d)
				}
			} else {
				let keys = dic.keys
				for key in keys {
					if mode == 1 {
						//wordが先頭
						if key.hasPrefix(word) {
							if let value = dic[key] as? [String] {
								var d: [String:[String]] = [:]
								d[key] = value
								ret.append(d)
							}
						}
					} else if mode == 2 {
						//wordを含む
						if key.contains(word) {
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
}
