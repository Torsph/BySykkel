import Foundation
import MapKit

public enum Result<T> {
    case success(T)
    case failure(Error)
}

enum BySykkelError: Error {
    case networkError(Int?)
}

extension BySykkelError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .networkError(let status):

            switch status {
            case .some(401):
                return "Something wrong with your access token"
            case .some(400..<500):
                return "Something wrong with our request"
            case .some(500..<600):
                return "Something went wrong on BySykkle's backend"
            default:
                return "Something wrong with the network"
            }
        }
    }
}

extension CLLocation {
    static let oslo = CLLocation(latitude: 59.911491, longitude: 10.757933)
}
