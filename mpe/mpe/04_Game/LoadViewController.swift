//
//  LoadViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/11/02.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

typealias LoadViewControllerHandler = (_ filePath: String) -> Void

class LoadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	var handler: LoadViewControllerHandler?
	
	class func loadViewController() -> LoadViewController {
		
		let storyboard = UIStoryboard(name: "GameViewController", bundle: nil)
		let baseCnt = storyboard.instantiateViewController(withIdentifier: "LoadView") as! LoadViewController
		return baseCnt
	}
	
	var fileList: [String] = []
	let dataMrg: DataManager = DataManager()
    override func viewDidLoad() {
        super.viewDidLoad()

		do {
			self.fileList = try FileManager.default.contentsOfDirectory(atPath: self.dataMrg.docPath!)
		} catch {
			print("Error!!")
		}
    }

	@IBOutlet weak var closeButton: UIButton!
	@IBAction func closeButtonAction(_ sender: Any) {
		
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBOutlet weak var tableView: UITableView!
	
	
	//MARK: - UITableViewDataSource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return self.fileList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		var cell: UITableViewCell!
		cell = tableView.dequeueReusableCell(withIdentifier: "cell")
		if cell == nil {
			cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
		}
		
		let row = indexPath.row
		let name = self.fileList[row]
		cell.textLabel?.text = name
		
		return cell
	}
	
	
	//MARK: UITableViewDelegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
		if let h = self.handler {
			let row = indexPath.row
			let base_path = self.dataMrg.docPath!
			let name = self.fileList[row]
			let path = base_path + "/" + name
			h(path)
		}
		self.handler = nil
		self.dismiss(animated: true, completion: nil)
		
	}
}
