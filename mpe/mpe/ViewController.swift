//
//  ViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/12.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	let dataMrg = MPEDataManager()
	//var db: [String:[String]] = [:]
	override func viewDidLoad() {
		super.viewDidLoad()
		
		UserDefaults.standard.register(defaults: [
			kBGMOn:true,
			kSEOn:true,
			kVoiceOn:true,
		])
		
		//バージョン情報
		let info = Bundle.main.infoDictionary! as Dictionary
		let ver = info["CFBundleShortVersionString"] as! String
		let build = info["CFBundleVersion"] as! String
		print("Ver.\(ver) (\(build))")
		if let buildNo = UserDefaults.standard.object(forKey: "build") as? String {
			if buildNo != build {
				UserDefaults.standard.set(build, forKey: "build")
				if dataMrg.deleteDir(dir: "database") {
					print("DB deleted!!")
				} else {
					print("DB cannot deleted!!")	
				}
			}
		} else {
			UserDefaults.standard.set(build, forKey: "build")
			if dataMrg.deleteDir(dir: "database") {
				print("DB deleted!!")
			} else {
				print("DB cannot deleted!!")	
			}
		}
		
		if dataMrg.checkFileExists(name: "database", dir: "") == false {
			dataMrg.makeDB()
		}
		
		self.timer = Timer.scheduledTimer(withTimeInterval: 7.0, repeats: true, block: { (t) in
			
			self.imageIndex += 1
			self.backImageView.image = UIImage(named: "story_0\(self.imageIndex)")
			if self.imageIndex > 3 {
				self.timer?.invalidate()
				self.timer = nil
			}
		})
		
		self.baseView.alpha = 0
		
	}
	
	var isFirst = false
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewWillLayoutSubviews() {
		
		if isFirst == false {
			isFirst = true
			//起動画面
			let size = UIScreen.main.bounds
			let launchView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
			launchView.backgroundColor = UIColor.white
			launchView.contentMode = .scaleAspectFit
			self.view.addSubview(launchView)
			launchView.center = CGPoint(x: size.width / 2, y: size.height / 2)
			let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 280, height: 240))
			launchView.addSubview(imageview)
			imageview.image = UIImage(named: "flowerpost_logo")
			imageview.center = CGPoint(x: launchView.frame.size.width / 2, y: launchView.frame.size.height / 2)
			UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveLinear, animations: { 
				launchView.alpha = 0
			}) { (stop) in
				launchView.removeFromSuperview()
				UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: { 
					self.baseView.alpha = 1.0
				}) { (stop) in
					SoundManager.shared.startBGM(type: .bgmTop)		//BGM再生
				}
				self.textView.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height + (self.textView.frame.size.height / 2))
				UIView.animate(withDuration: 20.0, delay: 0, options: .curveLinear, animations: { 
					self.textView.center = CGPoint(x: self.view.frame.size.width / 2, y: (self.view.frame.size.height / 2))
				}) { (stop) in
				}
			}
		}
		
	}
	
	// >> Skip
	@IBOutlet weak var skipButton: UIButton!
	@IBAction func skipButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		self.timer?.invalidate()
		self.timer = nil
		let homeView = HomeViewController.homeViewController()
		homeView.present(self) { 
			
		}
	}
	
	@IBOutlet weak var backImageView: UIImageView!
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var baseView: UIView!
	
	var imageIndex: Int = 1
	var timer: Timer!
}

