import Foundation
import UIKit

@IBDesignable
class LayoutConstraint: NSLayoutConstraint {
    
    @IBInspectable
    var iphong35inch: CGFloat = 0 {
        didSet {
            if UIScreen.main.bounds.maxY == 480 {
                constant = iphong35inch
            }
        }
    }
    
    @IBInspectable
    var iphone40inch: CGFloat = 0 {
        didSet {
            if UIScreen.main.bounds.maxY == 568 {
                constant = iphone40inch
            }
        }
    }
    
    @IBInspectable
    var iphone47inch: CGFloat = 0 {
        didSet {
            if UIScreen.main.bounds.maxY == 667 {
                constant = iphone47inch
            }
        }
    }
    
    @IBInspectable
    var iphone55inch: CGFloat = 0 {
        didSet {
            if UIScreen.main.bounds.maxY == 736 {
                constant = iphone55inch
            }
        }
    }
}
