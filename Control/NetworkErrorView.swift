import UIKit

class NetworkErrorView: UIView {

    @IBOutlet weak private var lbTitle: UILabel!
    
    var title: String? {
        didSet {
            if let _title = title {
                lbTitle.setLineSpace(with: _title, lineSpacing: 5.0)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        lbTitle.font = UIFont(name: FontName.hiraginoSansW3.rawValue, size: 12) ?? UIFont.systemFont(ofSize: 12)
        lbTitle.numberOfLines = 2
        lbTitle.textAlignment = .center
        lbTitle.textColor = UIColor.white
    }
    
    @IBAction func actionClose(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    class func instanceFromNib<T: NetworkErrorView>() -> T {
        guard let networkErrorView = UINib(nibName: NSStringFromClass(T.self).components(separatedBy: ".").last!, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? T else {
            return T()
        }
        return networkErrorView
    }
}
