import UIKit
import Kingfisher
import Services

// MARK: - Variables
final class ArtObjectsCollectionController: UIViewController {

    fileprivate lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        collectionViewLayout.itemSize = CGSize(width: 60, height: 60)

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.register(ArtObjectCollectionViewCell.self, forCellWithReuseIdentifier: ArtObjectCollectionViewCell.identifier)
        collectionView.automaticallyAdjustsScrollIndicatorInsets = true
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()

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
extension ArtObjectsCollectionController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Collection"
        view.backgroundColor = .white
        view.addSubview(collectionView)
        NSLayoutConstraint.activate(collectionViewConstraints)

        viewModel.itemsCount { [weak self] (result: Result<Int, RMError>) in
            switch result {
            case .success(let count):
                self?.numberOfItems = count
                self?.collectionView.reloadData()

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

// MARK: - UICollectionViewDataSource
extension ArtObjectsCollectionController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtObjectCollectionViewCell.identifier, for: indexPath)
        guard let artObjectCell = cell as? ArtObjectCollectionViewCell else {
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

// MARK: - UICollectionViewDelegate
extension ArtObjectsCollectionController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let parameters = viewModel.artObjectDetailsParameters(at: indexPath) else {
            return
        }

        let artObjectDetailsFactory = ArtObjectDetailsFactory()
        let controller = artObjectDetailsFactory.make(requestParameters: parameters)
        present(controller, animated: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ArtObjectsCollectionController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension ArtObjectsCollectionController: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            loadArtObject(at: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            viewModel.cancelLoadArtObject(at: indexPath)
        }
    }
}

// MARK: - Utility
fileprivate extension ArtObjectsCollectionController {
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
        guard collectionView.indexPathsForVisibleItems.contains(indexPath) else {
            return
        }

        guard !collectionView.isDecelerating, !collectionView.isDragging else {
            return
        }

        collectionView.performBatchUpdates({ [weak self] in
            self?.collectionView.reloadItems(at: [indexPath])
        })
    }
}

// MARK: - Constraints
fileprivate extension ArtObjectsCollectionController {

    enum Constants {
        static let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20.0)
    }

    var collectionViewConstraints: [NSLayoutConstraint] {
        return [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
    }
}
