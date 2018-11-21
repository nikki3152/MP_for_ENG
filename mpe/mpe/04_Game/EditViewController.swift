//
//  EditViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/10/31.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UIScrollViewDelegate, GameTableViewDelegate, FontCardViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
	
	var finishedHandler: ((_ questData: QuestData) -> Void)?
	
	var mojiSelectIndex: Int = 0
	let mojiList: [String] = [
		"null","table","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
	]
	
	//MARK: - UITableViewDataSource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return mojiList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
		if cell == nil {
			cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
		}
		let moji = self.mojiList[indexPath.row]
		cell.imageView?.image = UIImage(named: moji)
		if mojiSelectIndex == indexPath.row {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
		return cell
	}
	
	//MARK: - UITableViewDelegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		self.mojiSelectIndex = indexPath.row
		tableView.reloadData()
		
		let moji = self.mojiList[self.mojiSelectIndex]
		if moji == "table" || moji == "null" {
			self.addButton.isEnabled = false
			self.addButton.alpha = 0.25
		} else {
			self.addButton.isEnabled = true
			self.addButton.alpha = 1.0
		}
		
	}
	
	//MARK: -
	
	var isLaunch = false
	
	var questData: QuestData!
	var gameTable: GameTableView!
	
	class func editViewController(questData: QuestData) -> EditViewController {
		
		let storyboard = UIStoryboard(name: "GameViewController", bundle: nil)
		let baseCnt = storyboard.instantiateViewController(withIdentifier: "EditView") as! EditViewController
		baseCnt.questData = questData
		return baseCnt
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        self.deleteButton.isEnabled = false
		self.deleteButton.alpha = 0.25
		
		self.addButton.isEnabled = false
		self.addButton.alpha = 0.25
		
		self.updateInfo()
   }
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		if isLaunch == false {
			isLaunch = true
			self.update()
			self.titleTextField.text = self.questData.questName
			self.set(time: self.questData.time)
		}
	}
	
	
	@IBOutlet weak var mojiTableView: UITableView!
	@IBOutlet weak var mainScrollView: UIScrollView!
	@IBOutlet weak var infoLabel: UILabel!
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var timeLabel: UILabel!
	
	@IBOutlet weak var cardTypeSegment: UISegmentedControl!
	
	
	//MARK: 時間
	@IBOutlet weak var timeButton: UIButton!
	@IBAction func timeButtonAction(_ sender: Any) {
		
		let picker = TimePickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
		self.view.addSubview(picker)
		picker.handler = {(time) in
			self.questData.time = time
			self.set(time: time)
		}
		picker.set(time: self.questData.time)
	}
	func set(time: Double) {
		
		let t = Int(time)
		if t == 0 {
			self.timeLabel.text = "無制限"
		} else {
			let m = t / 60
			let s = t - (m * 60)
			let min = NSString(format: "%02d", m) 
			let sec = NSString(format: "%02d", s) 
			self.timeLabel.text = "\(min):\(sec)"
		}
	}
	
	
	//MARK: 保存
	@IBOutlet weak var saveButton: UIButton!
	@IBAction func saveButtonAction(_ sender: Any) {
		
		let saveView = SaveViewController.saveViewController()
		saveView.view.bounds = UIScreen.main.bounds
		self.view.addSubview(saveView.view)
		self.addChildViewController(saveView)
		saveView.handler = {(name) in
			let dict = self.questData.dict()
			let base_path = DataManager().docPath!
			let path = base_path + "/" + name + ".plist"
			if (dict as NSDictionary).write(toFile: path, atomically: true) {
				print("問題保存成功！")
			} else {
				print("問題保存失敗！")
			}
		}
		saveView.textField.text = self.questData.filename
		
	}
	//MARK: 読み込み
	@IBOutlet weak var loadButton: UIButton!
	@IBAction func loadButtonAction(_ sender: Any) {
		
		let loadView = LoadViewController.loadViewController()
		self.present(loadView, animated: true, completion: nil)
		loadView.handler = {(path) in
			if let dic = NSDictionary(contentsOfFile: path) as? [String:Any] {
				self.questData = QuestData(dict: dic)
				self.update()
				self.titleTextField.text = self.questData.questName
				self.set(time: self.questData.time)
				let filename = (path as NSString).lastPathComponent
				let name = filename.split(separator: ".")[0]
				self.questData.filename = String(name)
				self.updateInfo()
			} else {
				print("問題読み込み失敗！")
			}
		}
	}
	//MARK: 閉じる
	@IBOutlet weak var closeButton: UIButton!
	@IBAction func closeButtonAction(_ sender: Any) {
		
		self.dismiss(animated: true) { 
			
		}
	}
	
	//MARK: 完了
	@IBOutlet weak var doneButton: UIButton!
	@IBAction func doneButtonAction(_ sender: Any) {
		
		if let txt = self.titleTextField.text {
			self.questData.questName = txt
		}
		self.finishedHandler?(self.questData)
		self.finishedHandler = nil
		self.dismiss(animated: true) { 
			
		}
	}
	
	//MARK: 初期化
	@IBOutlet weak var clearButton: UIButton!
	@IBAction func clearButtonAction(_ sender: UIButton) {
		
		let picker = EditPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
		self.view.addSubview(picker)
		picker.leftPicker.selectRow(self.questData.width - 8, inComponent: 0, animated: false)
		picker.rightPicker.selectRow(self.questData.height - 8, inComponent: 0, animated: false)
		picker.handler = {(w,h) in
			self.mojiSelectIndex = 0
			self.cardSelectIndex = nil
			
			self.questData.width = w
			self.questData.height = h
			let count = w * h
			self.questData.table = []
			self.questData.tableType = []
			for _ in 0 ..< count {
				self.questData.table.append(" ")
				self.questData.tableType.append(" ")
			}
			self.questData.cards = []
			
			self.update()
			
		}
	}
	
	//MARK: クリア条件
	@IBOutlet weak var conditionsButton: UIButton!
	@IBAction func conditionsButtonAction(_ sender: Any) {
		
		let picker = ConditionsPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
		self.view.addSubview(picker)
		picker.handler = {(type, data) in
			self.questData.questType = QuestType(rawValue: type)!
			self.questData.questData = data
			self.updateInfo()
		}
		
		
		let type = self.questData.questType.rawValue
		picker.leftPicker.selectRow(type, inComponent: 0, animated: false)
		picker.updateRightPicker(row: type)
		if type == 0 {
			let count = self.questData.questData["count"] as! Int
			picker.rightPicker.selectRow(count - 1, inComponent: 0, animated: false)
		}
		else if type == 3 {
			let words = self.questData.questData["words"] as! Int
			let count = self.questData.questData["count"] as! Int
			picker.rightPicker.selectRow(words - 1, inComponent: 0, animated: false)
			picker.rightPicker.selectRow(count - 1, inComponent: 1, animated: false)
		}
		else if type == 4 {
			let score = self.questData.questData["count"] as! Int / 1000
			picker.rightPicker.selectRow(score - 1, inComponent: 0, animated: false)
		}
		else if type == 5 {
			var fontIndex = 0
			let fonts = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
			let font = self.questData.questData["font"] as! String
			for f in fonts {
				if font == f {
					break
				}
				fontIndex += 1
			}
			let count = self.questData.questData["count"] as! Int
			picker.rightPicker.selectRow(fontIndex, inComponent: 0, animated: false)
			picker.rightPicker.selectRow(count - 1, inComponent: 1, animated: false)
		}
	}
	
	
	//MARK: 手札
	var cardSelectIndex: Int!
	var cardViewList: [FontCardView] = []
	@IBOutlet weak var cardScrolliew: UIScrollView!
	
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
	
	//テーブルタイプ選択セグメント
	@IBOutlet weak var typeSegment: UISegmentedControl!
	
	
	//MARK: 追加
	@IBOutlet weak var addButton: UIButton!
	@IBAction func addButtonAction(_ sender: Any) {
		
		if self.cardTypeSegment.selectedSegmentIndex == 0 {
			//通常
			let moji = self.mojiList[self.mojiSelectIndex]
			if moji != "table" && moji != "null" {
				if let index = cardSelectIndex {
					self.questData.cards.insert(moji, at: index)
					self.updateCardScroll()
					let card = cardViewList[index]
					card.isSelected = true
					
				} else {
					self.questData.cards.append(moji)
					self.updateCardScroll()
					let x = self.cardScrolliew.contentSize.width - self.cardScrolliew.bounds.size.width
					self.cardScrolliew.setContentOffset(CGPoint(x: x, y: 0), animated: true)
				}
			}
		} else {
			//ワイルドカード
			let moji = self.mojiList[self.mojiSelectIndex]
			if moji != "table" && moji != "null" {
				self.questData.cards.insert(moji, at: 0)
				self.questData.wildCardLen += 1
				self.updateCardScroll()
				let card = cardViewList[0]
				card.isSelected = true
			}
		}
		
	}
	//MARK: 削除
	@IBOutlet weak var deleteButton: UIButton!
	@IBAction func deleteButtonAction(_ sender: Any) {
		
		if let index = cardSelectIndex {
			self.questData.cards.remove(at: index)
			self.updateCardScroll()
			self.cardSelectIndex = nil
			self.deleteButton.isEnabled = false
			self.deleteButton.alpha = 0.25
		}
	}
	
	
	
	func update() {
		
		//手札
		self.updateCardScroll()
		//ゲームテーブル
		for v in self.mainScrollView.subviews {
			v.removeFromSuperview()
		}
		self.gameTable = GameTableView.gameTableView(size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height), 
													 width: self.questData.width, 
													 height: self.questData.height,
													 cellTypes: self.questData.table,
													 types: self.questData.tableType,
													 edit: true)
		let size = self.gameTable.frame.size
		self.gameTable.delegate = self
		self.mainScrollView.addSubview(self.gameTable)
		self.mainScrollView.contentSize = CGSize(width: self.gameTable.frame.size.width, height: self.gameTable.frame.size.height)
		self.mainScrollView.maximumZoomScale = 2.0
		self.mainScrollView.minimumZoomScale = 1.0
		self.mainScrollView.zoomScale = 1.0
		self.mainScrollView.contentOffset = CGPoint(x: size.width / 4, y: size.height / 4)
		self.view.sendSubview(toBack: self.mainScrollView)
		
		self.updateInfo()
	}
	
	
	func updateInfo() {
		
		var count: Int = 0
		if let v = self.questData.questData["count"] as? Int {
			count = v
		}
		var words: Int = 0
		if let v = self.questData.questData["words"] as? Int {
			words = v
		}
		var font: String = ""
		if let v = self.questData.questData["font"] as? String {
			font = v
		}
		let text = self.questData.questType.info(count: count, words: words, font: font)
		self.infoLabel.text = text
	}
	
	//MARK:- UIScrollViewDelegate
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		
		return self.gameTable
	}
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		
		
	}
	
	
	//MARK: - UITextFieldDelegate
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		textField.resignFirstResponder()
		return true
	}
	
	//MARK:- FontCardViewDelegate
	
	func fontCardViewTap(font: FontCardView) {
		
		if self.cardSelectIndex != nil && self.cardSelectIndex == font.tag {
			self.cardSelectIndex = nil
		} else {
			self.cardSelectIndex = font.tag
		}
		for cardView in self.cardViewList {
			if self.cardSelectIndex != nil {
				if cardView.tag == self.cardSelectIndex {
					cardView.isSelected = true
				} else {
					cardView.isSelected = false
				}
			} else {
				cardView.isSelected = false
			}
		}
		if self.cardSelectIndex == nil {
			self.deleteButton.isEnabled = false
			self.deleteButton.alpha = 0.25
		} else {
			self.deleteButton.isEnabled = true
			self.deleteButton.alpha = 1.0
		}
	}
	
	//MARK: - GameTableViewDelegate
	func gameTableViewToucheDown(table: GameTableView, koma: TableKomaView) {
		
		
	}
	func gameTableViewToucheUp(table: GameTableView, koma: TableKomaView) {
		
		var type: String = " "
		if self.typeSegment.selectedSegmentIndex == 1 {
			type = "DL"
		}
		else if self.typeSegment.selectedSegmentIndex == 2 {
			type = "TL"
		}
		else if self.typeSegment.selectedSegmentIndex == 3 {
			type = "DW"
		}
		else if self.typeSegment.selectedSegmentIndex == 4 {
			type = "TW"
		}
		let mojiTbl = self.mojiList[self.mojiSelectIndex]
		if mojiTbl == "null" {
			koma.frontImageView.image = nil
			koma.typeImageView.image = nil
			self.questData.table[koma.tag] = " "
			self.questData.tableType[koma.tag] = " "
			koma.alpha = 0.5
		}
		else if mojiTbl == "table" {
			koma.frontImageView.image = nil
			self.questData.table[koma.tag] = "0"
			self.questData.tableType[koma.tag] = type
			koma.alpha = 1.0
		}
		else {
			koma.frontImageView.image = UIImage(named: mojiTbl)
			self.questData.table[koma.tag] = mojiTbl
			self.questData.tableType[koma.tag] = type
			koma.alpha = 1.0
		}
		
		if mojiTbl != "null" {
			var image: UIImage?
			if type == "DL" {
				image = UIImage(named: "double_letter_score")
			}
			else if type == "TL" {
				image = UIImage(named: "triple_letter_score")
			}
			else if type == "DW" {
				image = UIImage(named: "double_word_score")
			}
			else if type == "TW" {
				image = UIImage(named: "triple_word_score")
			}
			koma.typeImageView.image = image
		}
	}
	
	
}
