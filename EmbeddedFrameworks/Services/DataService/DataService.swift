import Foundation

public protocol DataServiceHolderProtocol {
    var dataService: DataServiceProtocol { get }
}

public protocol DataServiceProtocol: AnyObject {
    func getArtObjects(requestIdentifier: String, parameters: ArtObjectsParameters, completion: @escaping (Result<ArtObjectsResponse, APIError>) -> Void)
    func getArtObjectDetails(parameters: ArtObjectDetailsParameters, completion: @escaping (Result<ArtObject, APIError>) -> Void)
    func cancelLoadArtObject(requestIdentifier: String)
}

public final class DataService: DataServiceProtocol {

    fileprivate let apiService: APIServiceProtocol
    fileprivate let queue: DispatchQueue

    public init(apiService: APIServiceProtocol, queue: DispatchQueue) {
        self.apiService = apiService
        self.queue = queue
    }

    public func getArtObjects(requestIdentifier: String, parameters: ArtObjectsParameters, completion: @escaping (Result<ArtObjectsResponse, APIError>) -> Void) {
        apiService.getCollections(using: parameters, identifier: requestIdentifier) { [weak self] (result: Result<Data, APIError>) in
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
//                    print(error)
                }

            case .failure(let error):
                self.queue.async {
                    completion(Result.failure(error))
                }
            }
        }
    }

    public func getArtObjectDetails(parameters: ArtObjectDetailsParameters, completion: @escaping (Result<ArtObject, APIError>) -> Void) {
        apiService.getItemDetails(itemID: parameters.artObject.id) { [weak self] (result: Result<Data, APIError>) in
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
//                    print(error)
                }

            case .failure(let error):
                self.queue.async {
                    completion(Result.failure(error))
                }
            }
        }
    }

    public func cancelLoadArtObject(requestIdentifier: String) {
        apiService.cancelRequest(with: requestIdentifier)
    }
}
