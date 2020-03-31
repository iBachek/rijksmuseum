import UIKit
import Kingfisher
import Services

// MARK: - Variables
final class ArtObjectsTableController: UIViewController {

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ArtObjectTableViewCell.self, forCellReuseIdentifier: ArtObjectTableViewCell.identifier)
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = 500
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    let viewModel: ArtObjectsViewModelProtocol
    let alertService: AlertServiceProtocol
    var numberOfItems: Int

    init(viewModel: ArtObjectsViewModelProtocol, alertService: AlertServiceProtocol) {
        self.viewModel = viewModel
        self.alertService = alertService
        self.numberOfItems = 0
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewController life cycle
extension ArtObjectsTableController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Collection"
        view.backgroundColor = .white
        view.addSubview(tableView)
        NSLayoutConstraint.activate(tableViewConstraints)

        viewModel.itemsCount { [weak self] (result: Result<Int, RMError>) in
            switch result {
            case .success(let count):
                self?.numberOfItems = count
                self?.tableView.reloadData()

            case .failure(let error):
                self?.alertService.showMessage(error.description, viewController: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        ImageCache.default.clearMemoryCache()
        viewModel.didReceiveMemoryWarning()
        super.didReceiveMemoryWarning()
    }
}

// MARK: - UITableViewDataSource
extension ArtObjectsTableController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArtObjectTableViewCell.identifier, for: indexPath)
        guard let artObjectCell = cell as? ArtObjectTableViewCell else {
            return cell
        }

        let configured = viewModel.configure(view: artObjectCell, indexPath: indexPath)
        if !configured {
            artObjectCell.truncate()
            loadArtObject(at: indexPath)
        }

        return artObjectCell
    }
}

// MARK: - UITableViewDelegate
extension ArtObjectsTableController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let parameters = viewModel.artObjectDetailsParameters(at: indexPath) else {
            return
        }

        let artObjectDetailsFactory = ArtObjectDetailsFactory()
        let controller = artObjectDetailsFactory.make(requestParameters: parameters)
        present(controller, animated: true)
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension ArtObjectsTableController: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            loadArtObject(at: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            viewModel.cancelLoadArtObject(at: indexPath)
        }
    }
}

// MARK: - Utility
fileprivate extension ArtObjectsTableController {
    func loadArtObject(at indexPath: IndexPath) {
        viewModel.loadArtObject(at: indexPath) { [weak self] (result: Result<Void, RMError>) in
            switch result {
            case .success:
                self?.reloadItemIfNeeded(itemIndexPath: indexPath)

            case .failure(let error):
                self?.alertService.showMessage(error.description, viewController: self)
            }
        }
    }

    func reloadItemIfNeeded(itemIndexPath indexPath: IndexPath) {
        guard let visibleRowsPaths = tableView.indexPathsForVisibleRows, visibleRowsPaths.contains(indexPath) else {
            return
        }

        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}

// MARK: - Constraints
fileprivate extension ArtObjectsTableController {

    var tableViewConstraints: [NSLayoutConstraint] {
        return [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
    }
}

