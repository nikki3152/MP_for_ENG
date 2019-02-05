//
//  HitInfoView.swift
//  mpe
//
//  Created by 北村 真二 on 2018/11/10.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class HitInfoView: UIView {

	class func hitInfoView() -> HitInfoView {
		
		let vc = UIViewController(nibName: "HitInfoView", bundle: nil)
		let v = vc.view as! HitInfoView
		return v
	}
	
	@IBOutlet weak var answeTitleLabel: UILabel!
	@IBOutlet weak var answeLabel: UILabel!
	
	func open(title: String, info: String, parent: UIView, finished: @escaping (() -> Void)) {
		
		self.answeTitleLabel.text = title
		self.answeLabel.text = info
		self.bounds = CGRect(x: 0, y: 0, width: parent.frame.size.width - 40, height: 64)
		parent.addSubview(self)
		self.center = CGPoint(x: parent.frame.size.width / 2, y: -(self.frame.size.height / 2))
		UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: { 
			self.alpha = 1
			self.center = CGPoint(x: parent.frame.size.width / 2, y: (self.frame.size.height / 2))
		}) { (stop) in
			UIView.animate(withDuration: 0.25, delay: 2.5, options: .curveLinear, animations: { 
				self.alpha = 0
				self.center = CGPoint(x: parent.frame.size.width / 2, y: -(self.frame.size.height / 2))
			}) { (stop) in
				self.removeFromSuperview()
				finished()
			}
		}
	}
}
