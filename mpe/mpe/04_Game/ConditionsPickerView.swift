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
		var data: [String:Any]
		if self.rightItemList.count == 0 {
			data = [:]
		} else {
			data = ["count":self.rightItemList[self.rightPicker.selectedRow(inComponent: 0)]]
		}
		self.handler?(type, data)
		self.handler = nil
		self.removeFromSuperview()
	}
	
	
	func updateRightPicker(row: Int) {
		
		if row == 0 {
			//ことばを指定の数作る
			self.rightItemList = [1,2,3,4,5,6,7,8,9,10]
		}
		else if row == 1 {
			//全てのマスを埋める
			self.rightItemList = []
		}
		else if row == 2 {
			//ブロックを指定数使う
			self.rightItemList = [1,2,3,4,5,6,7,8,9,10]
		}
		self.rightPicker.reloadAllComponents()
	}
	
	
	@IBAction func cancelAction(_ sender: Any) {
		
		self.handler = nil
		self.removeFromSuperview()
	}
	
	//MARK: - UIPickerViewDataSource
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		
		return 1
	}
	
	let leftItemList: [String] = [
		"英単語を指定の数作る",
		"全てのマスを埋める",
		"ブロックを指定数使う",
	]
	var rightItemList: [Int] = []
	
	
	// returns the # of rows in each component..
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
		if pickerView.tag == 0 {
			return self.leftItemList.count
		} else {
			return self.rightItemList.count
		}
	}
	
	
	
	//MARK: - UIPickerViewDelegate
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		var text: String?
		if pickerView.tag == 0 {
			let value = self.leftItemList[row]
			text = "\(value)"
		} else {
			let value = self.rightItemList[row]
			text = "\(value)"
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
