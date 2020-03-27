import Foundation

public protocol DataServiceHolderProtocol {
    var dataService: DataServiceProtocol { get }
}

public protocol DataServiceProtocol: AnyObject {
    func getArtObjects(requestIdentifier: String, parameters: ArtObjectsParameters, completion: @escaping (Result<[ArtObject], APIError>) -> Void)
    func getArtObjectDetails(parameters: ArtObjectDetailsParameters, completion: @escaping (Result<ArtObject, APIError>) -> Void)
}

public final class DataService: DataServiceProtocol {

    fileprivate let apiService: APIServiceProtocol
    fileprivate let queue: DispatchQueue

    public init(apiService: APIServiceProtocol, queue: DispatchQueue) {
        self.apiService = apiService
        self.queue = queue
    }

    public func getArtObjects(requestIdentifier: String, parameters: ArtObjectsParameters, completion: @escaping (Result<[ArtObject], APIError>) -> Void) {
        apiService.getCollections(using: parameters, identifier: requestIdentifier) { (result: Result<[String : Any], APIError>) in
            switch result {
            case .success(let dictionary):
                let artObjects: [ArtObject] = try! JSONDecoder().decode([ArtObject].self, from: Data())

            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }

    public func getArtObjectDetails(parameters: ArtObjectDetailsParameters, completion: @escaping (Result<ArtObject, APIError>) -> Void) {

    }
}
