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
		
		let is10PP = UserDefaults.standard.bool(forKey: kIsPurchase10PP)
		let is50PP = UserDefaults.standard.bool(forKey: kIsPurchase50PP)
		let is100PP = UserDefaults.standard.bool(forKey: kIsPurchase100PP)
		
		let actionSheet = UIAlertController(title: "PP購入", message: nil, preferredStyle: .actionSheet)
		var titles: [String] = ["","",""]
		var productObjs: [Any] = ["","",""]
		for product in products {
			let product_id = product["product_id"] as! String 
			let price = product["price"] as! String
			//let description = product["description"] as! String
			var name: String = ""
			let product = product["product"]!
			var str: String = ""
			if product_id == kProductID10 {
				name = "10PP"
				if is10PP {
					str = "\(name) \(price)（購入済）"
				} else {
					str = "\(name) \(price)"
				}
				titles[0] = str
				productObjs[0] = product
			}
			else if product_id == kProductID50 {
				name = "50PP"
				if is50PP {
					str = "\(name) \(price)（購入済）"
				} else {
					str = "\(name) \(price)"
				}
				titles[1] = str
				productObjs[1] = product
			}
			else if product_id == kProductID100 {
				name = "100PP"
				if is100PP {
					str = "\(name) \(price)（購入済）"
				} else {
					str = "\(name) \(price)"
				}
				titles[2] = str
				productObjs[2] = product
			}
		}
		for title in titles {
			actionSheet.addAction(UIAlertAction(title: title, style: .default, handler: { [weak self](action) in
				guard let s = self else {
					return
				}
				var product: Any!
				if title.hasPrefix("10PP") {
					if is10PP == false {
						product = productObjs[0]
					}
				}
				else if title.hasPrefix("50PP") {
					if is50PP == false {
						product = productObjs[1]
					}
				}
				else if title.hasPrefix("100PP") {
					if is100PP == false {
						product = productObjs[2]
					}
				}
				
				if product != nil {
					skManager.paymentRequestStart(productDic: ["product":product], quantity: 1)
					s.makeWaitinfView(parentView: s.view)
				} else {
					let alert = UIAlertController(title: "", message: "このアイテムはすでに購入済みです。", preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: { (action) in
					}))
					s.present(alert, animated: true, completion: nil)
				}
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
		
		if isStartRestore {
			isStartRestore = false
		}
		self.removeWaitingView(parentedView: self.view)
		if let product_id = info["product_id"] as? String {
			if product_id == kProductID10 {
				//ポイント
				UserDefaults.standard.set(true, forKey: kIsPurchase10PP)
				var pp = MPEDataManager.getPP()
				print("購入:\(pp)")
				if pp >= 100 {
					pp = 100
					self.videoAdButton.isEnabled = false
					self.ppPurchaseButton.isEnabled = false
				}
				self.ppLabel.text = "\(pp)"
				self.ppTableView.reloadData()
			}
			else if product_id == kProductID50 {
				//ポイント
				UserDefaults.standard.set(true, forKey: kIsPurchase50PP)
				var pp = MPEDataManager.getPP()
				print("購入:\(pp)")
				if pp >= 100 {
					pp = 100
					self.videoAdButton.isEnabled = false
					self.ppPurchaseButton.isEnabled = false
				}
				self.ppLabel.text = "\(pp)"
				self.ppTableView.reloadData()
			}
			else if product_id == kProductID100 {
				//ポイント
				UserDefaults.standard.set(true, forKey: kIsPurchase100PP)
				let pp = MPEDataManager.getPP()
				print("購入:\(pp)")
				self.videoAdButton.isEnabled = false
				self.ppPurchaseButton.isEnabled = false
				self.ppLabel.text = "\(pp)"
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
		
		print("リストアするアイテムはない")
		self.removeWaitingView(parentedView: self.view)
		if isStartRestore {
			let alert = UIAlertController(title: nil, message: "復元可能なアイテムはありません。", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	
	deinit {
		print(">>>>>>>> deinit \(String(describing: type(of: self))) <<<<<<<<")
	}
	
	//MARK: ADViewVideoDelegate
	func adViewDidPlayVideo(_ adView: ADView, incentive: Bool) {
		
		if incentive {
			//ポイント
			var pp = UserDefaults.standard.integer(forKey: kPPPoint) + 1
			MPEDataManager.updatePP(pp: pp)
			pp = MPEDataManager.getPP()
			if pp >= 100 {
				self.videoAdButton.isEnabled = false
				self.ppPurchaseButton.isEnabled = false
			}
			self.ppLabel.text = "\(pp)"
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
		let p = MPEDataManager.getPP()
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
		let pp = MPEDataManager.getPP()
		self.ppLabel.text = "\(pp)"
		
		if pp >= 100 {
			self.videoAdButton.isEnabled = false
			self.ppPurchaseButton.isEnabled = false
		}
		
		//デバッグ表示
		#if __DEBUG__
			self.ppResetButton.isHidden = false
			self.allClearButton.isHidden = false
		#else
			self.ppResetButton.isHidden = true
			self.allClearButton.isHidden = true
		#endif
		
		for v in self.view.subviews {
			if let bt = v as? UIButton {
				bt.isExclusiveTouch = true
			}
		}
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
		//self.adViewDidPlayVideo(adVideoReward, incentive: true)
		
		if adVideoReward.isCanPlayVideo {
			if adVideoReward.playVideo() {
				SoundManager.shared.pauseBGM(true)
			} else {
				let alert = UIAlertController(title: nil, message: "動画を再生できませんでした！！", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: nil))
				self.present(alert, animated: true, completion: nil)
			}
		} else {
			let alert = UIAlertController(title: nil, message: "動画を再生できませんでした！！", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	//購入
	@IBOutlet weak var ppPurchaseButton: UIButton!
	@IBAction func ppPurchaseButtonAction(_ sender: UIButton) {
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		
		self.makeWaitinfView(parentView: self.view)
		skManager.productRequestStart(productIDs: [kProductID10,kProductID50,kProductID100])
	}
	
	//復元
	var isStartRestore = false
	@IBOutlet weak var restoreButton: UIButton!
	@IBAction func restoreButtonAction(_ sender: UIButton) {
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		self.makeWaitinfView(parentView: self.view)
		skManager.restore()
		isStartRestore = true
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
	
	//オールクリアボタン
	@IBOutlet weak var allClearButton: UIButton!
	@IBAction func allClearButtonAction(_ sender: Any) {
		
		MPEDataManager.updatePP(pp: 100)
		let pp = MPEDataManager.getPP()
		self.ppLabel.text = "\(pp)"
		MPEDataManager.updatePP(pp: pp)
		self.ppTableView.reloadData()
		
		var stageEnableAry = UserDefaults.standard.object(forKey: kEnableStageArry) as! [Bool]
		for i in 0 ..< stageEnableAry.count {
			stageEnableAry[i] = true
		}
		UserDefaults.standard.set(stageEnableAry, forKey: kEnableStageArry)
	}
	
	//PPリセットボタン
	@IBOutlet weak var ppResetButton: UIButton!
	@IBAction func ppResetButtonAction(_ sender: Any) {
		
		MPEDataManager.updatePP(pp: 0)
		UserDefaults.standard.removeObject(forKey: kTotalScore)
		UserDefaults.standard.removeObject(forKey: kAlllPlayTimes)
		UserDefaults.standard.removeObject(forKey: kGameClearCount)
		UserDefaults.standard.removeObject(forKey: kGameOverCount)
		UserDefaults.standard.removeObject(forKey: kGameWordsCount)
		
		UserDefaults.standard.removeObject(forKey: kRandomWordPlayCount)
		UserDefaults.standard.removeObject(forKey: kRandomWordClearCount)
		UserDefaults.standard.removeObject(forKey: kRandomScorePlayCount)
		UserDefaults.standard.removeObject(forKey: kRandomScoreClearCount)
		
		UserDefaults.standard.removeObject(forKey: kQuickBiginnerTimes)
		UserDefaults.standard.removeObject(forKey: kQuickBiginnerCount)
		UserDefaults.standard.removeObject(forKey: kQuickBiginnerCorrectCount)
		
		UserDefaults.standard.removeObject(forKey: kQuickIntermediateTimes)
		UserDefaults.standard.removeObject(forKey: kQuickIntermediateCount)
		UserDefaults.standard.removeObject(forKey: kQuickIntermediateCorrectCount)
		
		UserDefaults.standard.removeObject(forKey: kQuickAdvancedTimes)
		UserDefaults.standard.removeObject(forKey: kQuickAdvancedCount)
		UserDefaults.standard.removeObject(forKey: kQuickAdvancedCorrectCount)
		
		UserDefaults.standard.removeObject(forKey: kQuickGodTimes)
		UserDefaults.standard.removeObject(forKey: kQuickGodCount)
		UserDefaults.standard.removeObject(forKey: kQuickGodCorrectCount)
		
		UserDefaults.standard.removeObject(forKey: kQuickRandomTimes)
		UserDefaults.standard.removeObject(forKey: kQuickRandomCount)
		UserDefaults.standard.removeObject(forKey: kQuickRandomCorrectCount)
		
		UserDefaults.standard.set(["a":0, "b":0, "c":0, "d":0, "e":0, "f":0, "g":0, "h":0, "i":0, "j":0, "k":0, "l":0, "m":0, "n":0, "o":0, "p":0, "q":0, "r":0, "s":0, "t":0, "u":0, "v":0, "w":0, "x":0, "y":0, "z":0], forKey: kUsedFontDict)
		
		UserDefaults.standard.set(false, forKey: kIsPurchase10PP)
		UserDefaults.standard.set(false, forKey: kIsPurchase50PP)
		UserDefaults.standard.set(false, forKey: kIsPurchase100PP)
		
		let pp = MPEDataManager.getPP()
		self.ppLabel.text = "\(pp)"
		self.ppTableView.reloadData()
		
	}
}
