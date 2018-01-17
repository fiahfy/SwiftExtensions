import UIKit

extension UICollectionView {
    public func registerCell<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.className)
    }

    public func registerSupplementaryView<T: UICollectionReusableView>(_ viewClass: T.Type, ofKind elementKind: String) {
        register(viewClass, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: viewClass.className)
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.className, for: indexPath) as? T ?? T()
    }
    
    public func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.className, for: indexPath) as? T ?? T()
    }
}
