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
		
		self.remove()
	}
	
}
