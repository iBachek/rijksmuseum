import Foundation

public struct ArtObject: Decodable {
    public let id: String
    public let title: String
    public let subtitle: String?
    public let description: String?
    public let imagePath: String

    enum CodingKeys: String, CodingKey {
        case id = "objectNumber"
        case title = "title"
        case subtitle = "longTitle"
        case description = "description"
        case image = "webImage"
    }

    enum ImageCodingKeys: String, CodingKey {
        case imagePath = "url"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.subtitle = try? container.decode(String.self, forKey: .subtitle)
        self.description = try? container.decode(String.self, forKey: .description)

        // Nested image path
        let imageContainer = try container.nestedContainer(keyedBy: ImageCodingKeys.self, forKey: .image)
        self.imagePath = try imageContainer.decode(String.self, forKey: .imagePath)
    }
}
