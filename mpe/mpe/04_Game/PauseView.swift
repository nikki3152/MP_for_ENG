//
//  PauseView.swift
//  mpe
//
//  Created by 北村 真二 on 2019/01/04.
//  Copyright © 2019 北村 真二. All rights reserved.
//

import UIKit

enum GamePauseResType: Int {
	case continueGame		= 1		//続ける
	case retry				= 2		//やりなおす
	case giveup				= 3		//あきらめる
}



class PauseView: UIView, UITableViewDataSource, UITableViewDelegate {
	
	var closeHandler: ((GamePauseResType) -> Void)?
	
	var chaMessages: [String] = []
	var textIndex: Int = 0
	var textTimer: Timer!
	
	class func pauseView() -> PauseView {
		
		let vc = UIViewController(nibName: "PauseView", bundle: nil)
		let v = vc.view as! PauseView
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
	
	@IBAction func buttonAction(_ sender: UIButton) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		let res = GamePauseResType(rawValue: sender.tag)!
		textTimer?.invalidate()
		textTimer = nil
		self.closeHandler?(res)
		self.closeHandler = nil
		self.removeFromSuperview()
	}
	
	@IBOutlet weak var wordTableView: UITableView!
	@IBOutlet weak var buttonBaseView: UIView!
	@IBOutlet weak var ballonDisplayImageView: UIImageView!
	
	var wordList: [[String:String]] = []
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
