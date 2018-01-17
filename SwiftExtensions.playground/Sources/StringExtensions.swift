import Foundation

extension String {
    public var capitalizedFirst: String {
        return prefix(1).uppercased() + dropFirst()
    }
}
