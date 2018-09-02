//
//  GameTableView.swift
//  mpe
//
//  Created by 北村 真二 on 2018/08/21.
//  Copyright © 2018年 北村 真二. All rights reserved.
//

import UIKit

protocol GameTableViewDelegate {
	func gameTableViewToucheDown(table: GameTableView, koma: TableKomaView)
	func gameTableViewToucheUp(table: GameTableView, koma: TableKomaView)
}

class GameTableView: UIView, TableKomaViewDelegate {

	var delegate: GameTableViewDelegate?
	
	class func gameTableView(size: CGSize, width: Int, height: Int) -> GameTableView {
		
		let vc = UIViewController(nibName: "GameTableView", bundle: nil)
		let table = vc.view as! GameTableView
		table.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		table.komaBaseView.center = CGPoint(x: table.frame.size.width / 2, y: table.frame.size.height / 2)
		let subviews = table.komaBaseView.subviews
		for v in subviews {
			let koma = TableKomaView.tableKomaView(frame: CGRect(x: 0, y: 0, width: v.frame.size.width, height: v.frame.size.height))
			koma.delegate = table
			v.addSubview(koma)
			koma.center = CGPoint(x: v.frame.size.width / 2, y: v.frame.size.height / 2)
		}
		
		return table
	}
	
	@IBOutlet weak var komaBaseView: UIView!
	
	//MARK: - TableKomaViewDelegate
	func tableKomaViewToucheDown(koma: TableKomaView) {
		
		self.delegate?.gameTableViewToucheDown(table: self, koma: koma)
	}	
	func tableKomaViewToucheUp(koma: TableKomaView) {
		
		self.delegate?.gameTableViewToucheUp(table: self, koma: koma)
	}
}
