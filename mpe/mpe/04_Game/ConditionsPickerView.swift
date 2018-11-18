//
//  ConditionsPickerView.swift
//  mpe
//
//  Created by 北村 真二 on 2018/11/11.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

typealias ConditionsPickerViewHandler = ((Int, [String:Any]) -> Void)

class ConditionsPickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
	

	var handler: ConditionsPickerViewHandler?
	
	// コードから生成した時の初期化処理
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.nibInit()
	}
	
	// ストーリーボードで配置した時の初期化処理
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.nibInit()
	}
	
	// xibファイルを読み込んでviewに重ねる
	fileprivate func nibInit() {
		
		// File's OwnerをXibViewにしたので ownerはself になる
		guard let view = UINib(nibName: "ConditionsPickerView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else {
			return
		}
		view.frame = self.bounds
		view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		self.addSubview(view)
	}
	
	@IBOutlet weak var leftPicker: UIPickerView!
	
	
	@IBOutlet weak var rightPicker: UIPickerView!
	
	
	@IBAction func okAction(_ sender: Any) {
		
		let type = self.leftPicker.selectedRow(inComponent: 0)
		var data: [String:Any] = [:]
		if type == 1 || type == 2 {
			
		}
		else if type == 3  {
			let row1 = self.rightPicker.selectedRow(inComponent: 0)
			let val1 = self.rightItemList1[row1]
			let row2 = self.rightPicker.selectedRow(inComponent: 1)
			let val2 = self.rightItemList2[row2]
			data = ["words":val1, "count":val2]
		} else if type == 5 {
			let row1 = self.rightPicker.selectedRow(inComponent: 0)
			let val1 = self.rightItemList1[row1]
			let row2 = self.rightPicker.selectedRow(inComponent: 1)
			let val2 = self.rightItemList2[row2]
			data = ["font":val1, "count":val2]
		} else {
			let row1 = self.rightPicker.selectedRow(inComponent: 0)
			let val = self.rightItemList1[row1]
			data = ["count":val]
		}
		print("type:\(type) data:\(data)")
		self.handler?(type, data)
		self.handler = nil
		self.removeFromSuperview()
	}
	
	
	func updateRightPicker(row: Int) {
		
		self.rightItemList1 = []
		self.rightItemList2 = []
		if row == 0 {
			//英単語を◯個作る
			for i in 1 ... 99 {
				self.rightItemList1.append(i)
			}
		}
		else if row == 1 {
			//全てのマスを埋める
		}
		else if row == 2 {
			//すべてのアルファベットを使う
		}
		else if row == 3 {
			//◯字数以上の英単語を◯個作る
			for i in 1 ... 15 {
				self.rightItemList1.append(i)
			}
			for i in 1 ... 15 {
				self.rightItemList2.append(i)
			}
		}
		else if row == 4 {
			//スコアを○点以上
			for i in 1 ... 1000 {
				self.rightItemList1.append(i * 1000)
			}
		}
		else if row == 5 {
			//◯がつく英単語を○個作る
			self.rightItemList1 = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
			for i in 1 ... 15 {
				self.rightItemList2.append(i)
			}
		}
		self.rightPicker.reloadAllComponents()
	}
	
	
	@IBAction func cancelAction(_ sender: Any) {
		
		self.handler = nil
		self.removeFromSuperview()
	}
	
	let leftItemList: [String] = [
		"英単語を？個作る",
		"全てのマスを埋める",
		"すべてのアルファベットを使う",
		"？字数以上の英単語を？個作る",
		"スコアを？点以上",
		"？がつく英単語を？個作る",
	]
	var rightItemList1: [Any] = []
	var rightItemList2: [Any] = []
	
	
	//MARK: - UIPickerViewDataSource
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		
		if pickerView.tag == 0 {
			return 1
		} else {
			let row = self.leftPicker.selectedRow(inComponent: 0)
			if row == 1 || row == 2 {
				return 0
			} else if row == 3 || row == 5 {
				return 2
			} else {
				return 1
			}
		}
	}
	// returns the # of rows in each component..
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
		if pickerView.tag == 0 {
			return self.leftItemList.count
		} else {
			if component == 0 {
				return self.rightItemList1.count
			} else {
				return self.rightItemList2.count
			}
		}
	}
	
	
	
	//MARK: - UIPickerViewDelegate
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		var text: String?
		if pickerView.tag == 0 {
			let value = self.leftItemList[row]
			text = "\(value)"
		} else {
			let row_left = self.leftPicker.selectedRow(inComponent: 0)
			if row_left == 1 || row_left == 2 {
				return nil
			} else if row_left == 3 || row_left == 5 {
				if component == 0 {
					if row_left == 5 {
						let value = self.rightItemList1[row] as! String
						text = value
					} else {
						let value = self.rightItemList1[row] as! Int
						text = String(value)
					}
				} else {
					let value = self.rightItemList2[row] as! Int
					text = String(value)
				}
			} else {
				let value = self.rightItemList1[row] as! Int
				text = String(value)
			}
			
		}
		return text
	}
	
	func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		
		return 44
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		if pickerView.tag == 0 {
			updateRightPicker(row: row)
		}
	}
}
