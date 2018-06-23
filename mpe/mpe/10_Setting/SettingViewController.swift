//
//  SettingViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {

	class func settingViewController() -> SettingViewController {
		
		let storyboard = UIStoryboard(name: "SettingViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! SettingViewController
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
	
	//データ集計
	@IBOutlet weak var dataAggregateButton: UIButton!
	@IBAction func dataAggregateButtonAction(_ sender: Any) {
		
		let dataView = DataAggregateViewController.dataAggregateViewController()
		dataView.present(self) { 
			
		}
	}
	//音楽
	@IBOutlet weak var soundButton: UIButton!
	@IBAction func soundButtonAction(_ sender: Any) {
		
		let soundView = SoundViewController.soundViewController()
		soundView.present(self) { 
			
		}
	}
	
	//ポイント課金
	@IBOutlet weak var purchaseButton: UIButton!
	@IBAction func purchaseButtonAction(_ sender: Any) {
		
		let purchaseView = PurchaseViewController.purchaseViewController()
		purchaseView.present(self) { 
			
		}
	}
	
}
