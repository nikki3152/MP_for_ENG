//
//  TimePickerView.swift
//  mpe
//
//  Created by 北村 真二 on 2018/11/21.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

typealias TimePickerViewHandler = (_ time: Double) -> Void

class TimePickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {

	var handler: TimePickerViewHandler?
	
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
		guard let view = UINib(nibName: "TimePickerView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else {
			return
		}
		view.frame = self.bounds
		view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		self.addSubview(view)
	}
	
	@IBAction func okAction(_ sender: Any) {
		
		let m = self.minutes[self.picker.selectedRow(inComponent: 0)]
		let s = self.minutes[self.picker.selectedRow(inComponent: 1)]
		let time: Double = Double(m * 60) + Double(s * 10)
		self.handler?(time)
		self.handler = nil
		self.removeFromSuperview()
	}
	
	@IBAction func cancelAction(_ sender: Any) {
		
		self.handler = nil
		self.removeFromSuperview()
	}
	
	func set(time: Double) {
		
		let t = Int(time)
		let m = t / 60
		let s = t - (m * 60)
		print("\(m):\(s)")
		self.picker.selectRow(m, inComponent: 0, animated: false)
		self.picker.selectRow(s / 10, inComponent: 1, animated: false)
	}
	
	@IBOutlet weak var picker: UIPickerView!
	
	//MARK: - UIPickerViewDataSource
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		
		return 2
	}
	
	var minutes: [Int] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
	var seconds: [Int] = [0,10,20,30,40,50]
	
	// returns the # of rows in each component..
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
		if component == 0 {
			return minutes.count
		} else {
			return seconds.count
		}
	}
	
	
	
	//MARK: - UIPickerViewDelegate
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		var text: String?
		if component == 0 {
			let value = self.minutes[row]
			text = "\(value)"
		} else {
			let value = self.seconds[row]
			text = "\(value)"
		}
		return text
	}
	
	func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		
		return 44
	}
}
