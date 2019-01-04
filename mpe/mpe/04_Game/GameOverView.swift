//
//  GameOverView.swift
//  mpe
//
//  Created by 北村 真二 on 2019/01/04.
//  Copyright © 2019 北村 真二. All rights reserved.
//

import UIKit

class GameOverView: UIView {
	
	var closeHandler: (() -> Void)?
	
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
	
}
