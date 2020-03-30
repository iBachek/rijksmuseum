import UIKit

// MARK: - Variables
final class ArtObjectsController: UIViewController {

    fileprivate lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)

        return layout
    }()

    fileprivate lazy var collectionView: UICollectionView = {
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

    let viewModel: ArtObjectsViewModelProtocol
    var numberOfItems: Int

    init(viewModel: ArtObjectsViewModelProtocol) {
        self.viewModel = viewModel
        self.numberOfItems = 0
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewController life cycle
extension ArtObjectsController {

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
                print(error)
            }
        }
    }
}

// MARK: - ArtObjectsViewModelDelegate
extension ArtObjectsController: ArtObjectsViewModelDelegate {

    func reloadDataSource() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension ArtObjectsController: UICollectionViewDataSource {

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
extension ArtObjectsController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let artObjectID = viewModel.artObjectID(at: indexPath) else {
            return
        }

        let artObjectDetailsFactory = ArtObjectDetailsFactory()
        let controller = artObjectDetailsFactory.make(artObjectID: artObjectID)
        present(controller, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ArtObjectsController: UICollectionViewDelegateFlowLayout {

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
extension ArtObjectsController: UICollectionViewDataSourcePrefetching {

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
fileprivate extension ArtObjectsController {
    func loadArtObject(at indexPath: IndexPath) {
        viewModel.loadArtObject(at: indexPath) { [weak self] (result: Result<Void, RMError>) in
            switch result {
            case .success:
                self?.reloadItemIfNeeded(itemIndexPath: indexPath)

            case .failure(let error):
                print(error)
            }
        }
    }

    func reloadItemIfNeeded(itemIndexPath indexPath: IndexPath) {
        guard collectionView.indexPathsForVisibleItems.contains(indexPath) else {
            return
        }

        collectionView.performBatchUpdates({ [weak self] in
            self?.collectionView.reloadItems(at: [indexPath])
        })
    }
}

// MARK: - Constraints
fileprivate extension ArtObjectsController {

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
