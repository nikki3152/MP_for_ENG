//
//  DataPanelView.swift
//  mpe
//
//  Created by 北村 真二 on 2019/03/14.
//  Copyright © 2019 北村 真二. All rights reserved.
//

import UIKit

class DataPanelView: UIView {

	class func dataPanelView(_ num: Int) -> DataPanelView {
		
		let vc = UIViewController(nibName: "DataPanelView\(num)", bundle: nil)
		let v = vc.view as! DataPanelView
		return v
	}
	
	//プレイ時間
	@IBOutlet weak var playTimeLabel: UILabel!
	//ゲームクリア回数
	@IBOutlet weak var gameClearLabel: UILabel!
	//ゲームオーバー回数
	@IBOutlet weak var gameOverLabel: UILabel!
	//揃えた英単語数
	@IBOutlet weak var gameWordsLabel: UILabel!
	
	//ランダムモード（クリア回数／挑戦回数）
	//文字数
	@IBOutlet weak var gandomWordsLabel: UILabel!
	//スコア
	@IBOutlet weak var gandomScoreLabel: UILabel!
	
	//一問一答（正答率／平均解答時間）
	//初級
	@IBOutlet weak var qqBiginnerLabel: UILabel!
	//中級
	@IBOutlet weak var qqIntermediateLabel: UILabel!
	//上級
	@IBOutlet weak var qqAdvancedLabel: UILabel!
	//神級
	@IBOutlet weak var qqGodLabel: UILabel!
	//ランダム
	@IBOutlet weak var qqRandomLabel: UILabel!
	
	
	@IBOutlet weak var panelImageView: UIImageView!
	
	//スコア
	@IBOutlet weak var scoreBaseView: UIView!
	@IBOutlet weak var scoreImgView0: UIImageView!
	@IBOutlet weak var scoreImgView1: UIImageView!
	@IBOutlet weak var scoreImgView2: UIImageView!
	@IBOutlet weak var scoreImgView3: UIImageView!
	@IBOutlet weak var scoreImgView4: UIImageView!
	@IBOutlet weak var scoreImgView5: UIImageView!
	@IBOutlet weak var scoreImgView6: UIImageView!
	@IBOutlet weak var scoreImgView7: UIImageView!
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
