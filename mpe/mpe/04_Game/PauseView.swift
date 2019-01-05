//
//  PauseView.swift
//  mpe
//
//  Created by 北村 真二 on 2019/01/04.
//  Copyright © 2019 北村 真二. All rights reserved.
//

import UIKit

enum GamePauseResType: Int {
	case continueGame		= 1		//続ける
	case retry				= 2		//やりなおす
	case giveup				= 3		//あきらめる
}



class PauseView: UIView {
	
	var closeHandler: ((GamePauseResType) -> Void)?
	
	class func pauseView() -> PauseView {
		
		let vc = UIViewController(nibName: "PauseView", bundle: nil)
		let v = vc.view as! PauseView
		let frame = UIScreen.main.bounds
		v.frame = frame
		return v
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	@IBAction func buttonAction(_ sender: UIButton) {
		
		let res = GamePauseResType(rawValue: sender.tag)!
		self.closeHandler?(res)
		self.closeHandler = nil
		self.removeFromSuperview()
	}
}
