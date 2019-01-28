//
//  SoundManager.swift
//  mpe
//
//  Created by 北村 真二 on 2019/01/22.
//  Copyright © 2019 北村 真二. All rights reserved.
//

import UIKit

enum BGMType: String {
	case bgmTop					= "BGM_TOP画面"
	case bgmWait				= "BGM_待機画面"
	case bgmOneQuest			= "BGM_一問一答モード"
	case bgmEasy				= "BGM_初級ステージ"
	case bgmNormal				= "BGM_中級ステージ"
	case bgmHard				= "BGM_上級ステージ"
	case bgmGod					= "BGM_神級ステージ"
	
	case bgmStageClear			= "BGM_ステージクリアジングル_shot"
	case bgmStageRundom			= "BGM_ランダムステージ_loop"
	case bgmFail				= "BGM_失敗ジングル_loop"
}
enum SEType: String {
	case sePressStart			= "SE_PRESS_to_START"
	case seKomaPut				= "SE_コマ配置音_通常"
	case seCombo1				= "SE_コンボ①"
	case seCombo2				= "SE_コンボ②"
	case seCombo3				= "SE_コンボ③"
	case seCombo4				= "SE_コンボ④"
	case seCombo5				= "SE_コンボ⑤"
	case seCombo6				= "SE_コンボ⑥"
	case seCombo7				= "SE_コンボ⑦"
	case seCombo8				= "SE_コンボ⑧"
	case seCombo9				= "SE_コンボ⑨"
	case seCombo10				= "SE_コンボ⑩以降"
	case sePause				= "SE_一時停止ボタン選択音"
	case seDone					= "SE_決定音"
	case seCorrect				= "SE_正解音"
	case seSelect				= "SE_選択音"
	case seFail					= "SE_不正解音"
}

class SoundManager: NSObject, SoundPlayerDelegate {
	
	class var shared : SoundManager {
		struct Static {
			static let instance : SoundManager = SoundManager()
		}
		Static.instance.soundPlayer.spDelegate = Static.instance
		return Static.instance
	}
	
	let soundPlayer: SoundPlayer = SoundPlayer()
	
	//-----------------------------------------
	//BGM
	//-----------------------------------------
	var isBGMPause: Bool = false
	var bgmPlayState: Int = 0		//0:未再生 1:Hit再生中 2:Loop再生中
	var currentBGM: BGMType!
	func startBGM(type: BGMType) {
		if UserDefaults.standard.bool(forKey: kBGMOn) == false {
			return
		}
		self.stopBGM()
		if type == .bgmStageClear || type == .bgmStageRundom {
			//ジングル
			self.currentBGM = type
			self.bgmPlayState = 0
			self.soundPlayer.voicePlay(name: self.currentBGM.rawValue, type: "wav")
		} else {
			//ループBGM
			if type == .bgmFail {
				self.currentBGM = type
				self.bgmPlayState = 2
				if let path = Bundle.main.path(forResource: self.currentBGM.rawValue, ofType: "wav") {
					print("LOOP: \(self.currentBGM.rawValue)")
					self.soundPlayer.setBGMSound(filepath: path)
				}
			} else {
				self.currentBGM = type
				self.bgmPlayState = 1
				self.soundPlayer.voicePlay(name: self.currentBGM.rawValue + "_hit", type: "wav")
				print("HIT: \(self.currentBGM.rawValue)")
			}
		}
	}
	func stopBGM() {
		if UserDefaults.standard.bool(forKey: kBGMOn) == false {
			return
		}
		if self.bgmPlayState == 1 {
			self.bgmPlayState = 0
			self.soundPlayer.voiceStop()
		}
		else if self.bgmPlayState == 2 {
			self.bgmPlayState = 0
			self.soundPlayer.bgmStop()
		}
		if self.currentBGM != nil {
			print("STOP: \(self.currentBGM.rawValue)")
		}
		self.currentBGM = nil
	}
	func pauseBGM(_ pause: Bool) {
		if UserDefaults.standard.bool(forKey: kBGMOn) == false {
			return
		}
		self.isBGMPause = pause
		if self.bgmPlayState == 1 {
			if self.isBGMPause {
				print("一時停止")
				self.soundPlayer.voicePlayer?.pause()
			} else {
				print("再生")
				self.soundPlayer.voicePlayer?.play()
			}
		}
		else if self.bgmPlayState == 2 {
			if self.isBGMPause {
				print("一時停止")
			} else {
				print("再生")
			}
			self.soundPlayer.bgmPause(pause: self.isBGMPause)
		}
	}
	
	
	//-----------------------------------------
	//SE
	//-----------------------------------------
	func startSE(type: SEType) {
		if UserDefaults.standard.bool(forKey: kSEOn) == false {
			return
		}
		self.soundPlayer.sePlay(name: type.rawValue, type: "wav")
	}
	
	
	
	//MARK: - SoundPlayerDelegate
	func soundPlayerVoiceStop(sound: SoundPlayer, finish: Bool) {
		
		if self.bgmPlayState == 1 {
			self.bgmPlayState = 2
			if let path = Bundle.main.path(forResource: self.currentBGM.rawValue + "_loop", ofType: "wav") {
				print("LOOP: \(self.currentBGM.rawValue)")
				self.soundPlayer.setBGMSound(filepath: path)
			}
		}
		else if self.bgmPlayState == 0 {
			self.currentBGM = nil
		}
	}
}
