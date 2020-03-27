import UIKit
import Services

final class ArtObjectsFactory {

    func make() -> UIViewController {
        let requestParameters = ArtObjectsParameters(offset: 0, limit: 10)
        let viewModel = CollectionsViewModel(requestParameters: requestParameters, context: AppDelegate.sharedInstance.context)
        let controller = CollectionsController(viewModel: viewModel)

        return controller
    }
}
