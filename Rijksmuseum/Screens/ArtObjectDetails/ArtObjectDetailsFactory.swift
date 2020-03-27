import UIKit
import Services

final class ArtObjectDetailsFactory {

    func make(artObjectID: String) -> UIViewController {
        let requestParameters = ArtObjectDetailsParameters(artObjectID: artObjectID)
        let viewModel = ArtObjectDetailsViewModel(requestParameters: requestParameters, context: AppDelegate.sharedInstance.context)
        let controller = ArtObjectDetailsController(viewModel: viewModel)

        return controller
    }
}
