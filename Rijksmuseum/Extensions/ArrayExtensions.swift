import Foundation

extension Array {

    func safetyItem(at index: Index) -> Element? {
        guard self.indices.contains(index) else {
            return nil
        }

        return self[index]
    }
}
