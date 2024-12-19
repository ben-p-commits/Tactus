import Mockable

@Mockable
/// A protocol which describes the capabilities of haptic device
/// Based on Apple's `CoreHaptics.CHHapticDeviceCapability`
public protocol HapticDeviceCapability {
    var supportsHaptics: Bool { get }
    var supportsAudio: Bool { get }
}
