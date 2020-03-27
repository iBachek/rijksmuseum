import Foundation

public struct ArtObjectsResponse: Decodable {
    public let artObjects: [ArtObject]

    enum CodingKeys: String, CodingKey {
        case artObjects = "artObjects"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.artObjects = try container.decode([ArtObject].self, forKey: .artObjects)
    }
}
