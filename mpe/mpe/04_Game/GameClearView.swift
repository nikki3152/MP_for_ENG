//
//  GameClearView.swift
//  mpe
//
//  Created by 北村 真二 on 2019/01/04.
//  Copyright © 2019 北村 真二. All rights reserved.
//

import UIKit

enum GameClearResType: Int {
	case next				= 1		//次の問題へ進む
	case select				= 2		//セレクト画面に戻る
	case dict				= 3		//辞書モードで復習！
}


class GameClearView: UIView {
	
	var closeHandler: ((GameClearResType) -> Void)?
	
	class func gameClearView() -> GameClearView {
		
		let vc = UIViewController(nibName: "GameClearView", bundle: nil)
		let v = vc.view as! GameClearView
		let frame = UIScreen.main.bounds
		v.frame = frame
		return v
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	@IBAction func buttonAction(_ sender: UIButton) {
		
		let res = GameClearResType(rawValue: sender.tag)!
		self.closeHandler?(res)
		self.closeHandler = nil
		self.removeFromSuperview()
	}
}
