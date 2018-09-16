import Foundation

// https://developer.apple.com/swift/blog/?id=15
extension Optional {
    func precondition(_ message: @autoclosure () -> String = "Object cannot be nil", file: StaticString = #file, line: UInt = #line) -> Wrapped {
        guard let unwrapped = self else {
            preconditionFailure("\(message()) in \(file) on line \(line)")
        }
        return unwrapped
    }
}
