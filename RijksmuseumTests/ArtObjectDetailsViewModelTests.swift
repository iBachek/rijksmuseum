import XCTest
@testable import Rijksmuseum
@testable import Services

class ArtObjectDetailsViewModelTests: XCTestCase {

    let appContext = AppContextMock()

    func testConfigure() throws {
        let value = artObject(from: artObjectData)
        let parameters = ArtObjectDetailsParameters(artObject: value)
        let viewModel = ArtObjectDetailsViewModel(requestParameters: parameters, context: appContext)
        let view = ArtObjectDetailsViewMock()
        viewModel.configure(view: view) { _ in }

        XCTAssertEqual(view.imagePath, value.imagePath)
        XCTAssertEqual(view.title, value.title)
        XCTAssertEqual(view.description, value.description)
    }

    func artObject(from data: Data) -> ArtObject {
        let response: ArtObjectDetailsResponse = try! JSONDecoder().decode(ArtObjectDetailsResponse.self, from: data)
        return response.artObject
    }

    var artObjectData: Data {
        let response = [
            "artObject": [
                "objectNumber": "SK-C-597",
                "title": "Portrait of a Woman, Possibly Maria Trip",
                "description": "Portret van Maria Trip (1619-83), zuster van Jacobus Trip en later de echtgenote van Balthasar Coymans. Staande, ten halven lijve, naar links. De linkerarm rust op een trapleuning, in de hand een waaier.",
                "webImage": [
                    "guid": "165d03bb-95e8-4447-a911-865f1bd201d6",
                    "offsetPercentageX": 50,
                    "offsetPercentageY": 35,
                    "width": 2031,
                    "height": 2676,
                    "url": "https://lh3.googleusercontent.com/AyiKhdEWJ7XmtPXQbRg_kWqKn6mCV07bsuUB01hJHjVVP-ZQFmzjTWt7JIWiQFZbb9l5tKFhVOspmco4lMwqwWImfgg=s0"
                ]
            ]
        ]

        let jsonData = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
        return jsonData
    }
}

class ArtObjectDetailsViewMock: ArtObjectViewProtocol {

    var imagePath: String?
    var title: String?
    var description: String?

    func setImagePath(_ imagePath: String) {
        self.imagePath = imagePath
    }

    func setTitle(_ text: String) {
        self.title = text
    }

    func setDescription(_ text: String?) {
        self.description = text
    }
}

class AppContextMock: DataServiceHolderProtocol {
    var dataService: DataServiceProtocol = DataServiceMock()
}

class DataServiceMock: DataServiceProtocol {

    func getArtObjects(requestIdentifier: String, parameters: ArtObjectsParameters, completion: @escaping (Result<ArtObjectsResponse, DSError>) -> Void) {

    }

    func getArtObjectDetails(parameters: ArtObjectDetailsParameters, completion: @escaping (Result<ArtObject, DSError>) -> Void) {

    }

    func cancelLoadArtObject(requestIdentifier: String) {

    }
}
