import UIKit

private let kReloadHandlerViewTag             = 9669


class ReloadHandlerView: UIControl {
    
    @IBOutlet weak private var lbMessage: UILabel!
    var message: String? {
        didSet {
            lbMessage.text = message
        }
    }
    class func instanceFromNib<T: ReloadHandlerView>() -> T {
        guard let reloadHandlerView = UINib(nibName: NSStringFromClass(T.self).components(separatedBy: ".").last!, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? T else {
            return T()
        }
        return reloadHandlerView
    }
}


extension UIViewController {
    
    func addReloadHandlerView(with target: Any, andSelector selector: Selector, andMessage message: String? = Localizable.TapToReload) {
        removeReloadHandlerView()
        let reloadHandlerView = ReloadHandlerView.instanceFromNib()
        reloadHandlerView.message = message
        reloadHandlerView.addTarget(self, action: selector, for: .touchUpInside)
        reloadHandlerView.tag = kReloadHandlerViewTag
        reloadHandlerView.alpha = 0.0
        self.view.addSubview(reloadHandlerView)
        reloadHandlerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": reloadHandlerView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": reloadHandlerView]))
        UIView.animate(withDuration: 0.5) {
            reloadHandlerView.alpha = 1.0
        }
        
    }
    
    private func removeReloadHandlerView() {
        if let reloadHandlerView = self.view.viewWithTag(kReloadHandlerViewTag) as? ReloadHandlerView {
            reloadHandlerView.removeFromSuperview()
        }
    }
}
