//
//  TableKomaView.swift
//  mpe
//
//  Created by 北村 真二 on 2018/08/21.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class TableKomaView: UIView {
	
	class func tableKomaView() -> TableKomaView {
		
		let vc = UIViewController(nibName: "TableKomaView", bundle: nil)
		let v = vc.view as! TableKomaView
		return v
	}
	
	@IBOutlet weak var backImageView: UIImageView!
	@IBOutlet weak var frontImageView: UIImageView!
}
