import CoreHaptics
import AVFoundation

/// A haptic-running engine type in the `Tactus` library.
///
/// It essentially acts as a convenience wrapper around `CHHapticEngine` while providing
/// some additional functionality.
struct TactusEngine: HapticRunning {
    
    private let engine: CHHapticEngine
    
//    init() throws {
//        do { self.engine = try CHHapticEngine() }
//    }
//    init(withAudioSession audioSession: AVAudioSession) throws {
//        // TODO: Implement
//    }
//    
//    
//    init(audioSession: AVAudioSession) throws {
//        // TODO: Implement
//    }
    
    var capabilitiesForHardware: any HapticDeviceCapability
    
    var currentTime: TimeInterval
    
    var stoppedHandler: HapticEngine.StoppedHandler?
    
    var resetHandler: HapticEngine.ResetHandler?
    
    var playsHapticsOnly: Bool = false
    
    var playsAudioOnly: Bool = false
    
    var isMutedForAudio: Bool
    
    var isMutedForHaptics: Bool
    
    var autoShutdownEnabled: Bool
    
    func startWithCompletionHandler(handler: HapticEngine.CompletionHandler?) {
        // TODO: Implement
    }
    
    func startAndReturnError() throws {
        // TODO: Implement
    }
    
    func playPattern(from url: URL) throws {
        // TODO: Implement
    }
    
    func playPattern(from data: Data) throws {
        // TODO: Implement
    }
    
    func notifyWhenPlayersFinished(handler: @escaping HapticEngine.FinishedHandler) {
        // TODO: Implement
    }
}
