import UIKit
import UIStyle

// MARK: - Variables
final class WelcomeController: UIViewController {

    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIStyle.Font.medium(size: 23)
        label.textColor = UIStyle.Color.darkGray
        label.text = "Welcome in Rijksmuseum\nonline"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    fileprivate lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIStyle.Font.medium(size: 17)
        label.textColor = UIStyle.Color.darkGray
        label.text = "Enjoy online the best museum collection of the 17th century presented in the Rijksmuseum. You can find the works of famous artists of that era, such as a Rembrand, Jan Vermeer, etc. You can also see a portrait of the great Dutch admiral Michiel de Ruyter."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    fileprivate lazy var collectionViewButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("UICollectionView", for: .normal)
        button.titleLabel?.font = UIStyle.Font.medium(size: 23)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(UIStyle.Color.thinGray, for: .highlighted)
        button.addTarget(self, action: #selector(collectionViewButtonAction(_:)), for: .touchUpInside)
        button.backgroundColor = UIStyle.Color.blue
        button.layer.cornerRadius = Constants.actionButtonHeight / 2
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    fileprivate lazy var tableViewButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("UITableView", for: .normal)
        button.titleLabel?.font = UIStyle.Font.medium(size: 23)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(UIStyle.Color.thinGray, for: .highlighted)
        button.addTarget(self, action: #selector(tableViewButtonAction(_:)), for: .touchUpInside)
        button.backgroundColor = UIStyle.Color.blue
        button.layer.cornerRadius = Constants.actionButtonHeight / 2
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    let viewModel: WelcomeViewModelProtocol

    init(viewModel: WelcomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewController life cycle
extension WelcomeController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Welcome"
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(collectionViewButton)
        view.addSubview(tableViewButton)
        NSLayoutConstraint.activate(titleLabelConstraints + descriptionLabelConstraints + collectionViewButtonConstraints + tableViewButtonConstraints)
    }
}

// MARK: - Actions
fileprivate extension WelcomeController {

    @objc func collectionViewButtonAction(_ sender: UIButton) {

        // Display Rijksmuseum collections using UICollectionView
        let artObjectsFactory = ArtObjectsFactory()
        navigationController?.pushViewController(artObjectsFactory.makeCollectionRepresentation(), animated: true)
    }

    @objc func tableViewButtonAction(_ sender: UIButton) {

        // Display Rijksmuseum collections using UITableView
        let artObjectsFactory = ArtObjectsFactory()
        navigationController?.pushViewController(artObjectsFactory.makeTableRepresentation(), animated: true)
    }
}

// MARK: - Constraints
fileprivate extension WelcomeController {

    enum Constants {
        static let actionButtonHeight: CGFloat = 60
    }

    var titleLabelConstraints: [NSLayoutConstraint] {
        return [
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ]
    }

    var descriptionLabelConstraints: [NSLayoutConstraint] {
        return [
            descriptionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ]
    }

    var collectionViewButtonConstraints: [NSLayoutConstraint] {
        return [
            collectionViewButton.bottomAnchor.constraint(equalTo: tableViewButton.topAnchor, constant: -24),
            collectionViewButton.heightAnchor.constraint(equalToConstant: Constants.actionButtonHeight),
            collectionViewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            collectionViewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ]
    }

    var tableViewButtonConstraints: [NSLayoutConstraint] {
        return [
            tableViewButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            tableViewButton.heightAnchor.constraint(equalToConstant: Constants.actionButtonHeight),
            tableViewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            tableViewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ]
    }
}
