import UIKit
import UIStyle
import Kingfisher

// MARK: - Variables
final class ArtObjectCollectionViewCell: UICollectionViewCell {

    fileprivate(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    fileprivate(set) lazy var titleView: UITextView = {
        let textView = UITextView()
        textView.font = UIStyle.Font.bold(size: 17)
        textView.textColor = .black
        textView.textAlignment = .center
        textView.backgroundColor = UIStyle.Color.blue.withAlphaComponent(0.8)
        textView.textContainerInset = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        truncate()
    }

    func truncate() {
        imageView.kf.cancelDownloadTask()
        imageView.image = UIImage(named: "placeholder_art_image")
        titleView.text = "Loading..."
    }
}

// MARK: - ViewController life cycle
fileprivate extension ArtObjectCollectionViewCell {

    func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleView)

        NSLayoutConstraint.activate(imageViewConstraints + titleViewConstraints)
    }
}

// MARK: - ArtObjectViewProtocol
extension ArtObjectCollectionViewCell: ArtObjectViewProtocol {

    func setImagePath(_ imagePath: String) {
         let url = URL(string: imagePath)
        let placeholder = UIImage(named: "placeholder_art_image")
        imageView.kf.setImage(with: url, placeholder: placeholder, options: [.scaleFactor(UIScreen.main.scale),
                                                                             .backgroundDecode])
    }

    func setTitle(_ text: String) {
        titleView.text = text
    }

    func setDescription(_ text: String?) {
        // not implemented for collection cell
    }
}

// MARK: - Constraints
fileprivate extension ArtObjectCollectionViewCell {

    var imageViewConstraints: [NSLayoutConstraint] {
        return [
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]
    }

    var titleViewConstraints: [NSLayoutConstraint] {
        return [
            titleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]
    }
}
