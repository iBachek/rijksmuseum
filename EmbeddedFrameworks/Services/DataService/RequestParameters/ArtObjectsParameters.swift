import Foundation

public struct ArtObjectsParameters: APIServiceParametrsProtocol {
    public var offset: Int
    public var limit: Int
    public var collectionsCentury: Int

    public var jsonParametrs: [String: String] {
        return [
            "p": String(offset),
            "ps": String(limit),
            "f.dating.period": String(collectionsCentury)
        ]
    }

    public init(offset: Int, limit: Int, collectionsCentury: Int = 17) {
        self.offset = offset
        self.limit = limit
        self.collectionsCentury = collectionsCentury
    }
}
