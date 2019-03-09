//
//  PurchaseViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class PurchaseViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, ADViewVideoDelegate, StoreKitManagerDelegate {

	//MARK: StoreKitManagerDelegate
		//プロダクトのリストアップ
	func storeKitManagerProductListUp(shopov: StoreKitManager, products: [[String:Any]]) {
		
		self.removeWaitingView(parentedView: self.view)
		
		let actionSheet = UIAlertController(title: "PP購入", message: nil, preferredStyle: .actionSheet)
		var titles: [String] = ["","",""]
		var productObjs: [Any] = ["","",""]
		for product in products {
			let product_id = product["product_id"] as! String 
			let price = product["price"] as! String
			//let description = product["description"] as! String
			let name = product["name"] as! String
			let product = product["product"]!
			let str = "\(name) \(price)"
			if product_id == kProductID10 {
				titles[0] = str
				productObjs[0] = product
			}
			else if product_id == kProductID50 {
				titles[1] = str
				productObjs[1] = product
			}
			else if product_id == kProductID100 {
				titles[2] = str
				productObjs[2] = product
			}
		}
		for title in titles {
			actionSheet.addAction(UIAlertAction(title: title, style: .default, handler: { (action) in
				var product: Any!
				if title.hasPrefix("10PP") {
					product = productObjs[0]
				}
				else if title.hasPrefix("50PP") {
					product = productObjs[1]
				}
				else if title.hasPrefix("100PP") {
					product = productObjs[2]
				}
				skManager.paymentRequestStart(productDic: ["product":product], quantity: 1)
			}))
		}
		actionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) in
			
		}))
		self.present(actionSheet, animated: true, completion: nil)
	}
		
	//トランザクションのキャンセル
	func storeKitManagerCancelTransaction(shopov: StoreKitManager, isRestore: Bool){
		
		self.removeWaitingView(parentedView: self.view)
		let alert = UIAlertController(title: "", message: "購入キャンセル", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: { (action) in
			
		}))
		self.present(alert, animated: true, completion: nil)
	}
		
	//App Storeに製品の支払い処理
	func storeKitManagerPaymentRequestStart(shopov: StoreKitManager) {
		
	}
		
	//購入取引は完了
	func storeKitManagerFinishTransaction(shopov: StoreKitManager, info: [String:Any], isRestore: Bool) {
		
		self.removeWaitingView(parentedView: self.view)
		if let product_id = info["product_id"] as? String {
			if product_id == kProductID10 {
				//ポイント
				var pp = UserDefaults.standard.integer(forKey: kPPPoint) + 10
				if pp > 100 {
					pp = 100
				}
				self.ppLabel.text = "\(pp)"
				MPEDataManager.updatePP(pp: pp)
				self.ppTableView.reloadData()
			}
			else if product_id == kProductID50 {
				//ポイント
				var pp = UserDefaults.standard.integer(forKey: kPPPoint) + 50
				if pp > 100 {
					pp = 100
				}
				self.ppLabel.text = "\(pp)"
				MPEDataManager.updatePP(pp: pp)
				self.ppTableView.reloadData()
			}
			else if product_id == kProductID100 {
				//ポイント
				let pp = 100
				self.ppLabel.text = "\(pp)"
				MPEDataManager.updatePP(pp: pp)
				self.ppTableView.reloadData()
			}
		}
	}	
		
	//購入取引エラー
	func storeKitManagerErrorTransactio(shopov: StoreKitManager, message: String) {
		
		self.removeWaitingView(parentedView: self.view)
	}
		
	//リストアするアイテムはない
	func storeKitManagerNoRestoreItem(shopov: StoreKitManager) {
		
		self.removeWaitingView(parentedView: self.view)
	}
	
	
	deinit {
		print(">>>>>>>> deinit \(String(describing: type(of: self))) <<<<<<<<")
	}
	
	//MARK: ADViewVideoDelegate
	func adViewDidPlayVideo(_ adView: ADView, incentive: Bool) {
		
		if incentive {
			//ポイント
			let pp = UserDefaults.standard.integer(forKey: kPPPoint) + 1
			self.ppLabel.text = "\(pp)"
			MPEDataManager.updatePP(pp: pp)
			self.ppTableView.reloadData()
		}
	}
	func adViewLoadVideo(_ adView: ADView, canLoad: Bool) {
		
	}
	func adViewDidCloseVideo(_ adView: ADView, incentive: Bool) {
		
		SoundManager.shared.pauseBGM(false)
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
		skManager.delegate = self
		
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
		
		skManager.delegate = nil
		adVideoReward.videoDelagate = nil
		timer?.invalidate()
		timer = nil
		closeHandler?()
		closeHandler = nil
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		self.remove()
	}
	
	//動画
	@IBOutlet weak var videoAdButton: UIButton!
	@IBAction func videoAdButtonAction(_ sender: Any) {
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		
		//MARK: 動画デバッグ
		self.adViewDidPlayVideo(adVideoReward, incentive: true)
		
//		if adVideoReward.isCanPlayVideo {
//			adVideoReward.playVideo()
//			SoundManager.shared.pauseBGM(true)
//		} else {
//			let alert = UIAlertController(title: nil, message: "動画を再生できませんでした！！", preferredStyle: .alert)
//			alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: nil))
//			self.present(alert, animated: true, completion: nil)
//		}
	}
	
	//購入
	@IBOutlet weak var ppPurchaseButton: UIButton!
	@IBAction func ppPurchaseButtonAction(_ sender: UIButton) {
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		
		self.makeWaitinfView(parentView: self.view)
		skManager.productRequestStart(productIDs: [kProductID10,kProductID50,kProductID100])
	}
	
	
	
	//MARK: - 待機インジケーター
	func makeWaitinfView(parentView: UIView?) {
		
		DispatchQueue.main.async {
			var view: UIView!
			if let window = parentView {
				if nil == window.viewWithTag(-1000) {
					view = window
				}
			}
			else if let window = UIApplication.shared.keyWindow {
				if nil == window.viewWithTag(-1000) {
					view = window
				}
			}
			guard let window = view else {return}
			//インジケーター表示
			let waitingView = UIView(frame: CGRect(x: 0, y: 0, width: window.bounds.size.width, height: window.bounds.size.height))
			waitingView.tag = -1000
			waitingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
			window.addSubview(waitingView)
			let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
			waitingView.addSubview(indicator)
			indicator.center = CGPoint(x: waitingView.bounds.size.width / 2, y: waitingView.bounds.size.height / 2)
			indicator.startAnimating()
			
		}
	}
	func removeWaitingView(parentedView: UIView?) {
		
		DispatchQueue.main.async {
			if let window = parentedView {
				if let view = window.viewWithTag(-1000) {
					view.removeFromSuperview()
				}
			}
			if let window = UIApplication.shared.keyWindow {
				if let view = window.viewWithTag(-1000) {
					view.removeFromSuperview()
				}
			}
		}
	}
	
	
	//PPリセットぼボタン
	@IBOutlet weak var ppResetButton: UIButton!
	@IBAction func ppResetButtonAction(_ sender: Any) {
		
		MPEDataManager.updatePP(pp: 0)
		let pp = UserDefaults.standard.integer(forKey: kPPPoint)
		self.ppLabel.text = "\(pp)"
		MPEDataManager.updatePP(pp: pp)
		self.ppTableView.reloadData()
	}
}
