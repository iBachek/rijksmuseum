import Foundation

public enum DSError: Error {
    case apiError(APIError)
    case decodingError(Error)
}
