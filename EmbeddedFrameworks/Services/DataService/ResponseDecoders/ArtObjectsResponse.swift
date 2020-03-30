import Foundation

public struct ArtObjectsResponse: Decodable {
    public let artObjectsCount: Int
    public let artObjects: [ArtObject]

    enum CodingKeys: String, CodingKey {
        case artObjectsCount = "count"
        case artObjects = "artObjects"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.artObjectsCount = try container.decode(Int.self, forKey: .artObjectsCount)
        self.artObjects = try container.decode([ArtObject].self, forKey: .artObjects)
    }
}
