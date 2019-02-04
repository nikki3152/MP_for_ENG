//
//  CustomViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class CustomViewController: BaseViewController {

	class func customViewController() -> CustomViewController {
		
		let storyboard = UIStoryboard(name: "CustomViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! CustomViewController
		return baseCnt
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		DataManager.animationFuwa(v: onpu1, dy: 10, speed: 2.2)
		DataManager.animationFuwa(v: onpu2, dy: 10, speed: 2.0)
		DataManager.animationFuwa(v: onpu3, dy: 10, speed: 1.8)
		DataManager.animationFuwa(v: onpu4, dy: 10, speed: 2.0)
	}
	
	//戻る
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		self.remove()
	}
	
	@IBOutlet weak var onpu1: UIImageView!
	@IBOutlet weak var onpu2: UIImageView!
	@IBOutlet weak var onpu3: UIImageView!
	@IBOutlet weak var onpu4: UIImageView!
	
	@IBOutlet weak var charCustomButton1: UIButton!
	@IBOutlet weak var charCustomButton2: UIButton!
	@IBOutlet weak var charCustomButton3: UIButton!
	@IBOutlet weak var charCustomButton4: UIButton!
	@IBOutlet weak var charCustomButton5: UIButton!
	@IBOutlet weak var charCustomButton6: UIButton!
	@IBOutlet weak var charCustomButton7: UIButton!
	@IBOutlet weak var charCustomButton8: UIButton!
	@IBOutlet weak var charCustomButton9: UIButton!
	@IBOutlet weak var charCustomButton10: UIButton!
	@IBAction func charCustomButtonAction(_ sender: UIButton) {
		SoundManager.shared.startSE(type: .seDone)	//SE再生
	}
}
