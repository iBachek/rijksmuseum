import Services

protocol ArtObjectDetailsViewModelProtocol {

}

final class ArtObjectDetailsViewModel: ArtObjectDetailsViewModelProtocol {

    typealias Context = DataServiceHolderProtocol
    let context: Context
    let requestParameters: ArtObjectDetailsParameters

    init(requestParameters: ArtObjectDetailsParameters, context: DataServiceHolderProtocol) {
        self.requestParameters = requestParameters
        self.context = context
    }
}
