import Services

enum RMError: Error {
    case noInternet
    case somethingWrong

    var description: String {
        switch self {
        case .noInternet:
            return "No internet connection"

        case .somethingWrong:
            return "Oops something went wrong"
        }
    }

//    init(<#parameters#>) {
//        <#statements#>
//    }
}
