import UIKit

// MARK: - Variables
final class ArtObjectDetailsController: UIViewController {

    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()

    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        // TODO use Style
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    fileprivate lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        // TODO use Style
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.color = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    let viewModel: ArtObjectDetailsViewModelProtocol

    init(viewModel: ArtObjectDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewController life cycle
extension ArtObjectDetailsController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        scrollView.addSubview(imageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(descriptionLabel)
        view.addSubview(scrollView)
        view.addSubview(activityIndicator)
//        NSLayoutConstraint.activate(collectionViewConstraints + activityIndicatorConstraints)

        activityIndicator.startAnimating()
//        viewModel.loadInitialArtObjects { [weak self] (result: Result<Void, RMError>) in
//            self?.activityIndicator.stopAnimating()
//
//            switch result {
//            case .success:
//                self?.collectionView.reloadData()
//
//            case .failure(let error):
//                print(error.description)
//            }
//        }
    }
}
