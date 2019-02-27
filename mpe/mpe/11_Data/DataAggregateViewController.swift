//
//  DataAggregateViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class DataAggregateViewController: BaseViewController {

	
	deinit {
		print(">>>>>>>> deinit \(String(describing: type(of: self))) <<<<<<<<")
	}
	
	class func dataAggregateViewController() -> DataAggregateViewController {
		
		let storyboard = UIStoryboard(name: "DataAggregateViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! DataAggregateViewController
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
	
}
