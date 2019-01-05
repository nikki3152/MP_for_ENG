//
//  OutlineLabel.swift
//  HalloweenGame
//
//  Created by 北村 真二 on 2015/10/03.
//  Copyright © 2015年 北村 真二. All rights reserved.
//

import UIKit

class OutlineLabel: UILabel {

	/*==========================
	プロパティ
	==========================*/
	var outlineColor: UIColor = UIColor.white
	var outlineWidth: CGFloat = 1.0

	
	/*==========================
	イニシャライザ
	==========================*/
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
	}
	
	override func drawText(in rect: CGRect) {
		
		
		let shadowOffset = self.shadowOffset
		let txtColor = self.textColor
	
		let contextRef: CGContext = UIGraphicsGetCurrentContext()!
		contextRef.setLineWidth(outlineWidth)
		contextRef.setLineJoin(.round)
	
		contextRef.setTextDrawingMode(.stroke)
		self.textColor = outlineColor
		//super.drawText(in: CGRectInset(rect, outlineWidth, outlineWidth))
		super.drawText(in: rect.insetBy(dx: outlineWidth, dy: outlineWidth))
	
		//CGContextSetTextDrawingMode(contextRef, .fill)
		contextRef.setTextDrawingMode(.fill)
		self.textColor = txtColor
		super.drawText(in: rect.insetBy(dx: outlineWidth, dy: outlineWidth))
	
		self.shadowOffset = shadowOffset
	}
}
