//
//  FontCardView.swift
//  mpe
//
//  Created by 北村 真二 on 2018/08/21.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

protocol FontCardViewDelegate {
	func fontCardViewTap(font: FontCardView)
}

class FontCardView: UIView {
	
	var delegate: FontCardViewDelegate?
	
	var _isWildCard: Bool = false
	var isWildCard: Bool {
		get {
			return _isWildCard
		}
		set {
			_isWildCard = newValue
			let val = MPEDataManager.mojiValue(c: _moji)
			if _isWildCard {
				self.backImageView.image = UIImage(named: "pink_\(val)")
			} else {
				self.backImageView.image = UIImage(named: "orange_\(val)")
			}
		}
	}
	
	var _isSelected: Bool = false
	var isSelected: Bool {
		get {
			return _isSelected
		}
		set {
			_isSelected = newValue
			self.frameImageView.isHidden = !_isSelected
			if _isSelected {
				DataManager.animationFadeFlash(v: frameImageView, speed: 1.0, minimum: 0.3)
			} else {
				frameImageView.layer.removeAllAnimations()
			}
		}
	}
	
	var _moji: String!
	var moji: String! {
		get {
			return _moji
		}
		set {
			_moji = newValue
			self.frontImageView.image = UIImage(named: moji)
			let val = MPEDataManager.mojiValue(c: _moji)
			if _isWildCard {
				self.backImageView.image = UIImage(named: "pink_\(val)")
			} else {
				self.backImageView.image = UIImage(named: "orange_\(val)")
			}
		}
	}
	
	class func fontCardView(moji: String) -> FontCardView {
		
		let vc = UIViewController(nibName: "FontCardView", bundle: nil)
		let v = vc.view as! FontCardView
		v.moji = moji
		let tap = UITapGestureRecognizer(target: v, action: #selector(FontCardView.tap(_:)))
		v.addGestureRecognizer(tap)
		return v
	}
	@IBOutlet weak var backImageView: UIImageView!
	@IBOutlet weak var frontImageView: UIImageView!
	@IBOutlet weak var frameImageView: UIImageView!
	
	@objc func tap(_ tap: UITapGestureRecognizer) {
		SoundManager.shared.startSE(type: .seSelect)	//SE再生
		self.delegate?.fontCardViewTap(font: self)
	}
}
