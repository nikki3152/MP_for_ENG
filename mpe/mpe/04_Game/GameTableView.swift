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
	
	class func gameTableView(size: CGSize, width: Int, height: Int, cellTypes: [String]) -> GameTableView {
		
		let komaSize: CGFloat = 30
		let tableW: CGFloat = size.width * 2
		let tableH: CGFloat = size.height * 2
		var table: GameTableView
		table = GameTableView(frame: CGRect(x: 0, y: 0, width: tableW, height: tableH))
		let baseView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(width) * komaSize, height: CGFloat(height) * komaSize))
		table.addSubview(baseView)
		table.tableBaseView = baseView
		baseView.center = CGPoint(x: table.frame.size.width / 2, y: table.frame.size.height / 2)
		var count: Int = 0
		for y in 0 ..< height {
			for x in 0 ..< width {
				let moji = cellTypes[count]
				if moji != "" && moji != " " {
					let koma = TableKomaView.tableKomaView(frame: CGRect(x: 0, y: 0, width: komaSize, height: komaSize), moji: moji)
					koma.tag = count
					koma.delegate = table
					baseView.addSubview(koma)
					koma.center = CGPoint(x: (CGFloat(x) * komaSize) + (komaSize / 2), y: (CGFloat(y) * komaSize) + (komaSize / 2))
				}
				count += 1
			}
		}
		
		return table
	}
	
	var tableBaseView: UIView!
	@IBOutlet weak var komaBaseView: UIView!
	
	func getTableKomaView(index: Int) -> TableKomaView? {
		
		var ret: TableKomaView?
		if let v = self.tableBaseView.viewWithTag(index) as? TableKomaView {
			ret = v
		}
		return ret
	}
	
	
	//MARK: - TableKomaViewDelegate
	func tableKomaViewToucheDown(koma: TableKomaView) {
		
		self.delegate?.gameTableViewToucheDown(table: self, koma: koma)
	}	
	func tableKomaViewToucheUp(koma: TableKomaView) {
		
		self.delegate?.gameTableViewToucheUp(table: self, koma: koma)
	}
}
