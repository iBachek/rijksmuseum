import Foundation

protocol ArtObjectViewProtocol: AnyObject {
    func setImagePath(_ imagePath: String)
    func setTitle(_ text: String)
    func setDescription(_ text: String?)
}
