//
//  DictViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class DictViewController: BaseViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

	let dataMrg: MPEDataManager = MPEDataManager()
	
	class func dictViewController() -> DictViewController {
		
		let storyboard = UIStoryboard(name: "DictViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! DictViewController
		return baseCnt
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		selectedButton = biginnerButton
		selectedTag = selectedButton.tag 
	}
	
	//戻る
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		self.remove()
	}
	
	
	@IBOutlet weak var wordListTableView: UITableView!
	@IBOutlet weak var wordInfoTableView: UITableView!
	@IBOutlet weak var selectedWordLabel: UILabel!
	
	var _selectedTag: Int = 1
	var selectedTag: Int {
		get {
			return _selectedTag
		}
		set {
			_selectedTag = newValue
			textField.text = nil
			
			var name = ""
			if _selectedTag == 1 {
				name = "quiz_bigginer"
			}
			else if _selectedTag == 2 {
				name = "quiz_intermediate"
			}
			else if _selectedTag == 3 {
				name = "quiz_advanced"
			}
			else if _selectedTag == 4 {
				name = "quiz_god"
			}
			wordList = dataMrg.loadQuickQuest(name: name)
			selectedWordIndex = nil
			wordListTableView.reloadData()
			selectedWordLabel.text = nil
			wordInfoList = []
			wordInfoTableView.reloadData()
			
		}
	}
	
	weak var selectedButton: UIButton! 
	@IBOutlet weak var biginnerButton: UIButton!
	@IBOutlet weak var intermediateButton: UIButton!
	@IBOutlet weak var advancedButton: UIButton!
	@IBOutlet weak var godButton: UIButton!
	@IBAction func buttonAction(_ sender: UIButton) {
		
		selectedButton.isEnabled = true
		selectedButton = sender
		selectedButton.isEnabled = false
		selectedTag = selectedButton.tag 
	}
	
	var selectedWordIndex: Int?
	var wordList: [String] = []
	var wordInfoList: [String] = []
	
	//MARK: - UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView.tag == 0 {
			return wordList.count
		} else {
			return wordInfoList.count
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
		if cell == nil {
			cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
			cell.backgroundColor = UIColor.clear
			cell.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
			cell.textLabel?.minimumScaleFactor = 0.5
		}
		if tableView.tag == 0 {
			let text = self.wordList[indexPath.row]
			cell.textLabel?.text = text
			if let index = selectedWordIndex, index == indexPath.row {
				cell.textLabel?.textColor = UIColor.red
			} else {
				cell.textLabel?.textColor = UIColor.black
			}
		} else {
			let text = self.wordInfoList[indexPath.row]
			cell.textLabel?.text = text
		}
		return cell
	}
	
	//MARK: - UITableViewDelegate
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
		if tableView.tag == 0 {
			selectedWordIndex = indexPath.row
			wordListTableView.reloadData()
			let text = self.wordList[indexPath.row]
			selectedWordLabel.text = text
			let listH = dataMrg.search(word: text.lowercased(), match: .perfect)
			if listH.count > 0 {
				if let infos = listH[0][text] {
					wordInfoList = infos
					wordInfoTableView.reloadData()
				}
			}
		}
	}
	
	
	
	//MARK: UITextFieldDelegate
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		textField.resignFirstResponder()
		
		return true
	}
	
	
	@IBOutlet weak var textField: UITextField!
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		
		if let text = textField.text {
			for i in 0 ..< wordList.count {
				let word = wordList[i]
				if word == text.lowercased() {
					selectedWordIndex = i
					wordListTableView.selectRow(at: IndexPath(row: i, section: 0), animated: false, scrollPosition: .middle)
					//wordListTableView.reloadData()
					selectedWordLabel.text = text
					let listH = dataMrg.search(word: text.lowercased(), match: .perfect)
					if listH.count > 0 {
						if let infos = listH[0][text] {
							wordInfoList = infos
							wordInfoTableView.reloadData()
						}
					}
					break
				}
			} 
		}
	}
}
