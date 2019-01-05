//
//  GameOverView.swift
//  mpe
//
//  Created by 北村 真二 on 2019/01/04.
//  Copyright © 2019 北村 真二. All rights reserved.
//

import UIKit

enum GameOverResType: Int {
	case retry				= 1		//やりなおす
	case timeDouble			= 2		//Timeを倍にする（動画）
	case next				= 3		//次の問題へ進む（動画）
	case giveup				= 4		//諦める
}

class GameOverView: UIView {
	
	var closeHandler: ((GameOverResType) -> Void)?
	
	class func gameOverView() -> GameOverView {
		
		let vc = UIViewController(nibName: "GameOverView", bundle: nil)
		let v = vc.view as! GameOverView
		let frame = UIScreen.main.bounds
		v.frame = frame
		return v
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	@IBAction func buttonAction(_ sender: UIButton) {
		
		let res = GameOverResType(rawValue: sender.tag)!
		self.closeHandler?(res)
		self.closeHandler = nil
		self.removeFromSuperview()
	}
}
