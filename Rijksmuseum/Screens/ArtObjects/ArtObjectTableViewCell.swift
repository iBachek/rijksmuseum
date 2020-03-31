import UIKit
import UIStyle
import Kingfisher

// MARK: - Variables
final class ArtObjectTableViewCell: UITableViewCell {

    fileprivate(set) lazy var artObjectImageView: UIImageView = {
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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        artObjectImageView.kf.cancelDownloadTask()
        artObjectImageView.image = nil
        titleView.text = "Loading..."
    }
}

// MARK: - ViewController life cycle
fileprivate extension ArtObjectTableViewCell {

    func setupUI() {
        contentView.addSubview(artObjectImageView)
        contentView.addSubview(titleView)

        NSLayoutConstraint.activate(artObjectImageViewConstraints + titleViewConstraints)
    }
}

// MARK: - ArtObjectViewProtocol
extension ArtObjectTableViewCell: ArtObjectViewProtocol {

    func setImagePath(_ imagePath: String) {
        let url = URL(string: imagePath)
        let scale = UIScreen.main.scale
        let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: 100 * scale, height: 100 * scale), mode: .aspectFill)
        artObjectImageView.kf.indicatorType = .activity
        artObjectImageView.kf.setImage(with: url, options: [.backgroundDecode,
                                                            .processor(resizingProcessor)])
    }

    func setTitle(_ text: String) {
        titleView.text = text
    }

    func setDescription(_ text: String?) {
        // not implemented for collection cell
    }
}

// MARK: - Constraints
fileprivate extension ArtObjectTableViewCell {

    var artObjectImageViewConstraints: [NSLayoutConstraint] {
        return [
            artObjectImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            artObjectImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            artObjectImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            artObjectImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
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
