//
//  GameViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class GameViewController: BaseViewController, UIScrollViewDelegate, GameTableViewDelegate, FontCardViewDelegate {
	
	var tableWCount: Int = 8
	var tableHCount: Int = 8
	var tableCellTypes: [String] = [
		" "," "," "," "," "," "," ","A",
		"I","0","0","0","0","0","0","0",
		" "," "," "," "," "," "," ","0",
		"U","0","0","0","0","0","0","0",
		" "," "," "," "," "," "," ","0",
		"E","0","0","0","0","0","0","0",
		" "," "," "," "," "," "," ","0",
		"O","0","0","0","0","0","0","0",
	]
	
	var cardList: [String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
	var cardSelectIndex: Int!
	
	class func gameViewController() -> GameViewController {
		
		let storyboard = UIStoryboard(name: "GameViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! GameViewController
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
														 width: self.tableWCount, 
														 height: self.tableHCount,
														 cellTypes: self.tableCellTypes)
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
		for i in 0 ..< self.cardList.count {
			let moji = self.cardList[i]
			let cardView = FontCardView.fontCardView(moji: moji)
			cardView.delegate = self
			cardView.tag = i
			self.cardScrolliew.addSubview(cardView)
			//card1.backImageView.image = UIImage(named: "orange_\(i+1)")
			cardView.center = CGPoint(x: (cardView.frame.size.width / 2) + (CGFloat(i) * cardView.frame.size.width), y: self.cardScrolliew.frame.size.height / 2)
			self.cardViewList.append(cardView)
		}
		self.cardScrolliew.contentSize = CGSize(width: CGFloat(self.cardList.count) * 50, height: self.cardScrolliew.frame.size.height / 2)
		
	}
	
	
	//MARK:- FontCardViewDelegate
	
	func fontCardViewTap(font: FontCardView) {
		
		self.cardSelectIndex = font.tag
		let moji = self.cardList[self.cardSelectIndex]
		print("\(moji)")
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
			let moji = self.cardList[index]
			koma.setFont(moji: moji)
			self.cardList.remove(at: index)
			for v in self.cardScrolliew.subviews {
				v.removeFromSuperview()
			}
			self.updateCardScroll()
			self.cardSelectIndex = nil
		}
	}
}
