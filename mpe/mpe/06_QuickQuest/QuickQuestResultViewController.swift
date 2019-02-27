//
//  QuickQuestResultViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2019/01/28.
//  Copyright © 2019 北村 真二. All rights reserved.
//

import UIKit

class QuickQuestResultViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

	
	deinit {
		print(">>>>>>>> deinit \(String(describing: type(of: self))) <<<<<<<<")
	}
	
	var list: [[String:Any]] = []
	var handler: (() -> Void)?
	
	class func quickQuestResultViewController() -> QuickQuestResultViewController {
		
		let storyboard = UIStoryboard(name: "QuickQuestViewController", bundle: nil)
		let baseCnt = storyboard.instantiateViewController(withIdentifier: "QuickQuestResultView") as! QuickQuestResultViewController
		return baseCnt
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
	@IBOutlet weak var tableView: UITableView!
	
	@IBAction func backButtonAction(_ sender: Any) {
		
		self.handler?()
		self.handler = nil
		self.remove()
		
	}
	
	//MARK: - UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return list.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		var cell: QuickQuestResultCell! = tableView.dequeueReusableCell(withIdentifier: "cell") as? QuickQuestResultCell
		if cell == nil {
			cell = QuickQuestResultCell.quickQuestResultCell()
		}
		let dic = self.list[indexPath.row]
		let correct = dic["correct"] as! Bool
		if correct {
			cell.backImageView.image = UIImage(named: "quiz_result_correct")
		} else {
			cell.backImageView.image = UIImage(named: "quiz_result_incorrect")
		}
		let time: Double = dic["time"] as! Double
		let timeStr = NSString(format: "%.2f", time) as String
		let word: String = dic["word"] as! String 
		let info: String = dic["info"] as! String
		cell.timeLabel.text = timeStr + "sec"
		cell.wordLabel.text = word
		cell.infoLabel.text = info
		
		return cell
	}
	
	//MARK: - UITableViewDelegate
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
