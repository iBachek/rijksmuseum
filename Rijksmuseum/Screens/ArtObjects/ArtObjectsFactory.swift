import UIKit
import Services

final class ArtObjectsFactory {

    func makeCollectionRepresentation() -> UIViewController {
        let viewModel = ArtObjectsViewModel(context: AppDelegate.sharedInstance.context)
        let controller = ArtObjectsCollectionController(viewModel: viewModel, alertService: AppDelegate.sharedInstance.context.alertService)

        return controller
    }

    func makeTableRepresentation() -> UIViewController {
        let viewModel = ArtObjectsViewModel(context: AppDelegate.sharedInstance.context)
        let controller = ArtObjectsTableController(viewModel: viewModel, alertService: AppDelegate.sharedInstance.context.alertService)

        return controller
    }
}
