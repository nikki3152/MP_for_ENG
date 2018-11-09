//
//  EditViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/10/31.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UIScrollViewDelegate, GameTableViewDelegate, FontCardViewDelegate, UITableViewDataSource, UITableViewDelegate {
	
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
   }
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		if isLaunch == false {
			isLaunch = true
			self.update()
		}
	}
	
	
	@IBOutlet weak var mojiTableView: UITableView!
	@IBOutlet weak var mainScrollView: UIScrollView!
	
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
			for _ in 0 ..< count {
				self.questData.table.append(" ")
			}
			self.questData.cards = []
			
			self.update()
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
			self.cardViewList.append(cardView)
		}
		self.cardScrolliew.contentSize = CGSize(width: CGFloat(self.questData.cards.count) * 50, height: self.cardScrolliew.frame.size.height / 2)
		
	}
	
	
	
	
	//MARK: 追加
	@IBOutlet weak var addButton: UIButton!
	@IBAction func addButtonAction(_ sender: Any) {
		
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
		
	}
	
	
	//MARK:- UIScrollViewDelegate
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		
		return self.gameTable
	}
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		
		
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
		
		let mojiTbl = self.mojiList[self.mojiSelectIndex]
		if mojiTbl == "null" {
			koma.frontImageView.image = nil
			self.questData.table[koma.tag] = " "
			koma.alpha = 0.5
		}
		else if mojiTbl == "table" {
			koma.frontImageView.image = nil
			self.questData.table[koma.tag] = "0"
			koma.alpha = 1.0
		}
		else {
			koma.frontImageView.image = UIImage(named: mojiTbl)
			self.questData.table[koma.tag] = mojiTbl
			koma.alpha = 1.0
		}
	}
	
	
}
