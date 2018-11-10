//
//  StageSelectViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class StageSelectViewController: BaseViewController {

	let questDatas: [QuestData] = [
		QuestData(),
		QuestData(w: 8, h: 8, 
				  table: [
					" "," "," "," "," "," "," ","A",
					"I","0","0","0","0","0","0","0",
					" "," "," "," "," "," "," ","0",
					"U","0","0","0","0","0","0","0",
					" "," "," "," "," "," "," ","0",
					"E","0","0","0","0","0","0","0",
					" "," "," "," "," "," "," ","0",
					"O","0","0","0","0","0","0","0",
					], 
				  cards: ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"],
				  tableType: nil),
		QuestData(w: 8, h: 6, 
				  table: [
					" "," ","B","0","0","0"," "," ",
					" "," "," "," "," ","0"," "," ",
					"C","0","0"," "," ","0","0","B",
					"T","0","0","0","0","0","0","0",
					"T","0","0","0","0","0","0","0",
					" ","0"," "," "," "," ","0"," ",
					], 
				  cards: ["A","C","C","I","I","K","K","N","R","S","U","U","X"],
				  tableType: nil),
		QuestData(w: 7, h: 7, 
				  table: [
					" "," ","A","R","M"," "," ",
					" "," ","L","E","G"," "," ",
					" "," "," ","N"," "," "," ",
					"0","0","F","E","H","0","0",
					" "," ","O","E","A"," "," ",
					" "," ","O"," ","N"," "," ",
					" "," ","T"," ","D"," "," ",
					], 
				  cards: ["A","E","I","L","N","O","R","S","T","U","D","D","G","M","F","H"],
				  tableType: nil),
		QuestData(w: 8, h: 9, 
				  table: [
					" ","A"," "," "," "," "," "," ",
					" ","P","0","0","C","0"," ","B",
					" ","0"," "," ","0"," "," ","0",
					" ","0"," ","0","E","0","O","N",
					" ","0"," "," ","0"," ","0","0",
					"0"," "," "," ","0"," ","0","0",
					"I"," "," "," ","0"," ","0","0",
					"0"," "," "," "," "," ","0"," ",
					"I"," ","G","0","0","0","E","0",
					], 
				  cards: ["A","E","E","G","H","H","K","L","L","M","M","N","N","P","P","R","S","W","Y"],
				  tableType: nil),
		QuestData(w: 7, h: 7, 
				  table: [
					" ","0"," "," "," "," "," ",
					"0","O","0"," "," ","0","M",
					" ","0"," "," "," ","0","0",
					" "," ","B","0","0","R","0",
					" "," ","0"," "," ","0","0",
					" "," ","0"," "," ","0","0",
					" "," ","D"," "," "," ","0",
					], 
				  cards: ["A","C","D","E","F","G","H","I","K","N","O","P","R","S","U","W","X","Y"], 
				  tableType: nil),
		QuestData(w: 15, h: 15, 
				  table: [
					" "," "," "," "," "," "," "," "," "," "," "," "," "," "," ",
					" "," "," "," "," "," "," "," "," "," "," "," "," "," "," ",
					" "," "," "," "," "," "," "," "," "," "," "," "," "," "," ",
					" "," "," "," "," ","A"," "," "," "," "," "," "," "," "," ",
					" "," "," "," "," ","P","0","0","C","0"," ","B"," "," "," ",
					" "," "," "," "," ","0"," "," ","0"," "," ","0"," "," "," ",
					" "," "," "," "," ","0"," ","0","E","0","O","N"," "," "," ",
					" "," "," "," "," ","0"," "," ","0"," ","0","0"," "," "," ",
					" "," "," "," ","0"," "," "," ","0"," ","0","0"," "," "," ",
					" "," "," "," ","I"," "," "," ","0"," ","0","0"," "," "," ",
					" "," "," "," ","0"," "," "," "," "," ","0"," "," "," "," ",
					" "," "," "," ","I"," ","G","0","0","0","E","0"," "," "," ",
					" "," "," "," "," "," "," "," "," "," "," "," "," "," "," ",
					" "," "," "," "," "," "," "," "," "," "," "," "," "," "," ",
					" "," "," "," "," "," "," "," "," "," "," "," "," "," "," ",
					], 
				  cards: ["A","E","E","G","H","H","K","L","L","M","M","N","N","P","P","R","S","W","Y"],
				  tableType: nil),
		QuestData(),
		QuestData(),
		QuestData(),
		QuestData(),
	]
	
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
	@IBOutlet weak var stageButton1: UIButton!
	@IBOutlet weak var stageButton2: UIButton!
	@IBOutlet weak var stageButton3: UIButton!
	@IBOutlet weak var stageButton4: UIButton!
	@IBOutlet weak var stageButton5: UIButton!
	@IBOutlet weak var stageButton6: UIButton!
	@IBOutlet weak var stageButton7: UIButton!
	@IBOutlet weak var stageButton8: UIButton!
	@IBOutlet weak var stageButton9: UIButton!
	@IBOutlet weak var stageButton10: UIButton!
	@IBAction func stageButtonAction(_ sender: UIButton) {
		
		let tag = sender.tag
		let questData: QuestData = self.questDatas[tag]
		let gameView = GameViewController.gameViewController(questData: questData)
		gameView.present(self) { 
			
		}
		gameView.baseDelegate = self
	}
	
	override func baseViewControllerBack(baseView: BaseViewController) -> Void {
		
		print("ゲームから戻る")
	}
	
}
