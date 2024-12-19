import CoreHaptics
import Mockable

@Mockable
public protocol HapticEngineProtocol {
    func prepare()
    func play()
}

public enum HapticEngine {
    public typealias FinishedHandler = () throws -> FinishedAction
    
    /// what the engine will do when it is finished running
    public enum FinishedAction: Int {
        
        /// Stop the engine.  This is useful if the client knows that the client is about to go inactive.
        case stop = 1
        /// Do not stop the engine.  This is useful if the client expects more activity.
        case leaveRunning = 2
    }
    
    /// the reason why the engine has stopped
    public enum StoppedReason: Int {
        
        /// The AVAudioSession bound to this engine has been interrupted.
        case audioSessionInterrupt = 1
        
        /// The application owning this engine has been suspended (i.e., put into the background).
        case applicationSuspended = 2
        
        /// The engine has stopped due to an idle timeout when the engine's `autoShutdownEnabled` property was set to YES.
        case idleTimeout = 3
        
        /// The engine has stopped due to a call to a `FinishedHandler` returning `FinishedAction.stop`
        case notifyWhenFinished = 4
        
        /// The engine has stopped because the CHHapticEngine instance was destroyed.
        case engineDestroyed = 5
        
        /// The engine has stopped because the Game Controller associated with this engine disconnected.
        case gameControllerDisconnect = 6
        
        /// An error has occurred.
        case systemError = -1
    }
}
