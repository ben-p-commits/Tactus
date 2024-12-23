import Mockable
import Foundation

@Mockable
/// A protocol which describes the capabilities of a haptic engine
/// Based on Apple's `CoreHaptics.CHHapticEngine`
public protocol HapticRunning {
    
    /// Get the protocol that describes haptic and audio capabilities on this device.
    var capabilitiesForHardware: HapticDeviceCapability { get }
    
    /// The absolute time from which all current and future event times may be calculated. The units are seconds.
    var currentTime: TimeInterval { get }
    
    /// The engine will call this block when it has stopped due to external causes (such as
    /// an audio session interruption or the app going into the background). It will NOT be
    /// called if the client calls `stopWithCompletionHandler`.
    var stoppedHandler: HapticEngine.StoppedHandler? { get set }
    
    /// A block which is called asynchronously if the haptic engine has reset itself due a server failure.
    ///
    /// In response to this handler, the app must reload all custom audio resources and recreate all necessary
    /// pattern players.  The engine must of course be restarted.  CHHapticPatterns do not need to be re-created.
    /// All callbacks are delivered on an internal queue which guarantees proper delivery order and allows reentrant
    /// calls to the API.
    var resetHandler: HapticEngine.ResetHandler? { get set }
    
    /// if enabled the engine will ignore all events of type `EventType.audio` and play only haptic events.
    var playsHapticsOnly: Bool { get set }
    
    // TODO: must be unavailable in watchos
    var playsAudioOnly: Bool { get set }
    
    /// When enabled, the engine mutes audio playback from its players.
    var isMutedForAudio: Bool { get set }
    
    /// When enabled, the engine mutes haptic playback from its players.
    var isMutedForHaptics: Bool { get set }
    
    /// When enabled, the haptic engine can start and stop the hardware dynamically to conserve power.
    /// See `CHHapticEngine.isAutoShutdownEnabled` for more details on Apple's implementation
    var autoShutdownEnabled: Bool { get set }
    
    // MARK: - Starting the engine
    
    /// Asynchronously start the engine. The handler will be called when the operation completes.
    func startWithCompletionHandler(handler: HapticEngine.CompletionHandler?)
    
    /// Start the engine and block until the engine has started. This is useful for synchronous initialization
    func startAndReturnError() throws
    
    /// Simple one-shot call to play a pattern specified by a URL containing a file with a haptic/audio pattern dictionary.
    ///
    /// - Note: The engine should be started prior to calling this method if low latency is desired.
    /// If this is not done, this method will start it, which can cause a significant delay.
    func playPattern(from url: URL) throws
    
    /// Simple one-shot call to play a pattern specified by the provided haptic/audio pattern dictionary `Data`.
    ///
    /// - Note: The engine should be started prior to calling this method if low latency is desired.
    /// If this is not done, this method will start it, which can cause a significant delay.
    func playPattern(from data: Data) throws
    
    /// Tell the engine to asynchronously call the passed-in handler when all active pattern players associated
    /// with this engine have stopped.
    ///
    /// If additional players are started after this call is made, they will delay the callback.
    /// If no players are active or the engine is stopped, the callback will happen immediately.
    func notifyWhenPlayersFinished(handler: @escaping HapticEngine.FinishedHandler)
}

/// Convenience namespace for haptic engine related types
public enum HapticEngine {
    public typealias CompletionHandler = () throws -> Void
    public typealias FinishedHandler = () throws -> FinishedAction
    public typealias StoppedHandler = (StoppedReason) -> Void
    public typealias ResetHandler = () -> Void
    
    /// what the engine will do when it is finished running
    public enum FinishedAction {
        
        /// Stop the engine.  This is useful if the client knows that the client is about to go inactive.
        case stop
        /// Do not stop the engine.  This is useful if the client expects more activity.
        case leaveRunning
    }
    
    /// the reason why the engine has stopped
    public enum StoppedReason {
        
        /// The AVAudioSession bound to this engine has been interrupted.
        case audioSessionInterrupt
        
        /// The application owning this engine has been suspended (i.e., put into the background).
        case applicationSuspended
        
        /// The engine has stopped due to an idle timeout when the engine's `autoShutdownEnabled` property was set to YES.
        case idleTimeout
        
        /// The engine has stopped due to a call to a `FinishedHandler` returning `FinishedAction.stop`
        case notifyWhenFinished
        
        /// The engine has stopped because the CHHapticEngine instance was destroyed.
        case engineDestroyed
        
        /// The engine has stopped because the Game Controller associated with this engine disconnected.
        case gameControllerDisconnect
        
        /// An error has occurred.
        case systemError
    }
}
