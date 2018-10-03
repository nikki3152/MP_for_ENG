//
//  GameViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

struct QuestData {
	var width: Int = 8
	var height: Int = 8
	var table: [String] = [
		"0","0","0","0","0","0","0","0",
		"0","0","0","0","0","0","0","0",
		"0","0","0","0","0","0","0","0",
		"0","0","0","0","0","0","0","0",
		"0","0","0","0","0","0","0","0",
		"0","0","0","0","0","0","0","0",
		"0","0","0","0","0","0","0","0",
		"0","0","0","0","0","0","0","0",]
	var cards: [String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
	init() {
		
	}
	init(w: Int, h: Int, table: [String], cards: [String]) {
		self.width = w
		self.height = h
		self.table = table
		self.cards = cards
	}
}

class GameViewController: BaseViewController, UIScrollViewDelegate, GameTableViewDelegate, FontCardViewDelegate {
	
	let dataMrg = MPEDataManager()
	var questData: QuestData!
	var cardSelectIndex: Int!
	
	class func gameViewController(questData: QuestData) -> GameViewController {
		
		let storyboard = UIStoryboard(name: "GameViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! GameViewController
		baseCnt.questData = questData 
		return baseCnt
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

    }
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		if self.gameTable == nil {
			
			//手札
			self.updateCardScroll()
			//ゲームテーブル
			self.gameTable = GameTableView.gameTableView(size: CGSize(width: self.mainScrollView.frame.size.width, height: self.mainScrollView.frame.size.height), 
														 width: self.questData.width, 
														 height: self.questData.height,
														 cellTypes: self.questData.table)
			let size = self.gameTable.frame.size
			self.gameTable.delegate = self
			self.mainScrollView.addSubview(self.gameTable)
			self.mainScrollView.contentSize = CGSize(width: self.gameTable.frame.size.width, height: self.gameTable.frame.size.height)
			self.mainScrollView.maximumZoomScale = 2.0
			self.mainScrollView.minimumZoomScale = 1.0
			self.mainScrollView.zoomScale = 1.0
			self.mainScrollView.contentOffset = CGPoint(x: size.width / 4, y: size.height / 4)
			updateScrollInset()
			self.view.sendSubview(toBack: self.mainScrollView)
			self.view.sendSubview(toBack: self.backImageView)
		}
	}
	
	//背景
	@IBOutlet weak var backImageView: UIImageView!
	
	//問題文
	@IBOutlet weak var questBaseView: UIView!
	@IBOutlet weak var questBaseImageView: UIImageView!
	@IBOutlet weak var questDisplayImageView: UIImageView!
	
	//テーブル
	var gameTable: GameTableView!
	@IBOutlet weak var mainScrollView: UIScrollView!
	
	
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
	
	//スコア
	@IBOutlet weak var scoreBaseView: UIView!
	
	
	
	//戻る
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		
		self.remove()
	}
	
	private func updateScrollInset() {
		
//		mainScrollView.contentInset = UIEdgeInsetsMake(
//			max((mainScrollView.frame.height - self.gameTable.frame.height)/2, 0),
//			max((mainScrollView.frame.width - self.gameTable.frame.width)/2, 0),
//			0,
//			0
//		)
	}
	
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
	
	//横方向の単語検索
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
					startX += 1
				} else {
					break
				}
			}
		} 
		
		return ward
	}
	//縦方向の単語検索
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
					startY += 1
				} else {
					break
				}
			}
		} 
		
		return ward
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
		
		self.mainScrollView.isScrollEnabled = true
		if let index = self.cardSelectIndex {
			let moji = self.questData.cards[index]
			koma.setFont(moji: moji)
			self.questData.table[koma.tag] = moji
			self.questData.cards.remove(at: index)
			for v in self.cardScrolliew.subviews {
				v.removeFromSuperview()
			}
			self.updateCardScroll()
			self.cardSelectIndex = nil
			
			var hitWard: String?
			var infoText: String?
			var list: [[String:[String]]] = []
			//横の検索
			let wordHline = self.checkWordH(startIndex: koma.tag)
			let listH = dataMrg.search(word: wordHline.lowercased(), match: .perfect)
			list += listH
			//縦の検索
			let wordVline = self.checkWordV(startIndex: koma.tag)
			let listV = dataMrg.search(word: wordVline.lowercased(), match: .perfect)
			list += listV
			
			for dic in list {
				let keys = dic.keys
				for key in keys {
					hitWard = key
					print("【\(key)】")
					let values = dic[key]!
					for value in values {
						print(" >\(value)")
						infoText = value
						break
					}
				}
				break
			}
			
			
			if let ward = hitWard, let info = infoText {
				let alert = UIAlertController(title: ward.uppercased(), message: info, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: nil))
				self.present(alert, animated: true, completion: nil)
			}
		}
	}
}
