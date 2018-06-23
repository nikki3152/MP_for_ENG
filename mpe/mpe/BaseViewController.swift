//
//  BaseViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/23.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

protocol BaseViewControllerdelegate {
	func baseViewControllerBack(baseView: BaseViewController) -> Void
}

class BaseViewController: UIViewController, BaseViewControllerdelegate {

	var baseDelegate: BaseViewControllerdelegate?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        let appFrame = UIScreen.main.bounds
		self.view.frame = CGRect(x: 0, y: 0, width: appFrame.size.width, height: appFrame.size.height)
    }
	
	func present(_ presentVcnt: UIViewController, completed: (() -> Void)?) {
		
		self.view.alpha = 0
		presentVcnt.view.addSubview(self.view)
		presentVcnt.addChildViewController(self)
		UIView.animate(withDuration: 0.25, animations: { 
			self.view.alpha = 1.0
		}) { (stop) in
			completed?()
		}
	}

	func remove() {
		self.view.removeFromSuperview()
		self.removeFromParentViewController()
	}
	
	func baseViewControllerBack(baseView: BaseViewController) -> Void {
		
		
	}
}
