//
//  EditViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/10/31.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UIScrollViewDelegate, GameTableViewDelegate, FontCardViewDelegate, UITableViewDataSource, UITableViewDelegate {
	
	let mojiList: [String] = [
		"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
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
		
		return cell
	}
	
	//MARK: - UITableViewDelegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		
	}

	var questData: QuestData!
	var cardSelectIndex: Int!
	var gameTable: GameTableView!
	
	class func editViewController(questData: QuestData) -> EditViewController {
		
		let storyboard = UIStoryboard(name: "GameViewController", bundle: nil)
		let baseCnt = storyboard.instantiateViewController(withIdentifier: "EditView") as! EditViewController
		baseCnt.questData = questData
		return baseCnt
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        self.segment.tintColor = UIColor.white
    }
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		//手札
		self.updateCardScroll()
		//ゲームテーブル
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
	
	
	@IBOutlet weak var mojiTableView: UITableView!
	@IBOutlet weak var mainScrollView: UIScrollView!
	
	@IBOutlet weak var doneButton: UIButton!
	@IBAction func doneButtonAction(_ sender: Any) {
		
		self.dismiss(animated: true) { 
			
		}
	}
	
	@IBOutlet weak var closeButton: UIButton!
	@IBAction func closeButtonAction(_ sender: Any) {
		
		self.dismiss(animated: true) { 
			
		}
	}
	
	//手札
	var cardViewList: [FontCardView] = []
	@IBOutlet weak var cardScrolliew: UIScrollView!
	
	func updateCardScroll() {
		
		for v in self.cardScrolliew.subviews {
			v.removeFromSuperview()
		}
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
	
	
	@IBOutlet weak var segment: UISegmentedControl!
	
	@IBOutlet weak var addButton: UIButton!
	@IBAction func addButtonAction(_ sender: Any) {
	}
	
	
	//MARK:- UIScrollViewDelegate
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		
		return self.gameTable
	}
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		
		
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
	
	//MARK: - GameTableViewDelegate
	func gameTableViewToucheDown(table: GameTableView, koma: TableKomaView) {
		
		
	}
	func gameTableViewToucheUp(table: GameTableView, koma: TableKomaView) {
		
		let moji = self.questData.table[koma.tag]
		print("\(moji)")
		if moji == " " {
			self.questData.table[koma.tag] = "0"
			koma.alpha = 1.0
		}
		else if moji == "0" {
			self.questData.table[koma.tag] = " "
			koma.alpha = 0.5
		}
	}
	
	
}
