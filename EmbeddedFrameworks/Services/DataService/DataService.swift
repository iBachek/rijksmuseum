import Foundation

public protocol DataServiceHolderProtocol {
    var dataService: DataServiceProtocol { get }
}

public protocol DataServiceProtocol: AnyObject {
    func getArtObjects(requestIdentifier: String, parameters: ArtObjectsParameters, completion: @escaping (Result<ArtObjectsResponse, DSError>) -> Void)
    func getArtObjectDetails(parameters: ArtObjectDetailsParameters, completion: @escaping (Result<ArtObject, DSError>) -> Void)
    func cancelLoadArtObject(requestIdentifier: String)
}

public final class DataService: DataServiceProtocol {

    fileprivate let apiService: APIServiceProtocol
    fileprivate let operationQueue: OperationQueue
    fileprivate let queue: DispatchQueue

    public init(apiService: APIServiceProtocol, queue: DispatchQueue) {
        self.apiService = apiService
        self.queue = queue

        self.operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 3
    }

    public func getArtObjects(requestIdentifier: String, parameters: ArtObjectsParameters, completion: @escaping (Result<ArtObjectsResponse, DSError>) -> Void) {
        let operation = apiService.collectionsOperation(using: parameters)
        operation.name = requestIdentifier
        operation.completion = { [weak self] (result: Result<Data, APIError>) in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let data):
                do {
                    let response: ArtObjectsResponse = try JSONDecoder().decode(ArtObjectsResponse.self, from: data)
                    self.queue.async {
                        completion(Result.success(response))
                    }
                } catch let error {
                    self.queue.async {
                        // .typeMismatch, .valueNotFound, .keyNotFound, .dataCorrupted
                        completion(Result.failure(DSError.decodingError(error)))
                    }
                }

            case .failure(let error):
                self.queue.async {
                    completion(Result.failure(DSError.apiError(error)))
                }
            }
        }

        operationQueue.addOperation(operation)
    }

    public func getArtObjectDetails(parameters: ArtObjectDetailsParameters, completion: @escaping (Result<ArtObject, DSError>) -> Void) {
        let operation = apiService.itemDetailsOperation(itemID: parameters.artObject.id, parameters: parameters)
        operation.name = parameters.artObject.id
        operation.queuePriority = .veryHigh
        operation.completion = { [weak self] (result: Result<Data, APIError>) in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let data):
                do {
                    let response: ArtObjectDetailsResponse = try JSONDecoder().decode(ArtObjectDetailsResponse.self, from: data)
                    self.queue.async {
                        completion(Result.success(response.artObject))
                    }
                } catch let error {
                    self.queue.async {
                        // .typeMismatch, .valueNotFound, .keyNotFound, .dataCorrupted
                        completion(Result.failure(DSError.decodingError(error)))
                    }
                }

            case .failure(let error):
                self.queue.async {
                    completion(Result.failure(DSError.apiError(error)))
                }
            }
        }

        operationQueue.addOperation(operation)
    }

    public func cancelLoadArtObject(requestIdentifier: String) {
        if let operation = operationQueue.operations.first(where: { $0.name == requestIdentifier }) {
            operation.cancel()
        }
    }
}
