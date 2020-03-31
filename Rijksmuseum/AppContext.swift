import Services

typealias AppContextHolderProtocol = DataServiceHolderProtocol &
                                    AlertServiceHolderProtocol

struct AppContext: AppContextHolderProtocol {

    private enum Constants {
        static let rijksmuseumApiKey = "0fiuZFh4"
        static let language = APIService.Language.en
    }

    let dataService: DataServiceProtocol
    let alertService: AlertServiceProtocol

    static func makeContext() -> AppContext {
        let apiService = APIService(apiKey: Constants.rijksmuseumApiKey, language: Constants.language)
        let dataService = DataService(apiService: apiService, queue: DispatchQueue.main)

        let alertService = AlertService()

        return AppContext(dataService: dataService, alertService: alertService)
    }
}
