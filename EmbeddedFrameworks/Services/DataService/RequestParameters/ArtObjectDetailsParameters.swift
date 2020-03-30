import Foundation

public struct ArtObjectDetailsParameters: APIServiceParametrsProtocol {
    public var artObject: ArtObject

    public var jsonParametrs: [String: String] {
        return [String: String]()
    }

    public init(artObject: ArtObject) {
        self.artObject = artObject
    }
}
