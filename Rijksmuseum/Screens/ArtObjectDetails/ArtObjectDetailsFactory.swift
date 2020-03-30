import UIKit
import Services

final class ArtObjectDetailsFactory {

    func make(requestParameters: ArtObjectDetailsParameters) -> UIViewController {
        let viewModel = ArtObjectDetailsViewModel(requestParameters: requestParameters, context: AppDelegate.sharedInstance.context)
        let controller = ArtObjectDetailsController(viewModel: viewModel)

        return controller
    }
}
