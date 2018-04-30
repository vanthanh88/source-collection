import UIKit

class InputCommentTextView: UITextView {

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UITextViewTextDidChange, object: self)
    }
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChanged), name: Notification.Name.UITextViewTextDidChange, object: self)
        self.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    
    override var text: String! {
        didSet {
            self.updateLayout()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let textRect = self.layoutManager.usedRect(for: self.textContainer)
        let height = textRect.size.height + self.textContainerInset.top + self.textContainerInset.bottom
        return CGSize(width: UIViewNoIntrinsicMetric, height: height)
    }
    
    func textDidChanged(_ notification: Notification) {
        self.updateLayout()
    }
    
    func updateLayout() {
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override func scrollRectToVisible(_ rect: CGRect, animated: Bool) {
        self.updateLayout()
        super.scrollRectToVisible(rect, animated: animated)
    }
}
