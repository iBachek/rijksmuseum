import XCTest
@testable import Services

class APIServiceTests: XCTestCase {

    lazy var apiRequestor = APIRequestorMock()
    lazy var apiService: APIServiceProtocol = APIService(requestor: apiRequestor)

    override func setUpWithError() throws {
        apiRequestor.path = nil
        apiRequestor.method = nil
        apiRequestor.parameters = nil
    }

    func testGetCollections() throws {
        let dictionary = ["key": "value"]
        let parameters = APIServiceParametrsMock(parameters: dictionary)
        let operation = apiService.collectionsOperation(using: parameters)
        operation.start()

        XCTAssertEqual(apiRequestor.path, "/collection")
        XCTAssertEqual(apiRequestor.method, HTTPMethod.GET)
        XCTAssertEqual(apiRequestor.parameters, dictionary)
    }
}

final class APIRequestorMock: APIRequestorProtocol {

    var path: String?
    var method: HTTPMethod?
    var parameters: [String: String]?

    public func dataTask(path: String,
                         method: HTTPMethod,
                         parameters: [String: String]?,
                         completion: @escaping (Result<Data, APIError>) -> Void) -> URLSessionDataTask? {
        self.path = path
        self.method = method
        self.parameters = parameters

        return nil
    }
}

struct APIServiceParametrsMock: APIServiceParametrsProtocol {
    let parameters: [String: String]

    var jsonParametrs: [String: String] {
        return parameters
    }
}
