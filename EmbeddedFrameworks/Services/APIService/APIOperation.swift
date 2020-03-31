import Foundation

public protocol APIOperationProtocol: Operation {
    var path: String { get }
    var httpMethod: HTTPMethod  { get }
    var requestParameters: APIServiceParametrsProtocol { get }
    var completion: ((Result<Data, APIError>) -> Void)? { get set }
}

final class APIOperation: Operation, APIOperationProtocol {

    let path: String
    let httpMethod: HTTPMethod
    let requestParameters: APIServiceParametrsProtocol
    let requestor: APIRequestorProtocol
    var completion: ((Result<Data, APIError>) -> Void)?

    private var dataTask: URLSessionDataTask?

    enum OperationState : Int {
        case ready
        case executing
        case finished
    }

    // Default state is '.ready' (when the operation is created)
    private var state : OperationState = .ready {
        willSet {
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isFinished")
        }

        didSet {
            self.didChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isFinished")
        }
    }

    override var isReady: Bool {
        return state == .ready
    }

    override var isExecuting: Bool {
        return state == .executing
    }

    override var isFinished: Bool {
        return state == .finished
    }

    override var isAsynchronous: Bool {
        return true
    }

    init(path: String, httpMethod: HTTPMethod, requestParameters: APIServiceParametrsProtocol, requestor: APIRequestorProtocol) {
        self.path = path
        self.httpMethod = httpMethod
        self.requestParameters = requestParameters
        self.requestor = requestor
        super.init()
    }

    override func start() {
        guard !isCancelled else {
            state = .finished
            return
        }

        // Set the state to executing
        state = .executing

        // Prepare data task
        let parameters = requestParameters.jsonParametrs
        dataTask = requestor.dataTask(path: path, method: httpMethod, parameters: parameters) { [weak self] (result: Result<Data, APIError>) in
            guard let self = self else {
                return
            }

            guard !self.isCancelled else {
                self.state = .finished
                return
            }

            self.completion?(result)
            self.state = .finished
        }

        // Start data task or call result with error
        guard dataTask != nil else {
            state = .finished
            return
        }

        dataTask?.resume()
    }

    override func cancel() {
        super.cancel()

        dataTask?.cancel()
    }
}
