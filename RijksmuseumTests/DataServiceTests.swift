import XCTest
@testable import Services

class DataServiceTests: XCTestCase {

    lazy var apiService = APIServiceMock()
    lazy var dataService = DataService(apiService: apiService, queue: DispatchQueue.main)

    func testGetArtObjects() throws {
        let identifier = "identifier"
        dataService.getArtObjects(requestIdentifier: identifier, parameters: ArtObjectsParameters(offset: 0, limit: 1), completion: { _ in })

        XCTAssertTrue(apiService.isGetCollectionsCalled)
    }
}

final class APIServiceMock: APIServiceProtocol {

    var isGetCollectionsCalled = false
    func collectionsOperation(using parameters: APIServiceParametrsProtocol) -> APIOperationProtocol {
        isGetCollectionsCalled = true
        return APIOperationMock(requestParameters: parameters)
    }

    func itemDetailsOperation(itemID: String, parameters: APIServiceParametrsProtocol) -> APIOperationProtocol {
        return APIOperationMock(requestParameters: parameters)
    }
}

final class APIOperationMock: Operation, APIOperationProtocol {

    var path = "path"
    var httpMethod = HTTPMethod.GET
    let requestParameters: APIServiceParametrsProtocol
    var completion: ((Result<Data, APIError>) -> Void)?

    init(requestParameters: APIServiceParametrsProtocol) {
        self.requestParameters = requestParameters
        super.init()
    }
}
