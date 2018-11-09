//
//  EditPickerView.swift
//  mpe
//
//  Created by 北村 真二 on 2018/11/09.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

typealias EditPickerViewFinishHandler = ((Int, Int) -> Void)

class EditPickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {

	var handler: EditPickerViewFinishHandler?
	
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
		guard let view = UINib(nibName: "EditPickerView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else {
			return
		}
		view.frame = self.bounds
		view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		self.addSubview(view)
	}

	@IBOutlet weak var leftPicker: UIPickerView!
	@IBOutlet weak var rightPicker: UIPickerView!
	
	
	@IBAction func okAction(_ sender: Any) {
		
		let w = self.leftItemList[self.leftPicker.selectedRow(inComponent: 0)]
		let h = self.rightItemList[self.rightPicker.selectedRow(inComponent: 0)]
		self.handler?(w, h)
		self.handler = nil
		self.removeFromSuperview()
	}
	
	@IBAction func cancelAction(_ sender: Any) {
		
		self.handler = nil
		self.removeFromSuperview()
	}
	
	//MARK: - UIPickerViewDataSource
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		
		return 1
	}
	
	var leftItemList: [Int] = [8,9,10,11,12,13,14,15]
	var rightItemList: [Int] = [8,9,10,11,12,13,14,15]
	
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
}
