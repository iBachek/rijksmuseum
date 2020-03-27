import UIKit

// MARK: - Variables
final class ArtObjectDetailsController: UIViewController {

    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        return imageView
    }()

    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        // TODO use Style

        return label
    }()

    fileprivate lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        // TODO use Style

        return label
    }()

    let viewModel: ArtObjectDetailsViewModel

    init(viewModel: ArtObjectDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
