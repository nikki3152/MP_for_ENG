//
//  PurchaseItemViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2019/04/01.
//  Copyright © 2019 北村 真二. All rights reserved.
//

import UIKit

class PurchaseItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	class func purchaseItemViewController() -> PurchaseItemViewController {
		
		let storyboard = UIStoryboard(name: "PurchaseViewController", bundle: nil)
		let baseCnt = storyboard.instantiateInitialViewController() as! PurchaseItemViewController
		let size = UIScreen.main.bounds.size
		baseCnt.view.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		return baseCnt
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
	
	var _ppList: [[String:Any]] = []
	var ppList: [[String:Any]] {
		get {
			return _ppList
		}
		set {
			_ppList = newValue
			ppTableView.reloadData()
		}
	}
	var handler: (([String:Any]) -> Void)?
	
	@IBOutlet weak var baseView: UIView!
	
	@IBOutlet weak var ppTableView: UITableView!
	
	@IBOutlet weak var cancelButton: UIButton!
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		
		self.view.removeFromSuperview()
		self.removeFromParentViewController()
	}
	
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
		cell.ppLabel?.text = "\(pp)PP"
		cell.infoLabel?.text = "\(text)"
		return cell
	}
	
	//MARK: UITableViewDelegate
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		return tableView.frame.size.height / 10
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
		let dict = self.ppList[indexPath.row]
		self.handler?(dict)
		self.handler = nil
		cancelButtonAction(cancelButton)
	}
}
