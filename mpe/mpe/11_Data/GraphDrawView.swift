//
//  GraphDrawView.swift
//

import UIKit


class GraphDrawView: UIView {

	var graphType: GraphDisplayType = .line
    
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
	}
	
	var lineWidth:CGFloat = 3.0 //折れ線グラフ線の太さ
	var barWidth:CGFloat = 5.0 	//棒グラフ線の太さ
	var lineColor:UIColor = UIColor(red:0.5,  green:0.8,  blue:0.5, alpha:1) 	//グラフ1の色
	var line2ndColor:UIColor = UIColor(red:0.75,  green:0.5,  blue:0.0, alpha:1) //グラフ2の色
	var circleWidth:CGFloat = 4.0 //円の半径
	var isDrawVLines: Bool = false		//縦ラインを描く
	var isDrawHLines: Bool = true		//横ラインを描く
	var isDrawFrame: Bool = false		//枠を描く
	var isDrawPoints: Bool = false		//ポイントを描く
	var isDrawBottomInfo: Bool = false	//目盛を描く
	var unit: String = ""
	
	//MARK: 横目盛の間隔
	var memoriXMargin: CGFloat = 70 
	//MARK: 縦目盛の間隔
	var memoriYMargin: CGFloat = 10 	
	//MARK: 縦目盛の間隔
	var memori2ndYMargin: CGFloat = 10 	
	//MARK: １ピクセルの値
	var valPerPix: CGFloat = 1			
	//MARK: １ピクセルの値
	var val2ndPerPix: CGFloat = 1		
	
	var graphFrame: CGRect!				//グラフの描画フレーム
	var graphXInfo: [String?] = []
	var graphDatas: [CGFloat] = []
	var pointData1: [GraphPointData] = []
	var graph2ndDatas: [CGFloat] = []
	var pointData2: [GraphPointData] = []
	
	var startDummyValue: CGFloat?
	var endDummyValue: CGFloat?
	
	var startDummyValue2: CGFloat?
	var endDummyValue2: CGFloat?
	
	
	// 最大値と最低値の差を求める
	var yAxisMax: CGFloat {
		
		return self.max - self.min
	}
	
	//MARK: グラフ最大値
	var _max: CGFloat! 
	var max: CGFloat! {
		get {
			if let m = _max {
				return m
			} else {
				if let m = self.graphDatas.max() {
					return m
				} else {
					return 100
				}
			}
		}
	}
	var _max2: CGFloat! 
	var max2: CGFloat! {
		get {
			if let m = _max2 {
				return m
			} else {
				if let m = self.graph2ndDatas.max() {
					return m
				} else {
					return 100
				}
			}
		}
	}
	//MARK: 最小値
	var _min: CGFloat! 
	var min: CGFloat! {
		get {
			if let m = _min {
				return m
			} else {
				if let m = self.graph2ndDatas.min() {
					return m
				} else {
					return 0
				}
			}
		}
	}
	var _min2: CGFloat! 
	var min2: CGFloat! {
		get {
			if let m = _min2 {
				return m
			} else {
				if let m = self.graphDatas.min() {
					return m
				} else {
					return 0
				}
			}
		}
	}
	//MARK: 特殊値
	var spValue: CGFloat!
	
	//MARK: 下のマージン
	var bottomMargin: CGFloat {			//下のマージン
		get {
			if isDrawBottomInfo {
				return 20
			} else {
				return 3
			}
		}
	}
	//MARK: グラフの描画
	func drawLineGraph(datas: [(info: String?, value: CGFloat)], valMax: CGFloat?, valMin: CGFloat?, valSp: CGFloat?) {
		
		self.spValue = valSp
		self._max = valMax
		self._min = valMin
		if self.graphType == .line {
			//折れ線グラフ
			if valMax != nil && valMin != nil {
				if (valMax! - valMin!) <= 5 {
					self.memoriYMargin = 1.0
				} 
				else if (valMax! - valMin!) <= 10 {
					self.memoriYMargin = 2.0
				} 
				else if (valMax! - valMin!) <= 20 {
					self.memoriYMargin = 3.0
				} 
				else {
					self.memoriYMargin = 5.0
				} 
			}
		} else {
			//棒グラフ
			if valMax != nil {
				if valMax! >= 10000000 {
					self.memoriYMargin = 5000000.0
				} 
				else if valMax! >= 1000000 {
					self.memoriYMargin = 500000.0
				} 
				else if valMax! >= 100000 {
					self.memoriYMargin = 50000.0
				} 
				else if valMax! >= 10000 {
					self.memoriYMargin = 5000.0
				} 
				else if valMax! >= 1000 {
					self.memoriYMargin = 500.0
				} 
				else if valMax! >= 100 {
					self.memoriYMargin = 50.0
				} 
				else if valMax! >= 10 {
					self.memoriYMargin = 5.0
				} 
				else {
					self.memoriYMargin = 2.0
				}
			} else {
				self.memoriYMargin = 100.0
			}
		}
		self.graphXInfo = []
		self.graphDatas = []
		for d in datas {
			self.graphXInfo.append(d.info)
			self.graphDatas.append(d.value)
		}
		self.memoriXMargin = self.bounds.size.width / CGFloat(datas.count)
		self.barWidth = self.memoriXMargin - 3.0
		self.graphFrame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
		self.valPerPix = self.self.bounds.size.height / self.yAxisMax
	}
	
	//MARK: 目盛を描画する
	func memoriGraphDraw() {
		
		for v in self.subviews {
			if let label = v as? UILabel {
				label.removeFromSuperview()
			}
		}
		//x軸の値
		if self.isDrawBottomInfo {
			for i in 0 ..< self.graphXInfo.count {
				if var memori = self.graphXInfo[i] {
					
					//print("[\(i)]\(memori)")	//横軸メモリ情報
					let strs = memori.split(separator: "-")
					if strs.count == 2 {
						memori = String(strs[0]) 
					}
					
					if memori.count > 0 {
						let label = UILabel()
						label.text = String(memori)
						label.font = UIFont.boldSystemFont(ofSize: 10.0)
						label.sizeToFit()
						self.addSubview(label)
						if self.graphType == .bar {
							label.center = CGPoint(x: (CGFloat(i) * self.memoriXMargin) + (self.barWidth / 2), y: self.bounds.size.height - 10)
						} else {
							label.center = CGPoint(x: (CGFloat(i) * self.memoriXMargin), y: self.bounds.size.height - 10)
						}
					}
				}
			}
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		//print("--- touchesBegan ---")
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
		//print("--- touchesMoved ---")
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		//print("--- touchesEnded ---")
	}
	
	
	
	//MARK: グラフの線を描画
	override func draw(_ rect: CGRect) {
		
		self.pointData1 = []
		self.pointData2 = []
		if self.graphDatas.count > 0 {
			//背景ライン
			for i in 0 ..< self.graphDatas.count {
				if i == 0 {
					//縦ライン
					let vLinePath = UIBezierPath()
					vLinePath.lineWidth = 2.0
					UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).setStroke()
					vLinePath.move(to: CGPoint(x: CGFloat(i) * self.memoriXMargin, y: self.bounds.size.height - self.bottomMargin))
					vLinePath.addLine(to: CGPoint(x: CGFloat(i) * self.memoriXMargin, y: 0))
					vLinePath.stroke()
					//横ライン
					var val: CGFloat = self.min
					for ii in 0 ..< 50 {
						let vLinePath = UIBezierPath()
						vLinePath.lineWidth = 1.0
						if ii == 0 {
							UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).setStroke()
						} else {
							UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0).setStroke()
						}
						vLinePath.move(to: CGPoint(x: 0, y: self.bounds.size.height - self.bottomMargin - ((val - self.min) * self.valPerPix)))
						vLinePath.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height - self.bottomMargin - ((val - self.min) * self.valPerPix)))
						vLinePath.stroke()
						val = val + self.memoriYMargin
						if self.isDrawHLines == false && ii == 0 {
							break
						}
						if val > self.max {
							break
						}
					}
				} else if self.isDrawVLines {
					if let info = self.graphXInfo[i] {
						//縦ライン
						let vLinePath = UIBezierPath()
						vLinePath.lineWidth = 1.0
						if info == "1" || info.contains("日") {
							UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).setStroke()
						} else {
							UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0).setStroke()
						}
						vLinePath.move(to: CGPoint(x: CGFloat(i) * self.memoriXMargin, y: self.bounds.size.height - self.bottomMargin))
						vLinePath.addLine(to: CGPoint(x: CGFloat(i) * self.memoriXMargin, y: 0))
						vLinePath.stroke()
					}
				}
			}
			if self.graphType == .bar {
				//棒グラフ
				for i in 0 ..< self.graphDatas.count {
					let original_value = self.graphDatas[i]
					if original_value > 0 {
						let linePath = UIBezierPath()
						linePath.lineWidth = self.barWidth
						let value: CGFloat = original_value - self.min
						let sy: CGFloat = self.bounds.size.height - self.bottomMargin
						let ey: CGFloat = self.bounds.size.height - self.bottomMargin - (value * self.valPerPix)
						let x: CGFloat = CGFloat(i) * self.memoriXMargin + (self.barWidth / 2)
						let spt: CGPoint = CGPoint(x: x, y: sy)
						let ept: CGPoint = CGPoint(x: x, y: ey)
						linePath.move(to: spt)
						linePath.addLine(to: ept)
						self.lineColor.setStroke()
						linePath.stroke()
						if self.isDrawPoints {
							//ポイント
							let data = GraphPointData(index: i, x: ept.x + (self.barWidth / 2), y: ept.y, val: original_value, unit: unit)
							self.pointData1.append(data)
						}
					}
				}
			} else if self.graphType == .line {
				//折れ線グラフ
				var isStartGrath: Bool = false
				let linePath = UIBezierPath()
				linePath.lineWidth = self.lineWidth
				for i in 0 ..< self.graphDatas.count {
					let original_value = self.graphDatas[i]
					if original_value > 0 {
						let value: CGFloat = original_value - self.min
						let y: CGFloat = self.bounds.size.height - self.bottomMargin - (value * self.valPerPix)
						var x: CGFloat
						if i == self.graphDatas.count - 1 {
							x = self.bounds.width
						} else {
							x = CGFloat(i) * self.memoriXMargin
						}
						let pt: CGPoint = CGPoint(x: x, y: y)
						if isStartGrath == false {
							isStartGrath = true
							linePath.move(to: pt)
						} else {
							linePath.addLine(to: pt)
						}
						if self.isDrawPoints {
							//ポイント
							let circle = UIBezierPath(arcCenter: pt, radius: self.circleWidth, startAngle: 0.0, endAngle: CGFloat(Double.pi * 2), clockwise: false)
							self.lineColor.setFill()
							circle.fill()
							let data = GraphPointData(index: i, x: pt.x, y: pt.y, val: original_value, unit: unit)
							self.pointData1.append(data)
						}
					} else {
						//体重開始ダミーポイント
						if i == 0, let original_value = self.startDummyValue {
							let value: CGFloat = original_value - self.min
							let y: CGFloat = self.bounds.size.height - self.bottomMargin - (value * self.valPerPix)
							let x: CGFloat = CGFloat(i) * self.memoriXMargin
							let pt: CGPoint = CGPoint(x: x, y: y)
							isStartGrath = true
							linePath.move(to: pt)
						}
					}
				}
				
				//体重最終ダミーポイント
				if let original_value = self.endDummyValue {
					let value: CGFloat = original_value - self.min
					let y: CGFloat = self.bounds.size.height - self.bottomMargin - (value * self.valPerPix)
					let x: CGFloat = CGFloat(self.graphDatas.count - 1) * self.memoriXMargin
					let pt: CGPoint = CGPoint(x: x, y: y)
					linePath.addLine(to: pt)
				}
				
				self.lineColor.setStroke()
				linePath.stroke()
			}
		}
		//体脂肪率ライン(折れ線グラフ)
		if self.graphType == .line && self.graph2ndDatas.count > 0 {
			
			if self.graphDatas.count == 0 {
				//背景ライン
				for i in 0 ..< self.graph2ndDatas.count {
					if i == 0 {
						if self.graphDatas.count == 0 {
							//縦ライン
							let vLinePath = UIBezierPath()
							vLinePath.lineWidth = 2.0
							UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).setStroke()
							vLinePath.move(to: CGPoint(x: CGFloat(i) * self.memoriXMargin, y: self.bounds.size.height - self.bottomMargin))
							vLinePath.addLine(to: CGPoint(x: CGFloat(i) * self.memoriXMargin, y: 0))
							vLinePath.stroke()
							//横ライン
							var val: CGFloat = 0
							for ii in 0 ... 10 {
								let vLinePath = UIBezierPath()
								vLinePath.lineWidth = 1.0
								if ii == 0 {
									UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).setStroke()
								} else {
									UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0).setStroke()
								}
								vLinePath.move(to: CGPoint(x: 0, y: self.bounds.size.height - self.bottomMargin - (val * self.val2ndPerPix)))
								vLinePath.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height - self.bottomMargin - (val * self.val2ndPerPix)))
								vLinePath.stroke()
								val = val + self.memori2ndYMargin
								if val > self.max2 {
									break
								}
							}
						}
					} else if self.isDrawVLines {
						if let info = self.graphXInfo[i] {
							//縦ライン
							let vLinePath = UIBezierPath()
							vLinePath.lineWidth = 1.0
							if info == "1" {
								UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).setStroke()
							} else {
								UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0).setStroke()
							}
							vLinePath.move(to: CGPoint(x: CGFloat(i) * self.memoriXMargin, y: self.bounds.size.height - self.bottomMargin))
							vLinePath.addLine(to: CGPoint(x: CGFloat(i) * self.memoriXMargin, y: 0))
							vLinePath.stroke()
						}
					}
					
				}
			}
			
			let line2ndPath = UIBezierPath()
			line2ndPath.lineWidth = self.lineWidth
			var isStartGrath: Bool = false
			for i in 0 ..< self.graph2ndDatas.count {
				let original_value = self.graph2ndDatas[i]
				if original_value > 0 {
					let value: CGFloat = original_value
					let y: CGFloat = self.bounds.size.height - self.bottomMargin - ((value - self.min2) * self.val2ndPerPix)
					let x: CGFloat = CGFloat(i) * self.memoriXMargin
					let pt: CGPoint = CGPoint(x: x, y: y)
					if isStartGrath == false {
						isStartGrath = true
						line2ndPath.move(to: pt)
					}
					line2ndPath.addLine(to: pt)
					
					if self.isDrawPoints {
						//ポイント
						let circle = UIBezierPath(arcCenter: pt, radius: self.circleWidth, startAngle: 0.0, endAngle: CGFloat(Double.pi * 2), clockwise: false)
						self.line2ndColor.setFill()
						circle.fill()
						let data = GraphPointData(index: i, x: pt.x, y: pt.y, val: original_value, unit: "％")
						self.pointData2.append(data)
					}
				} else {
					//体脂肪率開始ダミーポイント
					if i == 0, let original_value = self.startDummyValue2 {
						let value: CGFloat = original_value
						let y: CGFloat = self.bounds.size.height - self.bottomMargin - ((value - self.min2) * self.val2ndPerPix)
						let x: CGFloat = CGFloat(i) * self.memoriXMargin
						let pt: CGPoint = CGPoint(x: x, y: y)
						isStartGrath = true
						line2ndPath.move(to: pt)
					}
				}
			}
			
			//体脂肪率最終ダミーポイント
			if let original_value = self.endDummyValue2 {
				let value: CGFloat = original_value
				let y: CGFloat = self.bounds.size.height - self.bottomMargin - ((value - self.min2) * self.val2ndPerPix)
				let x: CGFloat = CGFloat(self.graph2ndDatas.count - 1) * self.memoriXMargin
				let pt: CGPoint = CGPoint(x: x, y: y)
				line2ndPath.addLine(to: pt)
			}
			
			self.line2ndColor.setStroke()
			line2ndPath.stroke()
		}
		
		//目標ライン
		if self.spValue != nil {
			if self.graphType == .bar {
				let vLinePath = UIBezierPath()
				vLinePath.lineWidth = 2.0
				UIColor(red: 0.3, green: 0.3, blue: 1.0, alpha: 1.0).setStroke()
				let value: CGFloat = self.spValue - self.min
				var y: CGFloat = self.bounds.size.height - self.bottomMargin - (value * self.valPerPix)
				if self.spValue < self.min {
					y = self.bounds.size.height - self.bottomMargin
					let dashes:[CGFloat] = [10,4]
					vLinePath.setLineDash(dashes, count: dashes.count, phase: 0)
				}
				vLinePath.move(to: CGPoint(x: 0, y: y))
				if self.graphType == .bar {
					vLinePath.addLine(to: CGPoint(x: self.bounds.size.width, y: y))
				} else {
					vLinePath.addLine(to: CGPoint(x: self.bounds.size.width, y: y))
				}
				vLinePath.stroke()
			} else {
				let vLinePath = UIBezierPath()
				vLinePath.lineWidth = 2.0
				UIColor(red: 0.3, green: 0.3, blue: 1.0, alpha: 1.0).setStroke()
				let value: CGFloat = self.spValue - self.min
				var y: CGFloat = self.bounds.size.height - self.bottomMargin - (value * self.valPerPix)
				if self.spValue < self.min {
					y = self.bounds.size.height - self.bottomMargin
					let dashes:[CGFloat] = [10,4]
					vLinePath.setLineDash(dashes, count: dashes.count, phase: 0)
				}
				vLinePath.move(to: CGPoint(x: 0, y: y))
				vLinePath.addLine(to: CGPoint(x: self.bounds.size.width, y: y))
				vLinePath.stroke()
			}
		}
		
		if self.isDrawFrame {
			let framePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - bottomMargin))
			UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).setStroke()
			framePath.stroke()
		}
		
	}
}
