import XCTest
@testable import Services

class DataServiceTests: XCTestCase {

    lazy var apiService = APIServiceMock()
    lazy var dataService = DataService(apiService: apiService, queue: DispatchQueue.main)

    func testGetArtObjects() throws {
        let identifier = "identifier"
        dataService.getArtObjects(requestIdentifier: identifier, parameters: ArtObjectsParameters(offset: 0, limit: 1), completion: { _ in })

        XCTAssertTrue(apiService.isGetCollectionsCalled)
        XCTAssertEqual(apiService.getCollectionsRequestIdentifier, identifier)
    }
}

final class APIServiceMock: APIServiceProtocol {

    var isGetCollectionsCalled = false
    var getCollectionsRequestIdentifier: String?

    func getCollections(using parameters: APIServiceParametrsProtocol, identifier: String, completion: @escaping (Result<Data, APIError>) -> Void) {
        isGetCollectionsCalled = true
        getCollectionsRequestIdentifier = identifier
    }

    func getItemDetails(itemID: String, completion: @escaping (Result<Data, APIError>) -> Void) {

    }

    func cancelRequest(with identifier: String) {

    }

    func cancelAllRequests() {

    }
}
