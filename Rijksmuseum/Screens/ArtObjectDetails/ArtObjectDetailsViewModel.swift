import Services

protocol ArtObjectDetailsViewModelProtocol {
    func configure(view: ArtObjectViewProtocol, completion: @escaping (Result<Void, RMError>) -> Void)
}

final class ArtObjectDetailsViewModel: ArtObjectDetailsViewModelProtocol {

    typealias Context = DataServiceHolderProtocol
    let context: Context
    let requestParameters: ArtObjectDetailsParameters

    init(requestParameters: ArtObjectDetailsParameters, context: DataServiceHolderProtocol) {
        self.requestParameters = requestParameters
        self.context = context
    }

    func configure(view: ArtObjectViewProtocol, completion: @escaping (Result<Void, RMError>) -> Void) {
        context.dataService.getArtObjectDetails(parameters: requestParameters) { [weak view] (result: Result<ArtObject, APIError>) in
            switch result {
            case .success(let artObject):
                view?.setImagePath(artObject.imagePath)
                view?.setTitle(artObject.title)
                view?.setDescription(artObject.description)
                completion(Result.success(()))

            case .failure(let error):
                print(error)
                completion(Result.success(()))
            }
        }
    }
}
