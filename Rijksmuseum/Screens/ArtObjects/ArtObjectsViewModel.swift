import Services

final class ArtObjectsViewModel {

    typealias Context = DataServiceHolderProtocol
    let context: Context
    let requestParameters: ArtObjectsParameters

    init(requestParameters: ArtObjectsParameters, context: DataServiceHolderProtocol) {
        self.requestParameters = requestParameters
        self.context = context
    }
}
