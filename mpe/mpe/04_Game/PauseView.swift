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
		
		let ctype = UserDefaults.standard.integer(forKey: kSelectedCharaType)
		if ctype == 1 {
			self.customChara = .mojikun_b
		}
		else if ctype == 2 {
			self.customChara = .mojichan
		}
		else if ctype == 3 {
			self.customChara = .taiyokun
		}
		else if ctype == 4 {
			self.customChara = .tsukikun
		}
		else if ctype == 5 {
			self.customChara = .kumokun
		}
		else if ctype == 6 {
			self.customChara = .mojikun_a
		}
		else if ctype == 7 {
			self.customChara = .pack
		}
		else if ctype == 8 {
			self.customChara = .ouji
		}
		else if ctype == 9 {
			self.customChara = .driller
		}
		else if ctype == 10 {
			self.customChara = .galaga
		}
		
		for v in self.buttonBaseView.subviews {
			if let bt = v as? UIButton {
				bt.isExclusiveTouch = true
			}
		}
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
	
	@IBOutlet weak var charaImageView: UIImageView!
	var _customChara: CustomChara = .mojikun_b
	var customChara: CustomChara {
		get {
			return _customChara 
		}
		set {
			_customChara = newValue
			if let shippo = charaImageView.viewWithTag(99) {
				shippo.removeFromSuperview()
			}
			self.charaImageView.image = UIImage(named: "\(_customChara.rawValue)_01")
			if _customChara == .taiyokun {
				let shippoView = UIImageView(frame: CGRect(x: 0, y: 0, width: charaImageView.frame.size.width, height: charaImageView.frame.size.height))
				shippoView.contentMode = .scaleAspectFit
				shippoView.image = UIImage(named: "taiyokun_shippo_01")
				shippoView.tag = 99
				charaImageView.addSubview(shippoView)
				DataManager.animationInfinityRotate(v: shippoView, speed: 0.1)
			}
		}
	}
	
	
	var wordList: [[String:String]] = []
	var ballonMainLabel: TTTAttributedLabel!
	func updateMojikunString(txt: String) {
		
		self.ballonMainLabel?.removeFromSuperview()
		let font = UIFont(name: "UDDigiKyokashoN-B", size: 14)!
		let bLabel = makeVerticalLabel(size: self.ballonDisplayImageView.frame.size, font: font, text: txt)
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
