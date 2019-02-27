//
//  StudyModeViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class StudyModeViewController: BaseViewController {
	
	
	deinit {
		print(">>>>>>>> deinit \(String(describing: type(of: self))) <<<<<<<<")
	}
	
	var timer: Timer!
	
	class func studyModeViewController() -> StudyModeViewController {
		
		let storyboard = UIStoryboard(name: "StudyModeViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! StudyModeViewController
		return baseCnt
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		DataManager.animationFuwa(v: moonImageView, dy: 20, speed: 3.0)
		
		if self.timer == nil {
			//流れ星
			let size = self.backImageView.frame.size
			for i in 0 ..< 15 {
				let y = Int.random(in: 0 ..< Int(size.height))
				let x = Int.random(in: Int(size.width / 4) ..< Int(size.width * 1.5))
				let _ = self.makeStar(parent: backImageView, tag: i + 100, x: x, y: y, image: "study_star")
			}
			self.timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60, repeats: true, block: { [weak self](t) in
				guard let s = self else {
					return
				}
				let size = s.backImageView.frame.size
				let stars = s.backImageView.subviews
				for star in stars {
					let tag = star.tag
					star.center = CGPoint(x: star.center.x - 1.2, y: star.center.y + 1.2)
					if star.center.y > size.height + 40 {
						star.removeFromSuperview()
						let x = Int.random(in: Int(size.width / 4) ..< Int(size.width * 1.5))
						let _ = s.makeStar(parent: s.backImageView, tag: tag, x: x, y: -40, image: "study_star")
					} 
				}
			})
		}
	}
	
	func makeStar(parent: UIView, tag: Int, x: Int, y: Int, image: String) -> UIImageView {
		
		let star = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
		star.contentMode = .scaleAspectFit
		star.tag = tag 
		star.image = UIImage(named: image)
		parent.addSubview(star)
		star.center = CGPoint(x: x, y: y)
		
		return star
	}
	
	@IBOutlet weak var backImageView: UIImageView!
	
	//戻る
	@IBOutlet weak var backButton: UIButton!
	@IBAction func backButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		self.timer?.invalidate()
		self.timer = nil
		self.remove()
	}
	
	//辞書モード
	@IBOutlet weak var dictModeButton: UIButton!
	@IBAction func dictModeButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		let dictView = DictViewController.dictViewController()
		dictView.present(self) { 
			
		}
	}
	
	//一問一答モード
	@IBOutlet weak var quickQuestModeButton: UIButton!
	@IBAction func quickQuestModeButtonAction(_ sender: Any) {
		
		SoundManager.shared.startSE(type: .seDone)	//SE再生
		let quickIntroView = QuickQuestIntoroViewController.quickQuestIntoroViewController()
		quickIntroView.present(self) { 
			
		}
	}
	
	@IBOutlet weak var moonImageView: UIImageView!
}
