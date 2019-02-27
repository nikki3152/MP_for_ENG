//
//  DataManager.swift
//

import UIKit

class DataManager: NSObject {
	/*
	// MD5生成
	// 使用するには、Bridging-Headerに、「#import <CommonCrypto/CommonCrypto.h>」を追記
	class func md5(_ string: String) -> String {
		var md5String = ""
		let digestLength = Int(CC_MD5_DIGEST_LENGTH)
		let md5Buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLength)
		
		if let data = string.data(using: .utf8) {
			data.withUnsafeBytes({ (bytes: UnsafePointer<CChar>) -> Void in
				CC_MD5(bytes, CC_LONG(data.count), md5Buffer)
				md5String = (0..<digestLength).reduce("") { $0 + String(format:"%02x", md5Buffer[$1]) }
			})
		}
		
		return md5String
	}
	*/
	class var shared : DataManager {
		struct Static {
			static let instance : DataManager = DataManager()
		}
		return Static.instance
	}
	
	
	var libPath: String!
	var docPath: String!
	
	override init() {
		
		let	array1 = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
		self.libPath = array1[0]
		
		let	array2 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		self.docPath = array2[0]
		
	}
	
	//+++++++++++++++++++++++++++++++++++++
	//MARK: - 時間関数
	//+++++++++++++++++++++++++++++++++++++
	// NSDateを文字列に変換する
	class func dateToInt(date: Date) -> (year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) {
		
		let calender = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
		let unit: NSCalendar.Unit = [.year, .month, .day, .hour, .minute, .second]
		let comps: NSDateComponents = calender.components(unit, from: date as Date) as NSDateComponents
		return (year: comps.year, month: comps.month, day: comps.day, hour: comps.hour, minute: comps.minute, second: comps.second)
	}
	// NSDateをyyyymmddhhmmss文字列に変換する
	class func dateTo14String(date: Date) -> String {
		
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: NSLocale.Key.languageCode.rawValue)
		formatter.dateFormat = "yyyyMMddHHmmss"
		let ret = formatter.string(from: date)
		return ret
	}
	// NSDateをyyyy-MM-dd HH:mm:ss文字列に変換する
	class func dateToString(date: Date) -> String {
		
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: NSLocale.Key.languageCode.rawValue)
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let ret = formatter.string(from: date)
		return ret
	}
	//年月日をNSDate返す
	class func intToDate(_ year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date {
		
		let dateString = "\(year)-\(month)-\(day) \(hour):\(minute):\(second)"
		let formatter = DateFormatter()
		//タイムゾーン()を言語設定に合わせる
		formatter.locale = Locale(identifier: NSLocale.Key.languageCode.rawValue)
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let date = formatter.date(from: dateString)!
		return date
	}
	//文字列をNSDate返す（フォーマットとローケル指定）
	class func stringToDate(dateString: String, format: String, locale: Locale?) -> Date {
		
		let formatter = DateFormatter()
		formatter.locale = locale
		formatter.dateFormat = format
		let date = formatter.date(from: dateString)!
		return date
	}
	class func stringToDate(dateString: String) -> Date {
		
		let formatter = DateFormatter()
		//タイムゾーン()を言語設定に合わせる
		formatter.locale = Locale(identifier: NSLocale.Key.languageCode.rawValue)
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let date = formatter.date(from: dateString)!
		return date
	}
	//文字列（yyyyMMddHHmmss）をNSDate返す
	class func string14ToDate(dateString: String) -> Date {
		
		let formatter = DateFormatter()
		//タイムゾーン()を言語設定に合わせる
		formatter.locale = Locale(identifier: NSLocale.Key.languageCode.rawValue)
		formatter.dateFormat = "yyyyMMddHHmmss"
		let date = formatter.date(from: dateString)!
		return date
	}
	
	//+++++++++++++++++++++++++++++++++++++
	//MARK: - ディレクトリ／ファイル操作関数
	//+++++++++++++++++++++++++++++++++++++
	// ライブラリディレクトリー内のパスを返す
	func libSubPath(_ subDir: String) -> String {
		
		let sub_path = self.libPath + "/" + subDir 
		let fileMrg = FileManager.default
		do {
			//指定されたディレクトリーへのパスを返す（なければ作る）
			try fileMrg.createDirectory(atPath: sub_path, withIntermediateDirectories: true, attributes: nil)
			
		} catch {
			print("Error!!")
		}
		return sub_path
		
	}
	
	//指定ディレクトリーにあるファイルリストを返す
	func fileList(_ subDir: String) -> [String] {
		
		let path = self.libSubPath(subDir)		
		let fileMrg = FileManager.default
		do {
			let fileList = try fileMrg.contentsOfDirectory(atPath: path)
			return fileList
		} catch {
			print("Error!!")
			return []
		}
	}
	
	//ファイルの存在確認
	func checkFileExists(name: String, dir: String) -> Bool {
		
		var ret: Bool
		let path = self.libSubPath(dir) + "/" + name
		let fileMrg = FileManager.default
		if fileMrg.fileExists(atPath: path) {
			ret = true
		} else {
			ret = false
		}
		return ret
	}
	
	
	//配列を保存
	func save(array: [Any], name: String, dir: String) -> Bool {
		
		let path = self.libSubPath(dir) + "/" + name
		if (array as NSArray).write(toFile: path, atomically: true) {
			return true
		} else {
			return false
		}
	}
	//配列を読み込み
	func load(arrayName: String, dir: String) -> [Any]? {
		
		let path = self.libSubPath(dir) + "/" + arrayName
		if let ary = NSArray(contentsOfFile: path) as? [Any] {
			return ary
		} else {
			return nil
		}
	}
	//辞書を保存
	func save(dict: [String:Any], name: String, dir: String) -> Bool {
		
		let path = self.libSubPath(dir) + "/" + name
		if (dict as NSDictionary).write(toFile: path, atomically: true) {
			return true
		} else {
			return false
		}
	}
	//辞書を読み込み
	func load(name: String, dir: String) -> [String:Any]? {
		
		let path = self.libSubPath(dir) + "/" + name
		if let dic = NSDictionary(contentsOfFile: path) as? [String:Any] {
			return dic
		} else {
			return nil
		}
	}
	//ファイルを削除
	func deleteFile (name: String, dir: String) -> Bool {
		
		let path = self.libSubPath(dir) + "/" + name
		let fileMrg = FileManager.default
		do {
			try fileMrg.removeItem(atPath: path)
			return true
		} catch {
			return false
		}
		
	}
	//ディレクトリーを削除
	func deleteDir (dir: String) -> Bool {
		
		let path = self.libSubPath(dir)
		let fileMrg = FileManager.default
		do {
			try fileMrg.removeItem(atPath: path)
			return true
		} catch {
			return false
		}
		
	}
	
	
	//画像を保存
	func saveImage(name: String,image: UIImage) {
		
		let data = UIImageJPEGRepresentation(image, 1.0)
		let subPath = self.libSubPath("image")
		let filePath = subPath + "/"  + name
		let url = URL(fileURLWithPath: filePath) 
		do{
			try data?.write(to: url)
		}
		catch{
			
		}
		
	}
	//画像を読み込み
	func loadImage(name: String) -> UIImage? {
		
		let filePath = self.imagePath(name)
		let image = UIImage(contentsOfFile: filePath)
		
		return image
		
	}
	func imagePath(_ name: String) -> String {
		let subPath = self.libSubPath("image")
		let filePath = subPath + "/"  + name 
		
		return filePath
		
	}
	//画像データを削除
	func deleteImage () {
		
		let subPath = self.libSubPath("image")
		let fileMrg = FileManager.default
		do {
			try fileMrg.removeItem(atPath: subPath)
		} catch {
			print("削除失敗！")
		}
		
	}
	
	
	
	//Dataを保存
	func saveData(name: String, subPath: String, data: Data) {
		
		let subPath = self.libSubPath(subPath)
		let filePath = subPath + "/"  + name
		let url = URL(fileURLWithPath: filePath) 
		do {
			try data.write(to: url)
		}
		catch{
			
		}
		
	}
	//Dataを読み込み
	func loadData(name: String, subPath: String) -> Data? {
		
		let filePath = self.dataPath(name, subPath)
		let url = URL(fileURLWithPath: filePath)
		do {
			let data = try Data(contentsOf: url, options: [])
			return data
		}
		catch let error {
			print("\(error.localizedDescription)")
			return nil
		}
	}
	func dataPath(_ name: String, _ subPath: String) -> String {
		let subPath = self.libSubPath(subPath)
		let filePath = subPath + "/"  + name 
		return filePath
		
	}
	//Dataデータを削除
	func deleteData(subPath: String) {
		
		let subPath = self.libSubPath(subPath)
		let fileMrg = FileManager.default
		do {
			try fileMrg.removeItem(atPath: subPath)
			print("削除成功！: \(subPath)")
		} catch {
			print("削除失敗！")
		}
		
	}
	
	
	
	//+++++++++++++++++++++++++++++++++++++
	//MARK: - ダウンロード関数
	//+++++++++++++++++++++++++++++++++++++
	//データダウンロード
	func dataDownload(url: URL, handler: @escaping (_ data: Data?) -> Void) {
		
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let d = data, error == nil{
				handler(d)
			} else {
				handler(nil)
			}
		}
		task.resume()
	}
	//画像ダウンロード
	func imageDownload(url: URL, handler: @escaping (_ image: UIImage?) -> Void) {
		
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let d = data, error == nil{
				handler(UIImage(data: d))
			} else {
				handler(nil)
			}
		}
		task.resume()
	}
	
	
	//MARK: JSONダウンロード
	//json文字列
	func jsonDownload(url: URL, handler: @escaping (_ jsonData: String?) -> Void) {
		
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let jsonObj = data, error == nil{
				do {
					let jsonData = try JSONSerialization.data(withJSONObject: jsonObj, options: [])
					let jsonStr = String(bytes: jsonData, encoding: .utf8)!
					handler(jsonStr)
				} catch let error {
					print("\(error.localizedDescription)")
					handler(nil)
				}
			} else {
				handler(nil)
			}
		}
		task.resume()
	}
	//json辞書
	func jsonDictionaryDownload(url: URL, handler: @escaping (_ jsonData: [String:Any]?) -> Void) {
		
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let jsonObj = data, error == nil{
				do {
					let jsonData = try JSONSerialization.jsonObject(with: jsonObj, options: .allowFragments)
					handler(jsonData as? [String:Any])
				} catch let error {
					print("\(error.localizedDescription)")
					handler(nil)
				}
			} else {
				handler(nil)
			}
		}
		task.resume()
	}
	//json配列
	func jsonArrayDownload(url: URL, handler: @escaping (_ jsonData: [Any]?) -> Void) {
		
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let jsonObj = data, error == nil{
				do {
					let jsonData = try JSONSerialization.jsonObject(with: jsonObj, options: .allowFragments)
					handler(jsonData as? [Any])
				} catch let error {
					print("\(error.localizedDescription)")
					handler(nil)
				}
			} else {
				handler(nil)
			}
		}
		task.resume()
	}
	
	
	
	
	//MARK: - GET リクエスト
	func get(url: URL, response: @escaping (_ data: Data?) -> Void) {
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.timeoutInterval = 15.0
		
		let config = URLSessionConfiguration.default
		let session = URLSession(configuration: config)
		let task = session.dataTask(with: request) { (data: Data?, request: URLResponse?, error: Error?) in
			DispatchQueue.main.async {
				response(data)
			}
		}
		task.resume()
	}
	func httpRequest(request: URLRequest, response: @escaping (_ data: Data?) -> Void) {
		
		let config = URLSessionConfiguration.default
		let session = URLSession(configuration: config)
		let task = session.dataTask(with: request) { (data: Data?, request: URLResponse?, error: Error?) in
			DispatchQueue.main.async {
				response(data)
			}
		}
		task.resume()
	}
	
	//MARK: - POST リクエスト
	// JSONシリアライズ
	class func jsonSerialization(json: Any) -> Data? {
		
		do {
			let data = try JSONSerialization.data(withJSONObject: json, options: [])
			return data
		}
		catch {
			return nil
		}
	}
	func postJSON(url: URL, json: Any, response: @escaping (_ data: Data?) -> Void) {
		
		if let body = DataManager.jsonSerialization(json: json) {
			var request = URLRequest(url: url)
			request.httpMethod = "POST"
			request.timeoutInterval = 15.0
			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpBody = body
			let config = URLSessionConfiguration.default
			let session = URLSession(configuration: config)
			let task = session.dataTask(with: request) { (data: Data?, request: URLResponse?, error: Error?) in
				DispatchQueue.main.async {
					if data != nil && error != nil {
						response(data)
					} else {
						if let req = request {
							print("URLResponse: \(req)")
						}
						if let err = error {
							print("Error: \(err)")
						}
						response(nil)
					}
				}
			}
			task.resume()
		} else {
			print(">> Cannot json serialization! <<")
			response(nil)
		}
		
	}
	func postMultiPart(url: URL, data: Data, filename: String, mimeType: String, response: @escaping (_ data: Data?) -> Void) {
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.timeoutInterval = 15.0
		
		var body: Data = Data()
		var postData :String = String()
		let boundary:String = "---------------------------20160429"
		
		request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
		
		postData += "--\(boundary)\r\n"
		
		postData += "Content-Disposition: form-data; name=\"upfile\"; filename=\"\(filename)\"\r\n"
		postData += "Content-Type: \(mimeType)\r\n\r\n"
		body.append(postData.data(using: .utf8)!)
		body.append(data)
		body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
		
		request.httpBody = body
		
		let config = URLSessionConfiguration.default
		let session = URLSession(configuration: config)
		let task = session.dataTask(with: request) { (data: Data?, request: URLResponse?, error: Error?) in
			DispatchQueue.main.async {
				response(data)
			}
		}
		task.resume()
	}
	
	
	//MARK: - アニメーション
	//無限回転
	class func animationInfinityRotate(v: UIView, speed: Float) {
		
		v.layer.removeAnimation(forKey: "ImageViewRotation")
		let animation:CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
		animation.toValue = .pi / 2.0
		animation.duration = 0.5           	// 指定した秒で90度回転
		animation.repeatCount = MAXFLOAT;   // 無限に繰り返す
		animation.isCumulative = true;      // 効果を累積
		v.layer.add(animation, forKey: "ImageViewRotation")
		v.layer.speed = speed
	}
	//ジャンプ
	class func animationJump(v: UIView, height: Float, speed: Float, isRepeat: Bool = true, finished: (() -> Void)? = nil) {
		
		v.layer.removeAllAnimations()
		let y = v.center.y
		var opt: UIView.KeyframeAnimationOptions = []
		if isRepeat {
			 opt = [.repeat]
		}
		UIView.animateKeyframes(withDuration: 1.0 * Double(speed), delay: 0, options: opt, animations: { 
			UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3 * Double(speed), animations: { 
				v.center.y = y - CGFloat(height * 0.8)
			})
			UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.1 * Double(speed), animations: { 
				v.center.y = y - CGFloat(height)
			})
			UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2 * Double(speed), animations: { 
				v.center.y = y
			})
			UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.4 * Double(speed), animations: { 
				v.center.y = y
			})
		}) { (stop) in
			finished?()
		}
	}
	//ふわふわ
	class func animationFuwa(v: UIView, dy: Float, speed: Float) {
		
		v.layer.removeAllAnimations()
		let y = v.center.y
		UIView.animateKeyframes(withDuration: 1.0 * Double(speed), delay: 0.0, options: [.repeat, .autoreverse], animations: { 
			UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25 * Double(speed), animations: { 
				v.center.y = y - CGFloat(dy)
			})
			UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25 * Double(speed), animations: { 
				v.center.y = y
			})
			UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25 * Double(speed), animations: { 
				v.center.y = y + CGFloat(dy)
			})
			UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25 * Double(speed), animations: { 
				v.center.y = y
			})
		}) { (stop) in
			
		}
	}
	class func animationFuwa(v: UIView, dx: Float, speed: Float) {
		
		v.layer.removeAllAnimations()
		let x = v.center.x
		UIView.animateKeyframes(withDuration: 1.0 * Double(speed), delay: 0.0, options: [.repeat, .autoreverse], animations: { 
			UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25 * Double(speed), animations: { 
				v.center.x = x - CGFloat(dx)
			})
			UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25 * Double(speed), animations: { 
				v.center.x = x
			})
			UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25 * Double(speed), animations: { 
				v.center.x = x + CGFloat(dx)
			})
			UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25 * Double(speed), animations: { 
				v.center.x = x
			})
		}) { (stop) in
			
		}
	}
	//フェード点滅
	class func animationFadeFlash(v: UIView, speed: Float, minimum: CGFloat = 0.1) {
		
		v.layer.removeAllAnimations()
		UIView.animateKeyframes(withDuration: 1.0 * Double(speed), delay: 0.0, options: [.repeat, .autoreverse], animations: { 
			UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5 * Double(speed), animations: { 
				v.alpha = minimum
			})
			UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5 * Double(speed), animations: { 
				v.alpha = 1.0
			})
		}) { (stop) in
			
		}
	}
}



//MARK: - エクステンション

extension UIImage {
	
	static func animatedGIF(data: Data) -> UIImage? {
		guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
			return nil
		}
		
		let count = CGImageSourceGetCount(source)
		
		var images: [UIImage] = []
		var duration = 0.0
		for i in 0 ..< count {
			guard let imageRef = CGImageSourceCreateImageAtIndex(source, i, nil) else {
				continue
			}
			
			guard let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any] else {
				continue
			}
			
			guard let gifDictionary = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any] else {
				continue
			}
			
			guard let delayTime = gifDictionary[kCGImagePropertyGIFDelayTime as String] as? Double else {
				continue
			}
			
			duration += delayTime
			
			// pre-render
			let image = UIImage(cgImage: imageRef, scale: UIScreen.main.scale, orientation: .up)
			UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
			image.draw(in: CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height))
			let renderedImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			
			if let renderedImage = renderedImage {
				images.append(renderedImage)
			}
		}
		
		return UIImage.animatedImage(with: images, duration: duration)
	}
}
extension UIImageView {
	
	func animateGIF(data: Data,
					animationRepeatCount: UInt = 0,
					completion: (() -> Void)? = nil) {
		guard let animatedGIFImage = UIImage.animatedGIF(data: data) else {
			return
		}
		
		self.image = animatedGIFImage.images?.last
		self.animationImages = animatedGIFImage.images
		self.animationDuration = animatedGIFImage.duration
		self.animationRepeatCount = Int(animationRepeatCount)
		self.startAnimating()
		
		DispatchQueue.main.asyncAfter(deadline: .now() + animatedGIFImage.duration * Double(animationRepeatCount)) {
			completion?()
		}
	}
}

extension UIColor {
	convenience init(hex: String, alpha: CGFloat) {
		let v = hex.map { String($0) } + Array(repeating: "0", count: max(6 - hex.count, 0))
		let r = CGFloat(Int(v[0] + v[1], radix: 16) ?? 0) / 255.0
		let g = CGFloat(Int(v[2] + v[3], radix: 16) ?? 0) / 255.0
		let b = CGFloat(Int(v[4] + v[5], radix: 16) ?? 0) / 255.0
		self.init(red: r, green: g, blue: b, alpha: alpha)
	}
	
	convenience init(hex: String) {
		self.init(hex: hex, alpha: 1.0)
	}
}

