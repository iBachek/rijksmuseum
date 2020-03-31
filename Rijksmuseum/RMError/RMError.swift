import Services

enum RMError: Error {
    case dataService(DSError)

    var description: String {
        switch self {
        case .dataService(let dsError):
            return dsError.description
        }
    }
}

extension DSError {
    var description: String {
        switch self {
        case .apiError(let apiError):
            return apiError.description

        case .decodingError(let error):
            return error.localizedDescription
        }
    }
}

extension APIError {
    var description: String {
        switch self {
        case .undefined,
             .canceled:
            return "Oops something went wrong"

        case .noInternet:
            return "No internet connection"

        case .invalidRequest:
            return "Request is invalid"

        case .invalidResponse:
            return "Response is invalid"
        }
    }
}
