import UIKit
import Services

final class ArtObjectsFactory {

    func make() -> UIViewController {
        let requestParameters = ArtObjectsParameters(offset: 0, limit: 10)
        let viewModel = ArtObjectsViewModel(requestParameters: requestParameters, context: AppDelegate.sharedInstance.context)
        let controller = ArtObjectsController(viewModel: viewModel)

        return controller
    }
}
