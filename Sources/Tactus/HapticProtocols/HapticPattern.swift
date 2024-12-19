import Mockable
import Foundation

@Mockable
/// A protocol representing a haptic pattern.
/// Based on Apple's `CoreHaptics.CHHapticPattern`
public protocol HapticPatternDefining {
    /// A dictionary representation of a haptic pattern.
    typealias Definition = [HapticPattern.Key: Any]
    
    /// The duration represents the start time of the last event or parameter, plus that event's duration if present.
    var duration: TimeInterval { get }
    
    /// Exports a dictionary represetation of the haptic pattern.
    /// Throws any error encountered during the export process.
    func export() async throws -> Definition
}

/// Convenience namespace for haptic pattern related types.
public enum HapticPattern {
    /// A key that represents a specific value in a haptic pattern dictionary.
    public enum Key: Hashable {
        /// the beginning of a haptic event definition
        case event
        /// the duration of an event.
        case eventDuration
        /// the beginning of an array of fixed parameter definitions.
        case eventParameters
        /// the type of event.
        case eventType
        /// a flag which indicates whether to loop custom audio events.
        case eventWaveformLoopEnabled
        /// the path to the local file that contains the audio waveform.
        case eventWaveformPath
        /// whether audio file playback fades in and out using an envelope.
        case eventWaveformUseVolumeEnvelope
        /// the beginning of a parameter definition.
        case parameter
        /// the beginning of a parameter curve definition.
        case parameterCurve
        /// the control points of a parameter curve.
        case parameterCurveControlPoints
        /// the parameter ID.
        case parameterID
        /// the value of a parameter.
        case parameterValue
        /// the beginning of a haptic pattern definition.
        case pattern
        /// the relative time for an event or parameter, in seconds.
        case time
        /// the version number of a haptic pattern dictionary.
        case version
    }
}
