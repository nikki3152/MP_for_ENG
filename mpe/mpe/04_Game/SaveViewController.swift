//
//  SaveViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/11/02.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

typealias SaveViewControllerHandler = (_ filePath: String) -> Void

class SaveViewController: UIViewController, UITextFieldDelegate {
	
	var handler: SaveViewControllerHandler?
	
	class func saveViewController() -> SaveViewController {
		
		let storyboard = UIStoryboard(name: "GameViewController", bundle: nil)
		let baseCnt = storyboard.instantiateViewController(withIdentifier: "SaveView") as! SaveViewController
		return baseCnt
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		
		self.textField.becomeFirstResponder()
	}
	
	@IBOutlet weak var closeButton: UIButton!
	@IBAction func closeButtonAction(_ sender: Any) {
		
		self.view.removeFromSuperview()
		self.removeFromParentViewController()
	}
	
	@IBOutlet weak var textField: UITextField!
	
	
	
	//MARK: - UITextFieldDelegate
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		if let name = textField.text, name.count > 0 {
			self.handler?(name + ".plist")
			self.handler = nil
			self.view.removeFromSuperview()
			self.removeFromParentViewController()
			return true
		} else {
			return false
		}
	}
}
