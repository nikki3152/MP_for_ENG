//
//  PurchaseViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class PurchaseViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, ADViewVideoDelegate {

	//MARK: ADViewVideoDelegate
	func adViewDidPlayVideo(_ adView: ADView, incentive: Bool) {
		
		if incentive {
			//ポイント
			let pp = UserDefaults.standard.integer(forKey: kPPPoint) + 1
			self.ppLabel.text = "\(pp)"
			UserDefaults.standard.set(pp, forKey: kPPPoint)
			self.ppTableView.reloadData()
		}
	}
	func adViewLoadVideo(_ adView: ADView, canLoad: Bool) {
		
	}
	func adViewDidCloseVideo(_ adView: ADView, incentive: Bool) {
		
		if incentive {
			
		}
	}
	
	@IBOutlet weak var ppTableView: UITableView!
	var closeHandler: (() -> Void)?
	
	var ppList: [[String:Any]] = [
		["pp":10, "text":"キャラカスタム①"],
		["pp":20, "text":"中級ステージ開放"],
		["pp":30, "text":"キャラカスタム②"],
		["pp":40, "text":"上級ステージ開放"],
		["pp":50, "text":"キャラカスタム③"],
		["pp":60, "text":"神級ステージ開放"],
		["pp":70, "text":"キャラカスタム④"],
		["pp":80, "text":"辞書モード開放"],
		["pp":90, "text":"一問一答モード開放"],
		["pp":100, "text":"ランダムステージ開放"],
	]
	
	//MARK: - UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return ppList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		var cell: PPInfoCell! = tableView.dequeueReusableCell(withIdentifier: "ppCell") as? PPInfoCell
		if cell == nil {
			cell = PPInfoCell.ppInfoCell()
		}
		let dict = self.ppList[indexPath.row]
		let pp = dict["pp"] as! Int
		let text = dict["text"] as! String
		if pp == 100 {
			cell.ppLabel?.text = "MAX"
		} else {
			cell.ppLabel?.text = "\(pp)PP"
		}
		cell.infoLabel?.text = "\(text)"
		let p = UserDefaults.standard.integer(forKey: kPPPoint)
		if p >= pp {
			cell.ppLabel?.textColor = UIColor.yellow
			cell.infoLabel?.textColor = UIColor.yellow
		} else {
			cell.ppLabel?.textColor = UIColor.white
			cell.infoLabel?.textColor = UIColor.white
		}
		return cell
	}
	
	//MARK: UITableViewDelegate
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		return tableView.frame.size.height / 10
	}
	
	
	class func purchaseViewController() -> PurchaseViewController {
		
		let storyboard = UIStoryboard(name: "PurchaseViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! PurchaseViewController
		return baseCnt
	}
	
	var timer: Timer!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		adVideoReward.videoDelagate = self
		
		DataManager.animationFadeFlash(v: infoImageView, speed: 2.0)
		
		timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self](t) in
			DataManager.animationJump(v: self!.leftCharaImageView, height: 20, speed: 0.5, isRepeat: false, finished: nil)
			DataManager.animationJump(v: self!.rightCharaImageView, height: 20, speed: 0.5, isRepeat: false, finished: nil)
		}
		//ポイント
		let pp = UserDefaults.standard.integer(forKey: kPPPoint)
		self.ppLabel.text = "\(pp)"
	}
	
	@IBOutlet weak var ppLabel: OutlineLabel!
	
	@IBOutlet weak var infoImageView: UIImageView!
	@IBOutlet weak var leftCharaImageView: UIImageView!
	@IBOutlet weak var rightCharaImageView: UIImageView!
	
	//戻る
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		
		timer?.invalidate()
		timer = nil
		closeHandler?()
		closeHandler = nil
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		self.remove()
	}
	
	@IBOutlet weak var videoAdButton: UIButton!
	@IBAction func videoAdButtonAction(_ sender: Any) {
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		
		if adVideoReward.isCanPlayVideo {
			adVideoReward.playVideo()
		} else {
			let alert = UIAlertController(title: nil, message: "動画を再生できませんでした！！", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	@IBOutlet weak var ppPurchaseButton: UIButton!
	@IBAction func ppPurchaseButtonAction(_ sender: UIButton) {
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
	}
	
}
