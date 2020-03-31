import UIKit

public struct UIStyle {

    public struct Font {

        public static func bold(size: CGFloat) -> UIFont {
            return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
        }

        public static func medium(size: CGFloat) -> UIFont {
            return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
        }

        public static func regular(size: CGFloat) -> UIFont {
            return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.regular)
        }

        public static func light(size: CGFloat) -> UIFont {
            return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.light)
        }
    }

    public struct Color {

        public static var darkGray: UIColor {
            return UIColor(red: 72/255, green: 72/255, blue: 72/255, alpha: 1)
        }

        public static var thinGray: UIColor {
            return UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1)
        }

        public static var blue: UIColor {
            return UIColor(red: 99/255, green: 180/255, blue: 244/255, alpha: 1)
        }
    }
}
