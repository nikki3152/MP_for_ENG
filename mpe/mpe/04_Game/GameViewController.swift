//
//  GameViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class GameViewController: BaseViewController, UIScrollViewDelegate {
	
	class func gameViewController() -> GameViewController {
		
		let storyboard = UIStoryboard(name: "GameViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! GameViewController
		return baseCnt
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cardList = [cardBaseView1,cardBaseView2,cardBaseView3,cardBaseView4,cardBaseView5,cardBaseView6]
    }
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		//手札
		for v in self.cardList {
			let card1 = FontCardView.fontCardView()
			v.addSubview(card1)
			card1.center = CGPoint(x: v.frame.size.width / 2, y: v.frame.size.height / 2)
		}
		//ゲームテーブル
		let size = CGSize(width: self.mainScrollView.frame.size.width * 2, height: self.mainScrollView.frame.size.height * 2)
		self.gameTable = GameTableView.gameTableView(size: size, width: 8, height: 8)
		self.mainScrollView.addSubview(self.gameTable)
		self.mainScrollView.contentSize = CGSize(width: self.gameTable.frame.size.width, height: self.gameTable.frame.size.height)
		self.mainScrollView.maximumZoomScale = 2.0
		self.mainScrollView.minimumZoomScale = 1.0
		self.mainScrollView.zoomScale = 1.0
		self.mainScrollView.contentOffset = CGPoint(x: size.width / 4, y: size.height / 4)
		updateScrollInset()
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
	var cardList: [UIView] = []
	@IBOutlet weak var cardBaseView: UIView!
	@IBOutlet weak var cardLeftButton: UIButton!
	@IBOutlet weak var cardBaseView1: UIView!
	@IBOutlet weak var cardBaseView2: UIView!
	@IBOutlet weak var cardBaseView3: UIView!
	@IBOutlet weak var cardBaseView4: UIView!
	@IBOutlet weak var cardBaseView5: UIView!
	@IBOutlet weak var cardBaseView6: UIView!
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
	
	
	//MARK:- UIScrollViewDelegate
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		
		return self.gameTable
	}
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		
		updateScrollInset()
	}
}
