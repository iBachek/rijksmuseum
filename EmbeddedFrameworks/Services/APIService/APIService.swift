import Foundation

public protocol APIServiceParametrsProtocol {
    var jsonParametrs: [String: String] { get }
}

public protocol APIServiceProtocol: AnyObject {
    func getCollections(using parameters: APIServiceParametrsProtocol, identifier: String, completion: @escaping (Result<Data, APIError>) -> Void)
    func getItemDetails(itemID: String, completion: @escaping (Result<Data, APIError>) -> Void)
    func cancelRequest(with identifier: String)
    func cancelAllRequests()
}

public final class APIService: APIServiceProtocol {

    public enum Language: String {
        case nl = "nl"
        case en = "en"
    }

    fileprivate let requestor: APIRequestorProtocol
    fileprivate var dataTasks = [String : URLSessionDataTask]()

    public init(requestor: APIRequestorProtocol) {
        self.requestor = requestor
    }

    public init(apiKey: String, language: Language) {
        self.requestor = APIRequestor(apiKey: apiKey, language: language)
    }

    public func getCollections(using parameters: APIServiceParametrsProtocol, identifier: String, completion: @escaping (Result<Data, APIError>) -> Void) {
        let path = "/collection"
        let jsonParametrs = parameters.jsonParametrs

        let dataTask = requestor.dataTask(path: path, method: .GET, parameters: jsonParametrs) { [weak self] (result: Result<Data, APIError>) in
            self?.dataTasks[identifier] = nil
            completion(result)
        }

        if let task = dataTask {
            dataTasks[identifier] = task
        }
    }

    public func getItemDetails(itemID: String, completion: @escaping (Result<Data, APIError>) -> Void) {
        let path = "/collection/\(itemID)"
        guard dataTasks[path] == nil else {
            return
        }

        let dataTask = requestor.dataTask(path: path, method: .GET, parameters: nil) { [weak self] (result: Result<Data, APIError>) in
            self?.dataTasks[path] = nil
            completion(result)
        }

        if let task = dataTask {
            dataTasks[path] = task
        }
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
