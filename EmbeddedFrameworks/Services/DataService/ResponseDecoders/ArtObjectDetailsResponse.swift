import Foundation

public struct ArtObjectDetailsResponse: Decodable {
    public let artObject: ArtObject

    enum CodingKeys: String, CodingKey {
        case artObject = "artObject"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.artObject = try container.decode(ArtObject.self, forKey: .artObject)
    }
}
