//
//  GameOverView.swift
//  mpe
//
//  Created by 北村 真二 on 2019/01/04.
//  Copyright © 2019 北村 真二. All rights reserved.
//

import UIKit

enum GameOverResType: Int {
	case retry				= 1		//やりなおす
	case timeDouble			= 2		//Timeを倍にする（動画）
	case next				= 3		//次の問題へ進む（動画）
	case giveup				= 4		//諦める
}

class GameOverView: UIView, UITableViewDataSource, UITableViewDelegate {
	
	var closeHandler: ((GameOverResType) -> Void)?
	
	class func gameOverView() -> GameOverView {
		
		let vc = UIViewController(nibName: "GameOverView", bundle: nil)
		let v = vc.view as! GameOverView
		let frame = UIScreen.main.bounds
		v.frame = frame
		v.wordTableView.frame = CGRect(x: v.wordTableView.frame.origin.x, 
									   y: v.wordTableView.frame.origin.y, 
									   width: v.buttonBaseView.frame.origin.x, 
									   height: v.wordTableView.frame.size.height)
		return v
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.wordTableView.dataSource = self
		self.wordTableView.delegate = self
	}
	
	@IBOutlet weak var buttonBaseView: UIView!
	@IBAction func buttonAction(_ sender: UIButton) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		let res = GameOverResType(rawValue: sender.tag)!
		self.closeHandler?(res)
	}
	
	@IBOutlet weak var ballonDisplayImageView: UIImageView!
	@IBOutlet weak var wordTableView: UITableView!
	
	var wordList: [[String:String]] = []
	
	//MARK: - UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return wordList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
		if cell == nil {
			cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
			cell.backgroundColor = UIColor.clear
			cell.textLabel?.textColor = UIColor.white
			cell.detailTextLabel?.textColor = UIColor.white
			cell.detailTextLabel?.numberOfLines = 2
		}
		let dict = self.wordList[indexPath.row]
		cell.textLabel?.text = dict["word"]!
		cell.detailTextLabel?.text = dict["info"]! 
		return cell
	}
	
	//MARK: - UITableViewDelegate
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
