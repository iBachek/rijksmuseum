import Foundation

public enum HTTPMethod: String {
    case GET

    // other http methods are not required for the task
}

public protocol APIRequestorProtocol: AnyObject {
    func dataTask(path: String,
                  method: HTTPMethod,
                  parameters: [String: String]?,
                  completion: @escaping (Result<Data, APIError>) -> Void) -> URLSessionDataTask?
}

public final class APIRequestor: APIRequestorProtocol {

    private enum Constants {
        static let basePath = "https://www.rijksmuseum.nl/api/"
    }

    fileprivate let apiKey: String
    fileprivate let language: APIService.Language

    init(apiKey: String, language: APIService.Language) {
        self.apiKey = apiKey
        self.language = language
    }

    public func dataTask(path: String,
                         method: HTTPMethod,
                         parameters: [String: String]?,
                         completion: @escaping (Result<Data, APIError>) -> Void) -> URLSessionDataTask? {
        let urlString = Constants.basePath + language.rawValue + path + "/"
        guard var components = URLComponents(string: urlString) else {
            completion(Result.failure(APIError.invalidRequest))
            return nil
        }

        var requestParameters: [String: String] = {
            if let parameters = parameters {
                return parameters
            } else {
                return [String: String]()
            }
        }()

        requestParameters["key"] = apiKey
        components.queryItems = requestParameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }

        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        guard let url = components.url else {
            completion(Result.failure(APIError.invalidRequest))
            return nil
        }

        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error as NSError? {
                switch error.code {
                case -999:
                    completion(Result.failure(APIError.canceled))

                case -1009:
                    completion(Result.failure(APIError.noInternet))

                default:
                    completion(Result.failure(APIError.invalidResponse))
                }

                return
            }

            guard let data = data else {
                completion(Result.failure(APIError.invalidResponse))
                return
            }

            completion(Result.success(data))
        }

        return dataTask
    }
}
