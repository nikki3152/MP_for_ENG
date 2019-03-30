//
//  GraphDisplayView.swift
//

import UIKit

enum GraphDisplayType: Int {
	case line			= 0		// 折れ線グラフ
	case bar			= 1		// 棒グラフ
}

struct GraphPointData {
	var index: Int
	var x: CGFloat
	var y: CGFloat
	var value: CGFloat
	var unit: String = ""
	init(index: Int, x: CGFloat, y: CGFloat, val: CGFloat, unit: String) {
		self.index = index
		self.x = x
		self.y = y
		self.value = val
		self.unit = unit
	}
}

protocol GraphDisplayViewDelegate {
	func graphDisplayViewTaped(graph: GraphDisplayView, location1: GraphPointData?, location2: GraphPointData?)
	func graphDisplayViewMoved(graph: GraphDisplayView, location1: GraphPointData?, location2: GraphPointData?, nowPt: CGPoint, beforPt: CGPoint)
	func graphDisplayViewUped(graph: GraphDisplayView)
}

class GraphDisplayView: UIView {
	
	var graphDrawView: GraphDrawView!
	var graphType: GraphDisplayType {
		get {
			return self.graphDrawView.graphType
		}
		set {
			self.graphDrawView.graphType = newValue
		}
	}
	
	var delegate: GraphDisplayViewDelegate?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		self.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
		self.layer.masksToBounds = true
	}
	
	var unit:String {
		get {
			return self.graphDrawView.unit
		}
		set {
			self.graphDrawView?.unit = newValue
		}
	}
	var lineWidth:CGFloat {
		get {
			return self.graphDrawView.lineWidth
		}
	}
	var barWidth:CGFloat {
		get {
			return self.graphDrawView.barWidth
		}
	}
	var lineColor:UIColor {
		get {
			return self.graphDrawView.lineColor
		}
		set {
			self.graphDrawView?.lineColor = newValue
		}
	}
	var line2ndColor:UIColor {
		get {
			return self.graphDrawView.line2ndColor
		}
		set {
			self.graphDrawView?.line2ndColor = newValue
		}
	}
	var isDrawVLines: Bool {
		get {
			return self.graphDrawView.isDrawVLines
		}
		set {
			self.graphDrawView.isDrawVLines = newValue
		}
	}
	var isDrawHLines: Bool {
		get {
			return self.graphDrawView.isDrawHLines
		}
		set {
			self.graphDrawView.isDrawHLines = newValue
		}
	}
	var isDrawFrame: Bool {
		get {
			return self.graphDrawView.isDrawFrame
		}
		set {
			self.graphDrawView.isDrawFrame = newValue
		}
	}
	var isDrawPoints: Bool {
		get {
			return self.graphDrawView.isDrawPoints
		}
		set {
			self.graphDrawView.isDrawPoints = newValue
		}
	}
	var memoriXMargin: CGFloat {
		get {
			return self.graphDrawView.memoriXMargin
		}
		set {
			self.graphDrawView.memoriXMargin = newValue
		}
	}
	var memoriYMargin: CGFloat {
		get {
			return self.graphDrawView.memoriYMargin
		}
		set {
			self.graphDrawView.memoriYMargin = newValue
		}
	}
	var memori2ndYMargin: CGFloat {
		get {
			return self.graphDrawView.memori2ndYMargin
		}
		set {
			self.graphDrawView.memori2ndYMargin = newValue
		}
	}
	var valPerPix: CGFloat {
		get {
			return self.graphDrawView.valPerPix
		}
		set {
			self.graphDrawView.valPerPix = newValue
		}
	}
	var val2ndPerPix: CGFloat {
		get {
			return self.graphDrawView.val2ndPerPix
		}
		set {
			self.graphDrawView.val2ndPerPix = newValue
		}
	}
	var graphFrame: CGRect! {
		get {
			return self.graphDrawView.graphFrame
		}
		set {
			self.graphDrawView.graphFrame = newValue
		}
	}
	var graphXInfo: [String?] {
		get {
			return self.graphDrawView.graphXInfo
		}
		set {
			self.graphDrawView.graphXInfo = newValue
		}
	}
	var graphDatas: [CGFloat] {
		get {
			return self.graphDrawView.graphDatas
		}
		set {
			self.graphDrawView.graphDatas = newValue
		}
	}
	var pointData1: [GraphPointData] {
		get {
			return self.graphDrawView.pointData1
		}
		set {
			self.graphDrawView.pointData1 = newValue
		}
	}
	var graph2ndDatas: [CGFloat] {
		get {
			return self.graphDrawView.graph2ndDatas
		}
		set {
			self.graphDrawView.graph2ndDatas = newValue
		}
	}
	var pointData2: [GraphPointData] {
		get {
			return self.graphDrawView.pointData2
		}
		set {
			self.graphDrawView.pointData2 = newValue
		}
	}
	
	var startDummyValue: CGFloat? {
		get {
			return self.graphDrawView.startDummyValue
		}
		set {
			self.graphDrawView.startDummyValue = newValue
		}
	}
	var endDummyValue: CGFloat? {
		get {
			return self.graphDrawView.endDummyValue
		}
		set {
			self.graphDrawView.endDummyValue = newValue
		}
	}
	
	var startDummyValue2: CGFloat? {
		get {
			return self.graphDrawView.startDummyValue2
		}
		set {
			self.graphDrawView.startDummyValue2 = newValue
		}
	}
	var endDummyValue2: CGFloat? {
		get {
			return self.graphDrawView.endDummyValue2
		}
		set {
			self.graphDrawView.endDummyValue2 = newValue
		}
	}
	func set(max2: CGFloat) {
		
		self.graphDrawView._max2 = max2
	}
	func set(min2: CGFloat) {
		
		self.graphDrawView._min2 = min2
	}

	var beforPt: CGPoint!
	
	func len(p1: CGPoint, p2: CGPoint) -> Double {
		let dx = Double(p1.x - p2.x)
		let dy = Double(p1.y - p2.y)
		return sqrt(dx*dx + dy*dy)
	}
	
	//MARK: - タッチイベント
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		
		if let touch = touches.first {
			let pt = touch.location(in: self)
			self.beforPt = pt
			var hit1: GraphPointData?
			if self.graphType == .bar {
				for data in self.graphDrawView.pointData1.reversed() {
					if data.x - self.graphDrawView.barWidth < pt.x - self.leftPixelMargin {
						hit1 = data
						break
					} 
				}
			} else {
				for data in self.graphDrawView.pointData1 {
					if self.len(p1: pt, p2: CGPoint(x: data.x + leftPixelMargin, y: data.y)) <= 20 {
						hit1 = data
						break
					}
//					if abs(Int(data.x - (pt.x - self.leftPixelMargin))) < Int(self.graphDrawView.memoriXMargin) {
//						hit1 = data
//						break
//					} 
				}
			}
			var hit2: GraphPointData?
			if hit1 == nil {
				for data in self.graphDrawView.pointData2 {
					if self.len(p1: pt, p2: CGPoint(x: data.x + leftPixelMargin, y: data.y)) <= 20 {
						hit2 = data
						break
					}
//					if abs(Int(data.x - (pt.x - self.leftPixelMargin))) < Int(self.graphDrawView.memoriXMargin) {
//						hit2 = data
//						break
//					} 
				}
			}
			self.delegate?.graphDisplayViewTaped(graph: self, location1: hit1, location2: hit2)
		}
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
		
		if let touch = touches.first {
			let pt = touch.location(in: self)
			var hit1: GraphPointData?
			if self.graphType == .bar {
				for data in self.graphDrawView.pointData1.reversed() {
					if data.x - self.graphDrawView.barWidth < pt.x - self.leftPixelMargin {
						hit1 = data
						break
					} 
				}
			} else {
				for data in self.graphDrawView.pointData1 {
					if self.len(p1: pt, p2: CGPoint(x: data.x + leftPixelMargin, y: data.y)) <= 20 {
						hit1 = data
						break
					}
//					if abs(Int(data.x - (pt.x - self.leftPixelMargin))) < Int(self.graphDrawView.memoriXMargin) {
//						hit1 = data
//						break
//					} 
				}
			}
			var hit2: GraphPointData?
			if hit1 == nil {
				for data in self.graphDrawView.pointData2 {
					if self.len(p1: pt, p2: CGPoint(x: data.x + leftPixelMargin, y: data.y)) <= 20 {
						hit2 = data
						break
					}
//					if abs(Int(data.x - (pt.x - self.leftPixelMargin))) < Int(self.graphDrawView.memoriXMargin) {
//						hit2 = data
//						break
//					} 
				}
			}
			self.delegate?.graphDisplayViewMoved(graph: self, location1: hit1, location2: hit2, nowPt: pt, beforPt: beforPt)
			self.beforPt = pt
		}
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		
		self.delegate?.graphDisplayViewUped(graph: self)
	}
	
	//MARK: -
	
	
	var isDrawMemori: Bool = true		//目盛を描く
	var _isDrawBottomInfo: Bool = false
	var isDrawBottomInfo: Bool {		//下のラベルを描く
		get {
			if self.graphDrawView == nil {
				return _isDrawBottomInfo
			} else {
				return self.graphDrawView.isDrawBottomInfo
			}
		}
		set {
			_isDrawBottomInfo = newValue
			graphDrawView.isDrawBottomInfo = _isDrawBottomInfo
			self.update()
		}
	}
	
	var topMargin: CGFloat = 10			//上のマージン
	var bottomMargin: CGFloat = 3		//下のマージン
	var leftPixelMargin: CGFloat = 40	//左のマージン
	var rightPixelMargin: CGFloat = 40	//右のマージン
	//グラフの描画高さ
	var graphHeight: CGFloat {
		get {
			return self.bounds.size.height - self.topMargin - self.bottomMargin
		}
	} 
	//グラフの描画幅
	var graphWidth: CGFloat {
		get {
			return self.bounds.size.width - self.leftPixelMargin - self.rightPixelMargin
		}
	} 		
	
	
	func drawLineGraph(datas: [(info: String?, value: CGFloat)], valMax: CGFloat?, valMin: CGFloat?, valSp: CGFloat?) {
		
		self.graphDrawView.drawLineGraph(datas: datas, valMax: valMax, valMin: valMin, valSp: valSp)
	}
	
	var pages: Int = 1 
	
	var _dateList: [Date] = []
	var dateList: [Date] {
		get {
			return _dateList
		}
		set {
			_dateList = newValue
		}
	}
	
	
	//MARK: グラフを作成する
	func makeGraph(pages: Int = 1) {
		
		self.pages = pages
		let graphFrame = CGRect(x: leftPixelMargin, 
						   y: self.topMargin, 
						   width: graphWidth, 
						   height: graphHeight)
		//グラフビュー
		self.graphDrawView?.removeFromSuperview()
		let graph = GraphDrawView(frame: graphFrame)
		graph.isDrawBottomInfo = _isDrawBottomInfo
		self.addSubview(graph)
		self.graphDrawView = graph
	}
	
	func update() {
		if isDrawMemori {
			self.memoriGraphDraw()
		}
		self.graphDrawView.setNeedsDisplay()
	}
	
	//目盛を描画する
	func memoriGraphDraw() {
		
		for v in self.subviews {
			if let label = v as? UILabel {
				label.removeFromSuperview()
			}
		}
		
		graphDrawView.memoriGraphDraw()
		
		//y軸の値
		if self.graphDrawView.graphDatas.count > 0 {
			var value: CGFloat = self.graphDrawView.min
			for _ in 0 ..< 100 {
				let label = UILabel()
				label.textAlignment = .right
				label.text = "\(Int(value))"
				label.font = UIFont.boldSystemFont(ofSize: 10.0)
				label.sizeToFit()
				self.addSubview(label)
				let min = self.graphDrawView.min!
				let a = (value - min) * self.graphDrawView.valPerPix
				let y: CGFloat = self.bounds.size.height - self.bottomMargin - a - self.graphDrawView.bottomMargin
				label.center = CGPoint(x: self.leftPixelMargin / 2, y: y)
				value = value + self.graphDrawView.memoriYMargin
				if y < self.topMargin {
					label.isHidden = true
				}
				if value > self.graphDrawView.max {
					break
				}
			}
		}
	}
	
	
	/*
	override func draw(_ rect: CGRect) {
	}
	*/
	
	
}
