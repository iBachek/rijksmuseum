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
        apiService.getCollections(using: parameters, identifier: requestIdentifier) { (result: Result<Data, APIError>) in
            switch result {
            case .success(let data):
                do {
                    let artObjectsResponse: ArtObjectsResponse = try JSONDecoder().decode(ArtObjectsResponse.self, from: data)
                    completion(Result.success(artObjectsResponse.artObjects))
                } catch let error {
                    print(error)
                }

            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }

    public func getArtObjectDetails(parameters: ArtObjectDetailsParameters, completion: @escaping (Result<ArtObject, APIError>) -> Void) {
        apiService.getItemDetails(itemID: parameters.artObjectID) { (result: Result<Data, APIError>) in
            switch result {
            case .success(let data):
                let artObject: ArtObject = try! JSONDecoder().decode(ArtObject.self, from: data)
                completion(Result.success(artObject))

            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
}
