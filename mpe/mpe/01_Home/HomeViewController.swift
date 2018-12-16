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

        // Do any additional setup after loading the view.
    }
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
	}
	//スタート
	@IBOutlet weak var startButton: UIButton!
	@IBAction func startButtonAction(_ sender: Any) {
		
		let waitView = WaitingViewController.waitingViewController()
		waitView.present(self) { 
			
		}
	}
	
}
