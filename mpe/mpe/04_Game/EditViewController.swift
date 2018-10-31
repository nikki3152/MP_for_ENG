//
//  EditViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/10/31.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, GameTableViewDelegate, FontCardViewDelegate {

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

        // Do any additional setup after loading the view.
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
		self.gameTable.delegate = self
		self.view.addSubview(self.gameTable)
		self.view.sendSubview(toBack: self.gameTable)
		self.gameTable.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2)
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
	
	
	
	//MARK:- FontCardViewDelegate
	
	func fontCardViewTap(font: FontCardView) {
		
		print("\(font.moji)")
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
