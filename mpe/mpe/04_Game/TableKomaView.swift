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
	
	class func tableKomaView(frame: CGRect, moji: String) -> TableKomaView {
		
		let vc = UIViewController(nibName: "TableKomaView", bundle: nil)
		let v = vc.view as! TableKomaView
		v.frame = frame
		v.isExclusiveTouch = false
		v.setFont(moji: moji)
		return v
	}
	
	@IBOutlet weak var backImageView: UIImageView!
	@IBOutlet weak var frontImageView: UIImageView!
	
	func setFont(moji: String) {
		if moji != "0" && moji != " " && moji != "" {
			self.frontImageView.image = UIImage(named: moji)
			self.isUserInteractionEnabled = false
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		self.delegate?.tableKomaViewToucheDown(koma: self)
		self.backImageView.image = UIImage(named: "table_tap")
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
		
		
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		self.delegate?.tableKomaViewToucheUp(koma: self)
		self.backImageView.image = UIImage(named: "table")
	}
}
