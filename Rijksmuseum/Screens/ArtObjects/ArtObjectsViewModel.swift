import Services

protocol ArtObjectsViewModelProtocol: AnyObject {
    var delegate: ArtObjectsViewModelDelegate? { get set }

    func itemsCount() -> Int
    func loadArtObject(at indexPath: IndexPath, completion: @escaping (Result<Void, RMError>) -> Void)
    func cancelLoadArtObject(at indexPath: IndexPath)
    @discardableResult func configure(view: ArtObjectViewProtocol, indexPath: IndexPath) -> Bool
}

protocol ArtObjectsViewModelDelegate: AnyObject {
    func reloadDataSource()
}

final class ArtObjectsViewModel: ArtObjectsViewModelProtocol {

    typealias Context = DataServiceHolderProtocol
    let context: Context
    var artObjects: [ArtObject?]
    var delegate: ArtObjectsViewModelDelegate?

    init(context: DataServiceHolderProtocol) {
        self.context = context
        self.artObjects = [ArtObject?]()
    }

    func itemsCount() -> Int {
        if artObjects.isEmpty {
            return 10
        } else {
            return artObjects.count
        }
    }

    func loadArtObject(at indexPath: IndexPath, completion: @escaping (Result<Void, RMError>) -> Void) {
        let identifier = "\(indexPath.item)"
        let requestParameters = ArtObjectsParameters(offset: indexPath.item, limit: 1)
        context.dataService.getArtObjects(requestIdentifier: identifier, parameters: requestParameters) { [weak self] (result: Result<ArtObjectsResponse, APIError>) in
            switch result {
            case .success(let response):
                if let isEmpty = self?.artObjects.isEmpty, isEmpty {
                    self?.artObjects = [ArtObject?].init(repeating: nil, count: response.artObjectsCount)
                    self?.artObjects[indexPath.item] = response.artObjects.first
                } else {
                    self?.artObjects[indexPath.item] = response.artObjects.first
                }

                completion(Result.success(()))

            case .failure(let error):
                print(error)
                completion(Result.failure(RMError.somethingWrong))
            }
        }
    }

    func cancelLoadArtObject(at indexPath: IndexPath) {
        context.dataService.cancelLoadArtObject(requestIdentifier: "\(indexPath.item)")
    }

    func configure(view: ArtObjectViewProtocol, indexPath: IndexPath) -> Bool {
        guard let element = artObjects.safetyItem(at: indexPath.item) else {
            return false
        }

        guard let artObject = element else {
            return false
        }

        view.setImagePath(artObject.imagePath)
        view.setTitle(artObject.title)

        return true
    }
}
