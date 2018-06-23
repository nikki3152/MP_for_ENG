//
//  StageSelectViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class StageSelectViewController: BaseViewController {

	class func stageSelectViewController() -> StageSelectViewController {
		
		let storyboard = UIStoryboard(name: "StageSelectViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! StageSelectViewController
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
	
	//ステージ
	@IBOutlet weak var stageButton: UIButton!
	@IBAction func stageButtonAction(_ sender: Any) {
		
		let gameView = GameViewController.gameViewController()
		gameView.present(self) { 
			
		}
		gameView.baseDelegate = self
	}
	
	override func baseViewControllerBack(baseView: BaseViewController) -> Void {
		
		print("ゲームから戻る")
	}
	
}
