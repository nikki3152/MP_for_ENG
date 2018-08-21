//
//  GameTableView.swift
//  mpe
//
//  Created by 北村 真二 on 2018/08/21.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

class GameTableView: UIView {

	class func gameTableView(size: CGSize, width: Int, height: Int) -> GameTableView {
		
		let vc = UIViewController(nibName: "GameTableView", bundle: nil)
		let table = vc.view as! GameTableView
		table.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		table.komaBaseView.center = CGPoint(x: table.frame.size.width / 2, y: table.frame.size.height / 2)
		let subviews = table.komaBaseView.subviews
		for v in subviews {
			let koma = TableKomaView.tableKomaView()
			v.addSubview(koma)
			koma.center = CGPoint(x: v.frame.size.width / 2, y: v.frame.size.height / 2)
		}
		
		return table
	}
	
	@IBOutlet weak var komaBaseView: UIView!
}
