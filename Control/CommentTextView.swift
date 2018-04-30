import UIKit

typealias CommentTextHandler = (String?) -> Void

class CommentTextView: UIView {

    @IBOutlet private var view: UIView!
    @IBOutlet weak var tvComment: UITextView!
    @IBOutlet weak var imgvAvatar: UIImageView!
    @IBOutlet weak var btnSubmit: UIButton!
    var commentTextHandler: CommentTextHandler?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let view = Bundle.main.loadNibNamed("CommentTextView", owner: self, options: nil)![0] as? UIView else {
            return
        }
        self.addSubview(view)
        view.frame = self.bounds
        self.btnSubmit.isEnabled = false
        self.layer.shadowColor = UIColor.darkGray.withAlphaComponent(0.1).cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 1.0
    }
    
    @IBAction func textFieldTextDidChanged(_ sender: UITextView) {
        if let text = sender.text {
            self.btnSubmit.isEnabled = text.length > 0
        }
        log.debug("sender.text?.count \(String(describing: sender.text?.count))")
    }
    @IBAction func actionSend(_ sender: UIButton) {
        if self.tvComment.isFirstResponder {
            self.tvComment.resignFirstResponder()
        }
        self.commentTextHandler?(tvComment.text)
    }
    
    func setEnabled(_ enabled: Bool) {
        self.tvComment.isEditable = enabled
        self.imgvAvatar.alpha = enabled ? 1 : 0.5
    }
}
