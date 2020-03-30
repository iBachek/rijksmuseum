import UIKit
import Services

final class ArtObjectsFactory {

    func make() -> UIViewController {
        let viewModel = ArtObjectsViewModel(context: AppDelegate.sharedInstance.context)
        let controller = ArtObjectsController(viewModel: viewModel)

        return controller
    }
}
