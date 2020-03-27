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
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.backgroundColor = .red

        return collectionView
    }()

    let viewModel: ArtObjectsViewModel

    init(viewModel: ArtObjectsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
    }
}

// MARK: - UICollectionViewDataSource
extension ArtObjectsController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        return myCell
    }
}

// MARK: - UICollectionViewDelegate
extension ArtObjectsController: UICollectionViewDelegate {
    // TODO
}

// MARK: - UICollectionViewDataSourcePrefetching
extension ArtObjectsController: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // TODO
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        // TODO
    }
}

// MARK: - Constraints
fileprivate extension ArtObjectsController {

    var collectionViewConstraints: [NSLayoutConstraint] {
        return [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
    }
}
