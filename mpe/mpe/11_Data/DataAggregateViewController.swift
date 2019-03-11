//
//  DataAggregateViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class DataAggregateViewController: BaseViewController {

	
	deinit {
		print(">>>>>>>> deinit \(String(describing: type(of: self))) <<<<<<<<")
	}
	
	class func dataAggregateViewController() -> DataAggregateViewController {
		
		let storyboard = UIStoryboard(name: "DataAggregateViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! DataAggregateViewController
		return baseCnt
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.currentPage = 1
		
		//ハイスコア
		let hiScore = UserDefaults.standard.integer(forKey: kHiscore)
		self.totalScore = hiScore
		
		let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe(_:)))
		leftSwipe.direction = .left
		self.view.addGestureRecognizer(leftSwipe)
		
		let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe(_:)))
		rightSwipe.direction = .right
		self.view.addGestureRecognizer(rightSwipe)
	}
	
	@objc func swipe(_ swipe: UISwipeGestureRecognizer) {
		
		let direction = swipe.direction 
		if direction == .left {
			self.currentPage += 1
		}
		else if direction == .right {
			self.currentPage -= 1
		}
	}
	
	
	@IBOutlet weak var baseView: UIView!
	
	//戻る
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		self.remove()
	}
	
	//左ボタン
	@IBOutlet weak var leftButton: UIButton!
	@IBAction func leftButtonAction(_ sender: Any) {
		
		self.currentPage -= 1
	}
	
	//右ボタン
	@IBOutlet weak var rightButton: UIButton!
	@IBAction func rightButtonAction(_ sender: Any) {
		
		self.currentPage += 1
	}
	
	var _currentPage: Int = 1
	var currentPage: Int {
		get {
			return _currentPage
		}
		set {
			_currentPage = newValue
			if _currentPage < 1 {
				_currentPage = 1
			}
			if _currentPage > 7 {
				_currentPage = 7
			}
			pageInfoLabel.text = "\(_currentPage) / 7"
			if _currentPage <= 1 {
				leftButton.isHidden = true
				rightButton.isHidden = false
			}
			else if _currentPage >= 7 {
				leftButton.isHidden = false
				rightButton.isHidden = true
			}
			else {
				leftButton.isHidden = false
				rightButton.isHidden = false
			}
			
			
		}
	}
	@IBOutlet weak var pageInfoLabel: UILabel!
	
	//スコア
	@IBOutlet weak var scoreBaseView: UIView!
	@IBOutlet weak var scoreImgView0: UIImageView!
	@IBOutlet weak var scoreImgView1: UIImageView!
	@IBOutlet weak var scoreImgView2: UIImageView!
	@IBOutlet weak var scoreImgView3: UIImageView!
	@IBOutlet weak var scoreImgView4: UIImageView!
	var _totalScore: Int = 0
	var totalScore: Int {
		get {
			return _totalScore
		}
		set {
			_totalScore = newValue
			var keta1 = 0
			var keta2 = 0
			var keta3 = 0
			var keta4 = 0
			let k0 = _totalScore % 10
			let k4 = _totalScore / 10000
			if k4 > 9 {keta4 = k4 % 10 } else {keta4 = k4}
			let k3 = _totalScore / 1000
			if k3 > 9 {keta3 = k3 % 10 } else {keta3 = k3}
			let k2 = _totalScore / 100
			if k2 > 9 {keta2 = k2 % 10 } else {keta2 = k2}
			let k1 = _totalScore / 10
			if k1 > 9 {keta1 = k1 % 10 } else {keta1 = k1}
			scoreImgView0.image = UIImage(named: "\(k0)")
			scoreImgView1.image = UIImage(named: "\(keta1)")
			scoreImgView2.image = UIImage(named: "\(keta2)")
			scoreImgView3.image = UIImage(named: "\(keta3)")
			scoreImgView4.image = UIImage(named: "\(keta4)")
		}
	}
}
