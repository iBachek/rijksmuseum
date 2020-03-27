import Services

typealias AppContextHolderProtocol = DataServiceHolderProtocol

struct AppContext: AppContextHolderProtocol {

    private enum Constants {
        static let rijksmuseumApiKey = "0fiuZFh4"
        static let language = APIService.Language.en
    }

    let dataService: DataServiceProtocol

    static func makeContext() -> AppContext {
        let apiService = APIService(apiKey: Constants.rijksmuseumApiKey, language: Constants.language, queue: DispatchQueue.main)
        let dataService = DataService(apiService: apiService, queue: DispatchQueue.main)

        return AppContext(dataService: dataService)
    }
}
