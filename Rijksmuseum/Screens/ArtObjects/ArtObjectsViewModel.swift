import Services

protocol ArtObjectsViewModelProtocol: AnyObject {
    func itemsCount(completion: @escaping (Result<Int, RMError>) -> Void)
    func loadArtObject(at indexPath: IndexPath, completion: @escaping (Result<Void, RMError>) -> Void)
    func cancelLoadArtObject(at indexPath: IndexPath)
    @discardableResult func configure(view: ArtObjectViewProtocol, indexPath: IndexPath) -> Bool
    func artObjectDetailsParameters(at indexPath: IndexPath) -> ArtObjectDetailsParameters?
    func didReceiveMemoryWarning()
}

final class ArtObjectsViewModel: ArtObjectsViewModelProtocol {

    typealias Context = DataServiceHolderProtocol
    let context: Context
    var artObjects: [ArtObject?]

    init(context: DataServiceHolderProtocol) {
        self.context = context
        self.artObjects = [ArtObject?]()
    }

    func itemsCount(completion: @escaping (Result<Int, RMError>) -> Void) {
        let identifier = "itemsCount"
        let requestParameters = ArtObjectsParameters(offset: 0, limit: 20)
        context.dataService.getArtObjects(requestIdentifier: identifier, parameters: requestParameters) { [weak self] (result: Result<ArtObjectsResponse, DSError>) in
            switch result {
            case .success(let response):
                self?.artObjects = [ArtObject?](repeating: nil, count: response.artObjectsCount)
                completion(Result.success(response.artObjectsCount))

            case .failure(let error):
                completion(Result.failure(RMError.dataService(error)))
            }
        }
    }

    func loadArtObject(at indexPath: IndexPath, completion: @escaping (Result<Void, RMError>) -> Void) {
        guard artObjects[indexPath.item] == nil else {
            return
        }

        let identifier = "\(indexPath.item)"
        let requestParameters = ArtObjectsParameters(offset: indexPath.item, limit: 1)
        context.dataService.getArtObjects(requestIdentifier: identifier, parameters: requestParameters) { [weak self] (result: Result<ArtObjectsResponse, DSError>) in
            switch result {
            case .success(let response):
                self?.artObjects[indexPath.item] = response.artObjects.first
                completion(Result.success(()))

            case .failure(let error):
                completion(Result.failure(RMError.dataService(error)))
            }
        }
    }

    func cancelLoadArtObject(at indexPath: IndexPath) {
        context.dataService.cancelLoadArtObject(requestIdentifier: "\(indexPath.item)")
    }

    func configure(view: ArtObjectViewProtocol, indexPath: IndexPath) -> Bool {
        guard let artObject = artObjects[indexPath.item] else {
            return false
        }

        view.setImagePath(artObject.imagePath)
        view.setTitle(artObject.title)

        return true
    }

    func artObjectDetailsParameters(at indexPath: IndexPath) -> ArtObjectDetailsParameters? {
        guard let artObject = artObjects[indexPath.item] else {
            return nil
        }

        return ArtObjectDetailsParameters(artObject: artObject)
    }

    func didReceiveMemoryWarning() {
        let count = artObjects.count
        artObjects = [ArtObject?](repeating: nil, count: count)
    }
}
