import UIKit

final class WelcomeFactory {

    func make() -> UIViewController {
        let viewModel = WelcomeViewModel()
        let controller = WelcomeController(viewModel: viewModel)

        return controller
    }
}
