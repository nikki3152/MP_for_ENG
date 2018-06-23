//
//  ViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/06/12.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewWillLayoutSubviews() {
		
	}
	
	// >> Skip
	@IBOutlet weak var skipButton: UIButton!
	@IBAction func skipButtonAction(_ sender: Any) {
		
		let homeView = HomeViewController.homeViewController()
		homeView.present(self) { 
			
		}
	}
	
	
}

