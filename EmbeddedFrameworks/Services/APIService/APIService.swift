import Foundation

public protocol APIServiceParametrsProtocol {
    var jsonParametrs: [String: String] { get }
}

public protocol APIServiceProtocol: AnyObject {
    func collectionsOperation(using parameters: APIServiceParametrsProtocol) -> APIOperationProtocol
    func itemDetailsOperation(itemID: String, parameters: APIServiceParametrsProtocol) -> APIOperationProtocol
}

public final class APIService: APIServiceProtocol {

    public enum Language: String {
        case nl = "nl"
        case en = "en"
    }

    fileprivate let apiKey: String?
    fileprivate let language: Language?
    fileprivate let requestor: APIRequestorProtocol?
    fileprivate var operations = [String : APIOperationProtocol]()

    public init(requestor: APIRequestorProtocol) {
        self.apiKey = nil
        self.language = nil
        self.requestor = requestor
    }

    public init(apiKey: String, language: Language) {
        self.apiKey = apiKey
        self.language = language
        self.requestor = nil
    }

    public func collectionsOperation(using parameters: APIServiceParametrsProtocol) -> APIOperationProtocol {
        let path = "/collection"
        let operation: APIOperation = {
            if let requestor = requestor {
                return APIOperation(path: path, httpMethod: .GET, requestParameters: parameters, requestor: requestor)
            } else {
                let key = apiKey ?? ""
                let lang = language ?? .en
                let requestor = APIRequestor(apiKey: key, language: lang)
                return APIOperation(path: path, httpMethod: .GET, requestParameters: parameters, requestor: requestor)
            }
        }()

        return operation
    }

    public func itemDetailsOperation(itemID: String, parameters: APIServiceParametrsProtocol) -> APIOperationProtocol {
        let path = "/collection/\(itemID)"
        let operation: APIOperation = {
            if let requestor = requestor {
                return APIOperation(path: path, httpMethod: .GET, requestParameters: parameters, requestor: requestor)
            } else {
                let key = apiKey ?? ""
                let lang = language ?? .en
                let requestor = APIRequestor(apiKey: key, language: lang)
                return APIOperation(path: path, httpMethod: .GET, requestParameters: parameters, requestor: requestor)
            }
        }()
        
        return operation
    }
}
