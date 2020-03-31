import UIKit
import UIStyle
import Kingfisher
import Services

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
        label.font = UIStyle.Font.medium(size: 23)
        label.textColor = UIStyle.Color.darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    fileprivate lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIStyle.Font.regular(size: 17)
        label.textColor = UIStyle.Color.darkGray
        label.numberOfLines = 0
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
    let alertService: AlertServiceProtocol

    init(viewModel: ArtObjectDetailsViewModelProtocol, alertService: AlertServiceProtocol) {
        self.viewModel = viewModel
        self.alertService = alertService
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
        NSLayoutConstraint.activate(scrollViewConstraints + imageViewConstraints + titleLabelConstraints + descriptionLabelConstraints + activityIndicatorConstraints)

        activityIndicator.startAnimating()
        viewModel.configure(view: self) { [weak self] (result: Result<Void, RMError>) in
            self?.activityIndicator.stopAnimating()

            switch result {
            case .success:
                break

            case .failure(let error):
                self?.alertService.showMessage(error.description, viewController: self)
            }
        }
    }
}

// MARK: - ViewController life cycle
extension ArtObjectDetailsController: ArtObjectViewProtocol {

    func setImagePath(_ imagePath: String) {
        let url = URL(string: imagePath)
        imageView.kf.setImage(with: url, options: [.scaleFactor(UIScreen.main.scale),
                                                   .backgroundDecode])
    }

    func setTitle(_ text: String) {
        titleLabel.text = text
    }

    func setDescription(_ text: String?) {
        descriptionLabel.text = text
    }
}

// MARK: - Constraints
fileprivate extension ArtObjectDetailsController {

    var scrollViewConstraints: [NSLayoutConstraint] {
        return [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
    }

    var imageViewConstraints: [NSLayoutConstraint] {
        return [
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ]
    }

    var titleLabelConstraints: [NSLayoutConstraint] {
        return [
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
        ]
    }

    var descriptionLabelConstraints: [NSLayoutConstraint] {
        return [
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -32),
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
        ]
    }

    var activityIndicatorConstraints: [NSLayoutConstraint] {
        return [
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
    }
}
