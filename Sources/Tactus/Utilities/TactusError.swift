import Foundation

enum TactusError: String, Error {
    case hapticsNotSupported
    var code: Int {
        // TODO: Implement
        1
    }
    
    var nsError: NSError {
        return NSError(domain: "tactus", code: code, userInfo: [NSLocalizedDescriptionKey: self.rawValue])
    }
}
