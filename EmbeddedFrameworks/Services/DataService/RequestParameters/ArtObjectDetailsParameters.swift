import Foundation

public struct ArtObjectDetailsParameters: APIServiceParametrsProtocol {
    public var artObjectID: String

    public var jsonParametrs: [String: String] {
        return [String: String]()
    }

    public init(artObjectID: String) {
        self.artObjectID = artObjectID
    }
}
