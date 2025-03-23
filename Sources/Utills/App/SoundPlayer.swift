import AVFoundation
import SwiftUI

// TBPlayer 类负责管理和播放应用中的音效
class SoundPlayer: ObservableObject {

    static let shared = SoundPlayer()

    // 音频播放器实例
    private var windupSound: AVAudioPlayer  // 上弦声音
    private var dingSound: AVAudioPlayer  // 叮声音
    private var tickingSound: AVAudioPlayer  // 滴答声音

    // 音量设置，使用 AppStorage 持久化
    @AppStorage("windupVolume") var windupVolume: Double = 1.0 {
        didSet {
            setVolume(windupSound, windupVolume)
        }
    }
    @AppStorage("dingVolume") var dingVolume: Double = 1.0 {
        didSet {
            setVolume(dingSound, dingVolume)
        }
    }
    @AppStorage("tickingVolume") var tickingVolume: Double = 1.0 {
        didSet {
            setVolume(tickingSound, tickingVolume)
        }
    }

    // 初始化音频播放器
    private init() {
        // 加载音频资源
        let windupSoundAsset = NSDataAsset(name: "windup")
        let dingSoundAsset = NSDataAsset(name: "ding")
        let tickingSoundAsset = NSDataAsset(name: "ticking")

        let wav = AVFileType.wav.rawValue
        do {
            // 创建音频播放器实例
            windupSound = try AVAudioPlayer(
                data: windupSoundAsset!.data, fileTypeHint: wav)
            dingSound = try AVAudioPlayer(
                data: dingSoundAsset!.data, fileTypeHint: wav)
            tickingSound = try AVAudioPlayer(
                data: tickingSoundAsset!.data, fileTypeHint: wav)
        } catch {
            fatalError("Error initializing players: \(error)")
        }

        // 准备播放
        windupSound.prepareToPlay()
        dingSound.prepareToPlay()
        tickingSound.numberOfLoops = -1  // 设置滴答声循环播放
        tickingSound.prepareToPlay()

        // 设置初始音量
        setVolume(windupSound, windupVolume)
        setVolume(dingSound, dingVolume)
        setVolume(tickingSound, tickingVolume)
        logger.append(event: Init(object: "SoundPlayer"))
    }

    // 播放上弦声音
    func playWindup() {
        if !AppSetter.shared.appSound {
            windupSound.play()
        }
    }

    // 播放叮声音
    func playDing() {
        if !AppSetter.shared.appSound {
            dingSound.play()
        }
    }

    // 开始播放滴答声
    func startTicking() {
        if !AppSetter.shared.appSound {
            tickingSound.play()
        }
    }

    // 停止播放滴答声
    func stopTicking() {
        tickingSound.stop()
    }
    
    // 设置音频播放器音量的辅助方法
    private func setVolume(_ sound: AVAudioPlayer, _ volume: Double) {
        sound.setVolume(Float(volume), fadeDuration: 0)
    }

}
