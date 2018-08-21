//
//  FontCardView.swift
//  mpe
//
//  Created by 北村 真二 on 2018/08/21.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class FontCardView: UIView {
	
	class func fontCardView() -> FontCardView {
		
		let vc = UIViewController(nibName: "FontCardView", bundle: nil)
		let v = vc.view as! FontCardView
		return v
	}
	
}
