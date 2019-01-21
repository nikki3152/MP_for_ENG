//
//  SoundPlayer.swift
//
//  Copyright (c) 2014年 STUDIO SHIN. All rights reserved.
//

import AVFoundation

protocol SoundPlayerDelegate {
	func soundPlayerVoiceStop(sound: SoundPlayer, finish: Bool)
}

class SoundPlayer: NSObject, AVAudioPlayerDelegate {
	
	//プロパティ
	var bgmPlayer: AVAudioPlayer?	//BGMプレイヤー
	var voicePlayer: AVAudioPlayer?	//VOICEプレイヤー
	var isBGMPause: Bool = false	//BGM一時停止フラグ
	var bgmVolume: Float = 0.5		//BGMの音量
	var voiceVolume: Float = 0.5	//VOICEの音量
	var seVolume: Float = 0.5		//SEの音量
	var sePlayers: Set<AVAudioPlayer> = []	//SEのプレイヤーを格納するセット
	var spDelegate: SoundPlayerDelegate?
	
	//BGM再生開始
	func setBGMSound(filepath: String) {
		self.bgmStop()
		let url = URL(fileURLWithPath: filepath, isDirectory: false)
		self.bgmPlayer = try? AVAudioPlayer(contentsOf: url)
		self.bgmPlayer?.delegate = self
		self.bgmPlayer?.numberOfLoops = -1
		self.bgmPlayer?.volume = self.bgmVolume
		self.bgmPlayer?.play()
	}
	//BGM停止
	func bgmStop() {
		self.isBGMPause = false
		self.bgmPlayer?.stop()
	}
	//BGM一時停止
	func bgmPause(pause: Bool) {
		if self.isBGMPause != pause {
			self.isBGMPause = pause;
			if self.isBGMPause {
				self.bgmPlayer?.pause()
			}
			else {
				self.bgmPlayer?.play()
			}
		}
	}
	func isBGMPlaying() -> Bool {
		
		var ret: Bool = false
		if let player = self.bgmPlayer {
			ret = player.play()
		}
		return ret
	}
	
	//Voice再生
	func voicePlay(name: String, type: String) {
		if self.voicePlayer == nil {
			if let path: String = Bundle.main.path(forResource: name, ofType: type) {
				let url: NSURL? = NSURL(fileURLWithPath: path, isDirectory: false)
				if url != nil {
					self.voicePlayer = try? AVAudioPlayer(contentsOf: url! as URL)
					self.voicePlayer?.delegate = self
					self.voicePlayer?.numberOfLoops = 0
					self.voicePlayer?.volume = self.voiceVolume
					self.voicePlayer?.play()
				}
			}
		}
	}
	//Voice停止
	func voiceStop() {
		if let p = self.voicePlayer {
			p.stop()
			self.voicePlayer = nil
			self.spDelegate?.soundPlayerVoiceStop(sound: self, finish: false)
		}
	}
	
	
	//SE再生
	func sePlay(name: String, type: String) {
		if let path = Bundle.main.path(forResource: name, ofType: type) {
			let url: NSURL? = NSURL(fileURLWithPath: path, isDirectory: false)
			if url != nil {
				let p = try? AVAudioPlayer(contentsOf: url! as URL)
				self.sePlayers.insert(p!)
				p?.delegate = self
				p?.volume = self.seVolume
				p?.play()
			}
		}
	}
	
	
	//AVAudioPlayerデリゲートメソッド
	//再生終了
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		
		for pl in self.sePlayers {
			if pl == player {
				self.sePlayers.remove(pl)
				break
			}
		}
		
		if self.voicePlayer != nil {
			if player === self.voicePlayer {
				self.voicePlayer = nil
				print("ボイスストップ")
				self.spDelegate?.soundPlayerVoiceStop(sound: self, finish: true)
			}
		}
	}
	
}



