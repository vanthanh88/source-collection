import UIKit
protocol KNSwitcherChangeValueDelegate: class {
    func switcherDidChangeValue(switcher: KNSwitcher, value: Bool)
}

@IBDesignable class KNSwitcher: UIView {
    
    var button: UIButton!
    var label: UILabel!
    var buttonLeftConstraint: NSLayoutConstraint!
    weak var delegate: KNSwitcherChangeValueDelegate?
    @IBInspectable var onSwitch: Bool = false
    @IBInspectable var originalImage: UIImage?
    @IBInspectable var selectedImage: UIImage?
    @IBInspectable var selectedColor: UIColor = UIColor.white
    @IBInspectable var originalColor: UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
    
    private var offCenterPosition: CGFloat!
    private var onCenterPosition: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func awakeFromNib() {
        commonInit()
    }
    
    private func commonInit() {
        button = UIButton(type: .custom)
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 32))
        label.textColor = UIColor.white
        label.text = onSwitch ? Localizable.SwitchOnText : Localizable.SwitchOffText
        label.center = self.center
        label.font = UIFont(name: FontName.hiraginoSansW6.rawValue, size: 14)
        self.addSubview(button)
        self.addSubview(label)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(switcherButtonTouch(_:)), for: UIControlEvents.touchUpInside)
        button.setImage(originalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        offCenterPosition = self.bounds.height * 0.1
        onCenterPosition = self.bounds.width - (self.bounds.height * 0.9)
        self.button.backgroundColor = onSwitch ? selectedColor : originalColor
        if self.backgroundColor == nil {
            self.backgroundColor = .white
        }
        initLayout()
        switchChangeToOff()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
        self.clipsToBounds = true
        button.layer.cornerRadius = button.bounds.height / 2
    }
    
    private func initLayout() {
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        buttonLeftConstraint = button.leftAnchor.constraint(equalTo: self.leftAnchor)
        buttonLeftConstraint.isActive = true
        button.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1).isActive = true
    }
    
    func setImages(onImage: UIImage?, offImage: UIImage?) {
        button.setImage(offImage, for: .normal)
        button.setImage(onImage, for: .selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func switcherButtonTouch(_ sender: AnyObject) {
        onSwitch = !onSwitch
        delegate?.switcherDidChangeValue(switcher: self, value: onSwitch)
    }

    func switchChangeToOff() {
        // Clear Shadow
        self.button.layer.shadowOffset = CGSize.zero
        self.button.layer.shadowOpacity = 0
        self.button.layer.shadowRadius = self.button.frame.height / 2
        self.button.layer.cornerRadius = self.button.frame.height / 2
        self.button.layer.shadowPath = nil
        
        // Rotate animation
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = -CGFloat(Double.pi)
        rotateAnimation.duration = 0.45
        rotateAnimation.isCumulative = false
        self.button.layer.add(rotateAnimation, forKey: "rotate")
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
            self.button.isSelected = false
            self.buttonLeftConstraint.constant = self.offCenterPosition
            self.layoutIfNeeded()
            self.button.backgroundColor = self.originalColor
            self.label.text = Localizable.SwitchOffText
            self.label.textAlignment = .right
            self.label.textColor = UIColor(red: 0.59, green: 0.59, blue: 0.59, alpha: 1)
        }, completion: { (_:Bool) -> Void in
        })

    }
    func switchChangeToOn() {
        // Rotate animation
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = -CGFloat(Double.pi)
        rotateAnimation.toValue = 0.0
        rotateAnimation.duration = 0.45
        rotateAnimation.isCumulative = false
        self.button.layer.add(rotateAnimation, forKey: "rotate")
        
        // Translation animation
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
            self.button.isSelected = true
            self.buttonLeftConstraint.constant = self.onCenterPosition
            self.layoutIfNeeded()
            self.button.backgroundColor = self.selectedColor
            self.label.text = Localizable.SwitchOnText
            self.label.textAlignment = .left
            self.label.textColor = UIColor.white
        }, completion: { (_:Bool) -> Void in
            self.button.layer.shadowOffset = CGSize(width: 0, height: 0.2)
            self.button.layer.shadowOpacity = 0.3
            self.button.layer.shadowRadius = self.offCenterPosition
            self.button.layer.cornerRadius = self.button.frame.height / 2
            self.button.layer.shadowPath = UIBezierPath(roundedRect: self.button.layer.bounds, cornerRadius: self.button.frame.height / 2).cgPath
        })
    }
   
}
