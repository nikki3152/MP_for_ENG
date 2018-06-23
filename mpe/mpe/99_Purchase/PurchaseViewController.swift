//
//  PurchaseViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class PurchaseViewController: BaseViewController {

	class func purchaseViewController() -> PurchaseViewController {
		
		let storyboard = UIStoryboard(name: "PurchaseViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! PurchaseViewController
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
