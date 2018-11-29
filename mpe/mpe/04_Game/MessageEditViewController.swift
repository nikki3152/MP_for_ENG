//
//  MessageEditViewController.swift
//  mpe
//
//  Created by 北村 真二 on 2018/11/29.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class MessageEditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

	class func messageEditViewController(messages: [String]) -> MessageEditViewController {
		
		let storyboard = UIStoryboard(name: "GameViewController", bundle: nil)
		let baseCnt = storyboard.instantiateViewController(withIdentifier: "MessageEditView") as! MessageEditViewController
		baseCnt.messages = messages
		return baseCnt
	}
	
	var handler: (([String]) -> Void)?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	
	
	@IBOutlet weak var messageTableView: UITableView!
	
	var messages: [String] = []
	var messageSelectIndex: Int = -1

	//閉じる
	@IBOutlet weak var closeButton: UIButton!
	@IBAction func closeButtonAction(_ sender: Any) {
		
		self.handler?(self.messages)
		self.handler = nil
		self.dismiss(animated: true) { 
			
		}
	}
	//追加
	@IBOutlet weak var addButton: UIButton!
	@IBAction func addButtonAction(_ sender: Any) {
		
		self.messages.append("もじぴったん")
		self.messageTableView.reloadData()
		self.textField.text = "もじぴったん"
		self.textField.becomeFirstResponder()
	}
	
	//編集
	@IBOutlet weak var editButton: UIButton!
	@IBAction func editButtonAction(_ sender: Any) {
		
		self.messageTableView.isEditing = !self.messageTableView.isEditing
		if self.messageTableView.isEditing {
			editButton.setTitle("完了", for: .normal)
			self.addButton.isEnabled = false
			self.textField.isUserInteractionEnabled = false
		} else {
			editButton.setTitle("編集", for: .normal)
			self.addButton.isEnabled = true
			self.textField.isUserInteractionEnabled = true
		}
	}
	
	
	
	@IBOutlet weak var textField: UITextField!
	
	
	//MARK: - UITextFieldDelegate
	 
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		
		if self.messageSelectIndex >= 0 {
			self.messageTableView.isUserInteractionEnabled = false
			return true
		} else {
			return false
		}
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		
		self.editButton.isEnabled = false
		self.addButton.isEnabled = false
	}
	
	func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
		
		self.editButton.isEnabled = true
		self.addButton.isEnabled = true
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		if let txt = textField.text, txt.count > 0 {
			self.messages.remove(at: messageSelectIndex)
			self.messages.insert(txt, at: messageSelectIndex)
			self.messageTableView.isUserInteractionEnabled = true
			self.messageTableView.reloadData()
			textField.resignFirstResponder()
			return true
		} else {
			
			return false
		}
	}
	
	
	//MARK: - UITableViewDataSource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
		if cell == nil {
			cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
		}
		let message = self.messages[indexPath.row]
		if messageSelectIndex == indexPath.row {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
		cell.textLabel?.text = message
		return cell
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	//MARK: - UITableViewDelegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		self.messageSelectIndex = indexPath.row
		let message = self.messages[indexPath.row]
		self.textField.text = message
		tableView.reloadData()
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
			
		if editingStyle == .delete {
			self.messages.remove(at: self.messageSelectIndex)
			tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
		}
	}
}
