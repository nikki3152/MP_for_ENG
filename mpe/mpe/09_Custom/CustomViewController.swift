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
		
		// Do any additional setup after loading the view.
	}
	
	//戻る
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		self.remove()
	}
	
	
	@IBOutlet weak var charCustomButton1: UIButton!
	@IBOutlet weak var charCustomButton2: UIButton!
	@IBOutlet weak var charCustomButton3: UIButton!
	@IBOutlet weak var charCustomButton4: UIButton!
	@IBOutlet weak var charCustomButton5: UIButton!
	@IBOutlet weak var charCustomButton6: UIButton!
	@IBOutlet weak var charCustomButton7: UIButton!
	@IBOutlet weak var charCustomButton8: UIButton!
	@IBOutlet weak var charCustomButton9: UIButton!
	@IBAction func charCustomButtonAction(_ sender: UIButton) {
		SoundManager.shared.startSE(type: .seDone)	//SE再生
	}
}
