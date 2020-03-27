import Foundation

public protocol APIServiceParametrsProtocol {
    var jsonParametrs: [String: String] { get }
}

public protocol APIServiceProtocol: AnyObject {
    func getCollections(using parameters: APIServiceParametrsProtocol, identifier: String, completion: @escaping (Result<[String: Any], APIError>) -> Void)
    func getItemDetail(using parameters: APIServiceParametrsProtocol, identifier: String, completion: @escaping (Result<[String: Any], APIError>) -> Void)
    func cancelRequest(with identifier: String)
    func cancelAllRequests()
}

public final class APIService: APIServiceProtocol {

    public enum Language: String {
        case nl = "nl"
        case en = "en"
    }

    private enum Constants {
        static let basePath = "https://www.rijksmuseum.nl/api/"
    }

    private enum HTTPMethod: String {
        case GET

        // other http methods are not required for the task
    }

    fileprivate let apiKey: String
    fileprivate let language: Language
    fileprivate let queue: DispatchQueue
    fileprivate var dataTasks = [String : URLSessionDataTask]()

    public init(apiKey: String, language: Language, queue: DispatchQueue) {
        self.apiKey = apiKey
        self.language = language
        self.queue = queue
    }

    public func getCollections(using parameters: APIServiceParametrsProtocol, identifier: String, completion: @escaping (Result<[String: Any], APIError>) -> Void) {
        let path = "/collection"
        sendRequest(path: path, method: .GET, identifier: identifier, parameters: parameters.jsonParametrs) { (result: Result<[String : Any], APIError>) in
            // TODO
        }
    }

    public func getItemDetail(using parameters: APIServiceParametrsProtocol, identifier: String, completion: @escaping (Result<[String: Any], APIError>) -> Void){
    }

    public func cancelRequest(with identifier: String) {
        guard let dataTask = dataTasks[identifier] else {
            return
        }

        dataTask.cancel()
        dataTasks[identifier] = nil
    }

    public func cancelAllRequests() {
        dataTasks.forEach { (_, value: URLSessionDataTask) in
            value.cancel()
        }

        dataTasks.removeAll()
    }
}

extension APIService {

    private func sendRequest(path: String,
                             method: HTTPMethod,
                             identifier: String,
                             parameters: [String: String]? = nil,
                             completion: @escaping (Result<[String: Any], APIError>) -> Void) {
        let urlString = Constants.basePath + language.rawValue + path + "/"
        guard var components = URLComponents(string: urlString) else {
            completion(Result.failure(APIError.invalidRequest))
            return
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
            return
        }

        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // TODO
        }

        dataTask.resume()
        dataTasks[identifier] = dataTask
    }
}

