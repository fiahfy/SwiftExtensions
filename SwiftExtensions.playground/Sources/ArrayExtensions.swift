import Foundation

extension Array {
    public mutating func shuffle() {
        if count < 2 {
            return
        }
        
        for i in startIndex ..< endIndex - 1 {
            let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
            if i != j {
                swapAt(i, j)
            }
        }
    }
    
    public func shuffled() -> [Element] {
        var list = Array(self)
        list.shuffle()
        return list
    }
}
