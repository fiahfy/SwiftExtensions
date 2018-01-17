import UIKit

// MARK - String

extension String {
    func match(withPattern pattern: String) -> [String]? {
        guard let results = matchInGlobal(withPattern: pattern) else {
            return nil
        }
        return results[0]
    }
    
    func matchInGlobal(withPattern pattern: String) -> [[String]]? {
        guard let reg = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        let matches = reg.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
        if matches.count == 0 {
            return nil
        }
        var results = [[String]]()
        for match in matches {
            var result = [String]()
            for i in 0..<match.numberOfRanges {
                result.append((self as NSString).substring(with: match.range(at: i)))
            }
            results.append(result)
        }
        return results
    }
    
    func replace(of target: String, with replacement: String) -> String {
        guard let reg = try? NSRegularExpression(pattern: target, options: []) else {
            return self
        }
        
        let result = reg.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: self.count), withTemplate: replacement)
        
        return result
    }
    
    func replaceAll(pattern: String, replacer: (_ match: [String]) -> String?) -> String {
        guard let reg = try? NSRegularExpression(pattern: pattern, options: []) else {
            return self
        }
        
        let source = self as NSString
        
        let matches = reg.matches(in: self, options: [], range: NSRange(location: 0, length: source.length))
        
        if matches.count == 0 {
            return self
        }
        
        var result = ""
        var position = 0
        for match in matches {
            result += source.substring(with: NSRange(location: position, length: match.range.location - position))
            var matchString = [String]()
            
            for i in 0..<match.numberOfRanges {
                matchString.append(source.substring(with: match.range(at: i)))
            }
            
            if let replacement = replacer(matchString) {
                result += replacement
            } else {
                result += source.substring(with: match.range)
            }
            position = match.range.location + match.range.length
        }
        result += source.substring(from: position)
        
        return result
    }
}

// MARK - UIDevice

extension UIDevice {
    func isPad() -> Bool {
        return self.model.contains("iPad")
    }
}

// MARK - UITableViewCell

extension UITableViewCell {
    var selectedBackgroundColor: UIColor? {
        get {
            return selectedBackgroundView?.backgroundColor
        }
        set {
            let background = UIView()
            background.backgroundColor = newValue
            selectedBackgroundView = background
            setNeedsLayout()
        }
    }
}

// MARK - UIView

extension UIView {
    func setHidden(_ hidden: Bool, animated: Bool, completion: (() -> Void)? = nil) {
        if isHidden == hidden {
            completion?()
            return
        }
        guard hidden else {
            show(animated: animated, completion: completion)
            return
        }
        hide(animated: animated, completion: completion)
    }
    
    private func show(animated: Bool, completion: (() -> Void)? = nil) {
        let duration = animated ? CATransaction.animationDuration() : 0.0
        let alpha = self.alpha
        self.alpha = 0.0
        isHidden = false
        UIView.animate(withDuration: duration, animations: {
            self.alpha = alpha
        }, completion: { _ in
            completion?()
        })
    }
    
    private func hide(animated: Bool, completion: (() -> Void)? = nil) {
        let duration = animated ? CATransaction.animationDuration() : 0.0
        let alpha = self.alpha
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        }, completion: { _ in
            self.isHidden = true
            self.alpha = alpha
            completion?()
        })
    }
}

// MARK - URL

extension URL {
    var params: [String: String] {
        let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) ?? URLComponents()
        let queryItems = urlComponents.queryItems ?? []
        var params = [String: String]()
        for queryItem in queryItems {
            params[queryItem.name] = queryItem.value ?? ""
        }
        return params
    }
    static func buildQuery(_ params: [String: String] = [:]) -> String {
        var queries = [String]()
        for (key, value) in params {
            let encodedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            queries += ["\(key)=\(encodedValue)"]
        }
        return queries.joined(separator: "&")
    }
}

// MARK - NSRange

extension NSRange {
    func toRange(string: String) -> Range<String.Index> {
        let startIndex = string.startIndex
        let fromIndex = string.index(startIndex, offsetBy: self.location)
        let toIndex = string.index(fromIndex, offsetBy: self.length)
        return fromIndex ..< toIndex
    }
}
