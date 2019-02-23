//
//  ADView.swift
//
//  Created by 北村 真二 on 2016/12/23.
//  Copyright © 2016年 北村 真二. All rights reserved.
//

import UIKit


/*=====================================================
広告リザルト
=====================================================*/
enum ADViewResultType: Int {
	case error			= -1
	case show			= 0
	case closed			= 1
}

/*=====================================================
インターステイシャル広告クロージャー
=====================================================*/
typealias ADViewResultHandler = (_ result: ADViewResultType) -> Void

/*=====================================================
動画広告プロトコル
=====================================================*/
protocol ADViewVideoDelegate {
	func adViewDidPlayVideo(_ adView: ADView, incentive: Bool)
	func adViewLoadVideo(_ adView: ADView, canLoad: Bool)
	func adViewDidCloseVideo(_ adView: ADView, incentive: Bool)
}



/*=====================================================
広告タイプ定義
=====================================================*/
enum ADType: String {
	
	case banner				= "banner"				//バナー
	case interstitial		= "interstitial"		//インターステイシャル
	case videoReward		= "videoReward"			//動画リワード
	case videoInterstitial	= "videoInterstitial"	//動画インターステイシャル
	case fullscreen			= "fullscreen"			//フルスクリーン
	case videoNative		= "videoNative"			//動画ネイティヴ
	case native				= "native"				//ネイティヴ
}

enum ADNetworkType: String {
	
	case appbank			= "appbank"
	case adfurikun			= "adfurikun"
	case admob				= "admob"
	case zucks				= "zucks"
	
	//===========================================================
	// バナー
	//===========================================================
	//広告ID
	func adBannerID()->String {
		switch self {
		
		case .appbank:
			return ""
		
		case .adfurikun:
			return ""
		
		case .admob:
			return ""
		
		case .zucks:
			return ""
		}
	}
	//===========================================================
	// インターステイシャル
	//===========================================================
	//インターステイシャルID
	func adInterstisialID()->String {
		switch self {
			
		case .appbank:
			return ""
			
		case .adfurikun:
			return ""
			
		case .admob:
			return ""
		
		case .zucks:
			return ""
		}
	}
	//フルスクリーンID
	func adFullscreenID()->String {
		switch self {
			
		case .appbank:
			return ""
			
		case .adfurikun:
			return ""
			
		case .admob:
			return ""
			
		case .zucks:
			return ""
		}
	}
	//動画インターステイシャルID
	func adVideoInterstisialID()->String {
		switch self {
			
		case .appbank:
			return ""
			
		case .adfurikun:
			return "5c6bed01f22ded934000000f"
			
		case .admob:
			return ""
			
		case .zucks:
			return ""
		}
	}
	
	
	//===========================================================
	//動画広告ID
	//===========================================================
	//動画広告ID
	func adVideoID()->String? {
		switch self {
		
		case .appbank:
			return nil
		
		case .adfurikun:
			return "5c6bed4dda42ff795d00000c"
			
		case .admob:
			return ""
		
		case .zucks:
			return nil
		}
	}
	//動画ネイティヴ広告ID
	func adVideoNativeID()->String? {
		switch self {
			
		case .appbank:
			return nil
			
		case .adfurikun:
			return ""
		case .admob:
			return ""
		case .zucks:
			return nil
		}
	}
	
	//ネイティヴID
	func adNativeID() -> String {
		switch self {
		case .appbank:
			return ""
		case .adfurikun:
			return ""
		case .admob:
			return ""
		case .zucks:
			return ""
		}
	}
	
	
}

typealias NativeAdResponse = (_ title: String?, _ text: String?, _ image: UIImage?, _ linkURL: String?) -> Void


/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


//MARK: - ADView


+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

class ADView: UIView, ADFmyMovieRewardDelegate {
	
	var adNetworkType: ADNetworkType!
	var adViewType: ADType!
	var resultHandler: ADViewResultHandler?
	var rootViewCnt: UIViewController?
	
	var adfurikunMovieReward: ADFmyMovieReward?
	
	//==============================================================
	//イニシャライザ
	//==============================================================
	convenience init(adNTType: ADNetworkType, adType: ADType, size: CGSize?, viewController: UIViewController?) {
		
		print("Make Ad: ADNetworkType=\(adNTType) ADType=\(adType)")
		
		if let s = size {
			self.init(frame: CGRect(x: 0, y: 0, width: s.width, height: s.height))
		} else {
			self.init(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
		}
		self.adNetworkType = adNTType
		self.adViewType = adType
		self.rootViewCnt = viewController
		
		if adType == .videoInterstitial {
			//------------------------------------
			//MARK: 動画インターステイシャル広告
			//------------------------------------
			if ADFmyMovieReward.isSupportedOSVersion() {
				let appID = ADNetworkType.adfurikun.adVideoInterstisialID()
				ADFmyMovieInterstitial.initialize(withAppID: appID, viewController: self.rootViewCnt)
			}
		}
		else if adType == .videoReward {
			//------------------------------------
			//MARK: 動画リワード広告
			//------------------------------------
			if adNTType == .adfurikun {
				if ADFmyMovieReward.isSupportedOSVersion() {
					let appID = adNTType.adVideoID()
					ADFmyMovieReward.initialize(withAppID: appID, viewController: self.rootViewCnt)
					self.adfurikunMovieReward = ADFmyMovieReward.getInstance(appID, delegate: self)
					
				}
			}
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor.clear
	}
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
	}
	
	//==============================================================
	//MARK: - 動画リワード広告再生
	//==============================================================
	var isCanPlayVideo: Bool = false
	var videoIncentive: Bool = false
	var videoDelagate: ADViewVideoDelegate?
	
	func playVideo() {
		
		if self.adNetworkType == .adfurikun {
			if  self.adfurikunMovieReward!.isPrepared() == true {
				self.videoIncentive = false
				self.isCanPlayVideo = false
				self.adfurikunMovieReward?.play()
			} else {
				print("ADF 広告の取得が完了していません")
			}
		}
	}
	//------------------------------------
	//MARK: - アドフリくん
	//------------------------------------
	//MARK: 動画インターステイシャル広告
	var adfurikunMovieInterstitial: ADFmyMovieInterstitial?
	func playInterstitialVideo() {
		
		if  self.adfurikunMovieInterstitial!.isPrepared() {
			self.adfurikunMovieInterstitial?.play(withPresenting: self.rootViewCnt)
		} else {
			print("ADF 広告の取得が完了していません")
		}
	}
	
	
	
	
	
	//MARK: ADFmyMovieRewardDelegate
	// 広告の表示準備が終わった 
	func adsFetchCompleted(_ isTestMode_inApp: Bool) {
		
		print("ADF動画の表示準備が終わった")
		if self.adViewType == .videoReward {
			self.isCanPlayVideo = true
			self.videoDelagate?.adViewLoadVideo(self, canLoad: self.isCanPlayVideo)
		} else {
			
		}
	}   
	// 広告の表示が開始したか 
	func adsDidShow(_ adnetworkKey: String) {
		
		print("ADF 動画の表示が開始: \(adnetworkKey)")
		if self.adViewType == .videoReward {
			self.isCanPlayVideo = false
		} else {
			self.resultHandler?(.show)
		}
	}
	// 広告の表示を最後まで終わったか 
	func adsDidCompleteShow() {
		
		print("ADF 動画の表示を最後まで終わった")
		if self.adViewType == .videoReward {
			self.videoIncentive = true
			self.videoDelagate?.adViewDidPlayVideo(self, incentive: self.videoIncentive)
		} else {
			
		}
	}
	// 動画広告再生エラー時のイベント 
	func adsPlayFailed() {
		
		print("ADF 動画広告再生エラー時のイベント")
		if self.adViewType == .videoReward {
			self.isCanPlayVideo = false
			self.videoDelagate?.adViewLoadVideo(self, canLoad: self.isCanPlayVideo)
		} else {
			self.resultHandler?(.error)
			self.resultHandler = nil
		}
	}
	// 広告を閉じた時のイベント 
	func adsDidHide() {
		
		print("ADF 動画を閉じた")
		if self.adViewType == .videoReward {
			self.videoDelagate?.adViewDidCloseVideo(self, incentive: self.videoIncentive)
		} else {
			self.resultHandler?(.closed)
			self.resultHandler = nil
		}
	}
	
	
	
	
}
