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
	
	var chaMessages: [String] = []
	var textIndex: Int = 0
	var textTimer: Timer!
	
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
		
		self.chaMessages = MPEDataManager.loadStringList(name: "mpe_キャラセリフ文言_ゲームオーバー", type: "csv")
		
		if self.textTimer == nil {
			self.updateMojikunString(txt: chaMessages[textIndex])
			self.textTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self](t) in
				self?.textIndex += 1
				if self!.textIndex >= self!.chaMessages.count {
					self!.textIndex = 0
				}
				self?.updateMojikunString(txt: self!.chaMessages[self!.textIndex])
			})
		}
	}
	var ballonMainLabel: TTTAttributedLabel!
	func updateMojikunString(txt: String) {
		
		self.ballonMainLabel?.removeFromSuperview()
		let bLabel = makeVerticalLabel(size: self.ballonDisplayImageView.frame.size, font: UIFont.boldSystemFont(ofSize: 14), text: txt)
		bLabel.textAlignment = .left
		bLabel.numberOfLines = 3
		self.ballonDisplayImageView.addSubview(bLabel)
		bLabel.center = CGPoint(x: self.ballonDisplayImageView.frame.size.width / 2, y: self.ballonDisplayImageView.frame.size.height / 2)
		self.ballonMainLabel = bLabel
	}
	
	@IBOutlet weak var buttonBaseView: UIView!
	@IBAction func buttonAction(_ sender: UIButton) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		let res = GameOverResType(rawValue: sender.tag)!
		textTimer?.invalidate()
		textTimer = nil
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
