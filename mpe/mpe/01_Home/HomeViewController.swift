//
//  HomeViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

	class func homeViewController() -> HomeViewController {
		
		let storyboard = UIStoryboard(name: "HomeViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! HomeViewController
		//let baseCnt = storyboard.instantiateViewController(withIdentifier: "HomeView") as! HomeViewController
		return baseCnt
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
    }
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		//太陽（回転）
		DataManager.animationInfinityRotate(v: sunSippoImageView, speed: 0.1)
		//もじくん（ふわふわ）
		DataManager.animationFuwa(v: mojikunImageView, dx: 40, speed: 8.0)
		DataManager.animationFuwa(v: mojikunBaseView, dy: 20, speed: 6.0)
		//もじじちゃん（ジャンプ）
		DataManager.animationJump(v: mojichanImageView, height: 40, speed: 1.0)
		//雲くん（ふわふわ）
		DataManager.animationFuwa(v: kumoBaseView, dx: 20, speed: 10.0)
		DataManager.animationFuwa(v: kumoImageView, dy: 10, speed: 8.0)
		
		DataManager.animationFadeFlash(v: startLabel, speed: 1.5)
	}
	//スタート
	@IBOutlet weak var startLabel: UILabel!
	@IBOutlet weak var startButton: UIButton!
	@IBAction func startButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .sePressStart)	//SE再生
		
		let waitView = WaitingViewController.waitingViewController()
		waitView.present(self) { 
			
		}
	}
	
	@IBOutlet weak var mojikunBaseView: UIView!
	@IBOutlet weak var kumoBaseView: UIView!
	@IBOutlet weak var titleLogoImageView: UIImageView!
	@IBOutlet weak var sunSippoImageView: UIImageView!
	@IBOutlet weak var mojikunImageView: UIImageView!
	@IBOutlet weak var mojichanImageView: UIImageView!
	@IBOutlet weak var kumoImageView: UIImageView!
}
