//
//  TableKomaView.swift
//  mpe
//
//  Created by 北村 真二 on 2018/08/21.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

protocol TableKomaViewDelegate {
	func tableKomaViewToucheDown(koma: TableKomaView)
	func tableKomaViewToucheUp(koma: TableKomaView)
}

class TableKomaView: UIView {
	
	var delegate: TableKomaViewDelegate?
	
	class func tableKomaView(frame: CGRect, moji: String, type: String?) -> TableKomaView {
		
		let vc = UIViewController(nibName: "TableKomaView", bundle: nil)
		let v = vc.view as! TableKomaView
		v.frame = frame
		v.isExclusiveTouch = false
		v.setFont(moji: moji, type: type)
		return v
	}
	var moji: String = ""
	var isEmpty: Bool = false
	@IBOutlet weak var backImageView: UIImageView!
	@IBOutlet weak var frontImageView: UIImageView!
	@IBOutlet weak var typeImageView: UIImageView!
	
	var _backImageName: String?
	var backImageName: String? {
		get {
			return _backImageName
		}
		set {
			_backImageName = newValue
		}
	}
	
	var _isHit: Bool = false
	var isHit: Bool {
		get {
			return _isHit
		}
		set {
			_isHit = newValue
			if let name = backImageName, _isHit {
				self.backImageView.image = UIImage(named: name)
			} else {
				if isEmpty {
					if let name = backImageName {
						self.backImageView.image = UIImage(named: name)
					} else {
						self.backImageView.image = UIImage(named: "table")
					}
				} else {
					self.backImageView.image = UIImage(named: "table_tap")
				}
			}
		}
	}
	
	func setFont(moji: String, type: String?) {
		
		self.moji = moji
		if moji != "0" && moji != " " && moji != "" {
			self.frontImageView.image = UIImage(named: moji)
			if isEmpty {
				self.backImageView.image = UIImage(named: "table")
			} else {
				self.backImageView.image = UIImage(named: "table_tap")
			}
			self.isUserInteractionEnabled = false
		} else {
			self.frontImageView.image = nil
//			if isEmpty {
//				self.backImageView.image = UIImage(named: "table")
//			} else {
//				self.backImageView.image = UIImage(named: "table_tap")
//			}
		}
		if let type = type {
			if type == "DL" {
				self.typeImageView.image = UIImage(named: "double_letter_score")
			}
			else if type == "TL" {
				self.typeImageView.image = UIImage(named: "triple_letter_score")
			}
			else if type == "DW" {
				self.typeImageView.image = UIImage(named: "double_word_score")
			}
			else if type == "TW" {
				self.typeImageView.image = UIImage(named: "triple_word_score")
			}
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		self.backImageView.image = UIImage(named: "table_tap")
		self.delegate?.tableKomaViewToucheDown(koma: self)
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
		
		
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		super.touchesEnded(touches, with: event)
		self.backImageView.image = UIImage(named: "table")
		self.delegate?.tableKomaViewToucheUp(koma: self)
	}
}
