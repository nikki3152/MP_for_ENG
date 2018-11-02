//
//  LoadViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/11/02.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit
import MessageUI

typealias LoadViewControllerHandler = (_ filePath: String) -> Void

class LoadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
	
	var handler: LoadViewControllerHandler?
	
	class func loadViewController() -> LoadViewController {
		
		let storyboard = UIStoryboard(name: "GameViewController", bundle: nil)
		let baseCnt = storyboard.instantiateViewController(withIdentifier: "LoadView") as! LoadViewController
		return baseCnt
	}
	
	var selectedIndex: Int?
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
		
		self.handler = nil
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBOutlet weak var tableView: UITableView!
	
	//読み込み
	@IBOutlet weak var loadButton: UIButton!
	@IBAction func loadButtonAction(_ sender: Any) {
		
		if let h = self.handler, let index = self.selectedIndex {
			let base_path = self.dataMrg.docPath!
			let name = self.fileList[index]
			let path = base_path + "/" + name
			h(path)
			self.handler = nil
			self.dismiss(animated: true, completion: nil)
		}
		
	}
	
	//共有
	@IBOutlet weak var sharedButton: UIButton!
	@IBAction func sharedButtonAction(_ sender: Any) {
		
		if let index = self.selectedIndex {
			let base_path = self.dataMrg.docPath!
			let name = self.fileList[index]
			let path = base_path + "/" + name
			
			if MFMailComposeViewController.canSendMail() {
				let mail = MFMailComposeViewController()
				mail.mailComposeDelegate = self
				//mail.setToRecipients(["xxxxxx@gmail.com"]) 			// 宛先アドレス
				mail.setSubject("もじぴったん for English 問題")		// 件名
				mail.setMessageBody("もじぴったん for English 問題: \(name)", isHTML: false) 				// 本文
				if let data = NSData(contentsOfFile: path) {
					mail.addAttachmentData(data as Data, mimeType: "text/xml", fileName: name)
				}
				self.present(mail, animated: true, completion: nil)
			} else {
				let alert = UIAlertController(title: "送信エラー", message: "メール送信できません。メールの設定を確認してください！", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
				self.present(alert, animated: true, completion: nil)
			}
		}
	}
	
	//MARK: 編集
	@IBOutlet weak var editButton: UIButton!
	@IBAction func editButtonAction(_ sender: Any) {
		
		self.tableView.isEditing = !self.tableView.isEditing
	}
	
	
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
		
		self.selectedIndex = indexPath.row
		//tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let base_path = self.dataMrg.docPath!
			let name = self.fileList[indexPath.row]
			let path = base_path + "/" + name
			let fileMrg = FileManager.default
			do {
				try fileMrg.removeItem(atPath: path)
				self.fileList.remove(at: indexPath.row)
				tableView.deleteRows(at: [indexPath], with: .fade)
			} catch let error {
				print("\(error.localizedDescription)")
			}
		} else if editingStyle == .insert {
			
		}    
	}
	
	
	//MARK: MFMailComposeViewControllerDelegate
	
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		
		controller.dismiss(animated: true, completion: nil)
		
		switch result {
		case .cancelled:
			break
		case .saved:
			break
		case .sent:
			let alert = UIAlertController(title: "メール送信完了", message: "メールを送信しました。", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
			self.present(alert, animated: true, completion: nil)
			break
		default:
			let alert = UIAlertController(title: "送信エラー", message: "メール送信できません。メールの設定を確認してください！", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}
}
