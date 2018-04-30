import UIKit


///The delegate of `SegmentedControl` must adopt `SegmentedControlDelegate` protocol. It allows retrieving information on which segment was tapped.
@objc protocol SegmentedControlDelegate {
    /// Tells the delegate that a specific segment is now selected.
    func segmentedControl(_ segmentedControl: SegmentedControl, selectedSegment: Int)
}

/**
 Highlighted Styles for the selected segments.
 - Background: The background of the selected segment is highlighted.
 - BottomEdge: The bottom edge of the selected segmenet is highlighted.
 */
enum SelectedItemHighlightStyle {
    case background
    case bottomEdge
}

/**
 Content Type for the segmented control.
 - Text: The segmented control displays only text.
 - Icon: The segmented control displays only icons/images.
 - Hybrid: The segmented control displays icons and text.
 */
enum ContentType {
    case text
    case icon
    case hybrid
}

@IBDesignable class SegmentedControl: UIView {
    
    @IBOutlet weak var delegate: SegmentedControlDelegate?
    fileprivate var highlightView: UIView!
    fileprivate let kMaxNumberOfSegmented = 5
    /**
     Defines the height of the highlighted edge if `selectedItemHighlightStyle` is either `BottomEdge`
     - Note: Changes only take place if `selectedItemHighlightStyle` is either `BottomEdge`
     */
    var edgeHighlightHeight: CGFloat = 3.0
    
    /// Changes the background of the selected segment.
    @IBInspectable var highlightColor: UIColor = #colorLiteral(red: 0.9942955375, green: 0.4128602147, blue: 0, alpha: 1) {
        didSet {
            self.update()
        }
    }
    
    /// Changes the font color or the icon tint color for the segments.
    @IBInspectable var tint: UIColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1) {
        didSet {
            self.update()
        }
    }
    
    /// Changes the font color or the icon tint for the selected segment.
    @IBInspectable var highlightTint: UIColor = #colorLiteral(red: 0.9942955375, green: 0.4128602147, blue: 0, alpha: 1) {
        didSet {
            self.update()
        }
    }
    
    var segmentTitle: [String] = [] {
        didSet {
            assert(segmentTitle.count <= kMaxNumberOfSegmented, "Max segmented item must be less or equal \(kMaxNumberOfSegmented)")
            segmentTitle = segmentTitle.count > kMaxNumberOfSegmented ? Array(segmentTitle[0 ..< kMaxNumberOfSegmented]) : segmentTitle
            contentType = .text
            self.update()
        }
    }
    
    var segmentIcon: [UIImage] = [] {
        didSet {
            assert(segmentTitle.count <= kMaxNumberOfSegmented, "Max segmented item must be less or equal \(kMaxNumberOfSegmented)")
            segmentIcon = segmentIcon.count > kMaxNumberOfSegmented ? Array(segmentIcon[0 ..< kMaxNumberOfSegmented]) : segmentIcon
            contentType = .icon
            self.update()
        }
    }
    
    var segmentContent: (text: [String], icon: [UIImage]) = ([], []) {
        didSet {
            assert(segmentContent.text.count == segmentContent.icon.count, "Text and Icon arrays out of sync.")
            assert(segmentContent.text.count <= kMaxNumberOfSegmented || segmentContent.icon.count <= kMaxNumberOfSegmented, "Max segmented item must be less or equal \(kMaxNumberOfSegmented)")
            
            if segmentContent.text.count > kMaxNumberOfSegmented {
                segmentContent.text = Array(segmentContent.text[0 ..< kMaxNumberOfSegmented])
            } else {
                segmentContent.text = segmentContent.text
            }
            
            if segmentContent.icon.count > kMaxNumberOfSegmented {
                segmentContent.icon = Array(segmentContent.icon[0 ..< kMaxNumberOfSegmented])
            } else {
                segmentContent.icon = segmentContent.icon
            }
            
            segmentContent.icon = segmentContent.icon.map(resizeImage)
            
            contentType = .hybrid
            self.update()
        }
    }
    
    /// The segment index of the selected item. When set it animates the current highlight to the button with index = selectedSegment.
    var selectedSegment: Int = 0 {
        didSet {
            func isUIButton(_ view: UIView) -> Bool {
                return view is UIButton ? true : false
            }
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.curveEaseOut, animations: {
                switch self.contentType {
                case .icon, .hybrid:
                    if let buttons = self.subviews.filter(isUIButton) as? [UIButton] {
                        buttons.forEach {
                            if $0.tag == self.selectedSegment {
                                $0.tintColor = self.highlightTint
                                self.highlightView.frame.origin.x = $0.frame.origin.x
                            } else {
                                $0.tintColor = self.tint
                            }
                        }
                    }
                case .text:
                    if let buttons = self.subviews.filter(isUIButton) as? [UIButton] {
                        buttons.forEach {
                            if $0.tag == self.selectedSegment {
                                $0.setTitleColor(self.highlightTint, for: UIControlState())
                                self.highlightView.frame.origin.x = $0.frame.origin.x
                            } else {
                                $0.setTitleColor(self.tint, for: UIControlState())
                            }
                        }
                    }
                }
                
            }, completion: nil)
        }
        
    }
    
    /**
     Sets the font for the text displayed in the segmented control if `contentType` is `Text`
     - Note: Changes only take place if `contentType` is `Text`
     */
    var font = UIFont(name: "HiraginoSans-W6", size: 14)!
    
    /// Sets the segmented control selected item highlight style to `Background`, `TopEdge` or `BottomEdge`.
    var selectedItemHighlightStyle: SelectedItemHighlightStyle = .background
    
    /// Sets the segmented control content type to `Text` or `Icon`
    var contentType: ContentType = .text
    
    /// Initializes and returns a newly allocated SegmentedControl object with the specified frame rectangle. It sets the segments of the control from the given `segmentTitle` array and the highlight style for the selected item.
    init (frame: CGRect, segmentTitle: [String], selectedItemHighlightStyle: SelectedItemHighlightStyle) {
        super.init (frame: frame)
        self.commonInit(segmentTitle, highlightStyle: selectedItemHighlightStyle)
    }
    
    /// Initializes and returns a newly allocated SegmentedControl object with the specified frame rectangle. It sets the segments of the control from the given `segmentIcon` array and the highlight style for the selected item.
    init (frame: CGRect, segmentIcon: [UIImage], selectedItemHighlightStyle: SelectedItemHighlightStyle) {
        super.init (frame: frame)
        self.commonInit(segmentIcon, highlightStyle: selectedItemHighlightStyle)
    }
    
    init (frame: CGRect, segmentContent: ([String], [UIImage]), selectedItemHighlightStyle: SelectedItemHighlightStyle) {
        super.init (frame: frame)
        self.commonInit(segmentContent, highlightStyle: selectedItemHighlightStyle)
    }
    
    /// Common initializer.
    fileprivate func commonInit(_ data: Any, highlightStyle: SelectedItemHighlightStyle) {
        if let segmentTitle = data as? [String] {
            self.segmentTitle = segmentTitle
        } else if let segmentIcon = data as? [UIImage] {
            self.segmentIcon = segmentIcon
        } else if let segmentContent = data as? ([String], [UIImage]) {
            self.segmentContent = segmentContent
        }
        selectedItemHighlightStyle = highlightStyle
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Prepares the render of the view for the Storyboard.
    override func prepareForInterfaceBuilder() {
        segmentTitle = ["Interface", "Builder"]
        selectedItemHighlightStyle = .bottomEdge
    }
    
    override func layoutSubviews() {
        self.update()
    }
    
    private func addSegments(startingPosition starting: CGFloat, sections: Int, width: CGFloat, height: CGFloat) {
        for i in 0 ..< sections {
            let frame = CGRect(x: starting + (CGFloat(i) * width), y: 0, width: width, height: height)
            let tab = UIButton(type: .system)
            tab.frame = frame
            tab.contentVerticalAlignment = .fill
            switch contentType {
            case .icon:
                tab.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
                tab.imageView?.contentMode = UIViewContentMode.scaleAspectFit
                tab.tintColor = i == selectedSegment ? highlightTint : tint
                tab.setImage(segmentIcon[i], for: UIControlState())
            case .text:
                tab.setTitle(segmentTitle[i], for: UIControlState())
                tab.setTitleColor(i == selectedSegment ? highlightTint : tint, for: UIControlState())
                tab.titleLabel?.font = font
            case .hybrid:
                let insetAmount: CGFloat = 8 / 2.0
                tab.imageEdgeInsets = UIEdgeInsets(top: 12, left: -insetAmount, bottom: 12, right: insetAmount)
                tab.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount * 2, bottom: 0, right: 0)
                tab.contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
                tab.contentHorizontalAlignment = .center
                tab.setTitle(segmentContent.text[i], for: UIControlState())
                tab.setImage(segmentContent.icon[i], for: UIControlState())
                tab.titleLabel?.font = font
                tab.imageView?.contentMode = .scaleAspectFit
                tab.tintColor = i == selectedSegment ? highlightTint : tint
            }
            
            tab.tag = i
            tab.addTarget(self, action: #selector(SegmentedControl.segmentPressed(_:)), for: .touchUpInside)
            self.addSubview(tab)
        }
    }
    
    private func addHighlightView(startingPosition starting: CGFloat, width: CGFloat) {
        switch selectedItemHighlightStyle {
        case .background:
            highlightView = UIView(frame: CGRect(x: starting, y: 0, width: width, height: frame.height))
        case .bottomEdge:
            highlightView = UIView(frame: CGRect(x: starting, y: frame.height - edgeHighlightHeight, width: width, height: edgeHighlightHeight))
        }
        
        highlightView.backgroundColor = highlightColor
        self.addSubview(highlightView)
    }
    
    private func startingPositionAndWidth(_ totalWidth: CGFloat, segmentCount: Int) -> (startingPosition: CGFloat, sectionWidth: CGFloat) {
        let width = totalWidth / CGFloat(segmentCount)
        return (0, width)
    }
    
    /// Forces the segmented control to reload.
    func update() {
        (subviews as [UIView]).forEach { $0.removeFromSuperview() }
        let totalWidth = frame.width
        if contentType == .text {
            guard segmentTitle.count > 0 else {
                log.debug("segmentTitle are not set")
                return
            }
            let tabBarSections = segmentTitle.count
            let sectionWidth = totalWidth / CGFloat(tabBarSections)
            addHighlightView(startingPosition: CGFloat(selectedSegment) * sectionWidth, width: sectionWidth)
            addSegments(startingPosition: 0, sections: tabBarSections, width: sectionWidth, height: frame.height)
        } else if contentType == .icon {
            let tabBarSections: Int = segmentIcon.count
            let positionWidth = startingPositionAndWidth(totalWidth, segmentCount: tabBarSections)
            addHighlightView(startingPosition: CGFloat(selectedSegment) * positionWidth.sectionWidth, width: positionWidth.sectionWidth)
            addSegments(startingPosition: positionWidth.startingPosition, sections: tabBarSections, width: positionWidth.sectionWidth, height: self.frame.height)
        } else if contentType == .hybrid {
            let tabBarSections: Int = segmentContent.text.count
            let positionWidth = startingPositionAndWidth(totalWidth, segmentCount: tabBarSections)
            addHighlightView(startingPosition: CGFloat(selectedSegment) * positionWidth.sectionWidth, width: positionWidth.sectionWidth)
            addSegments(startingPosition: 0, sections: tabBarSections, width: positionWidth.sectionWidth, height: self.frame.height)
        }
    }
    
    /// Called whenever a segment is pressed. Sends the information to the delegate.
    @objc fileprivate func segmentPressed(_ sender: UIButton) {
        selectedSegment = sender.tag
        delegate?.segmentedControl(self, selectedSegment: selectedSegment)
    }
    
    /// Press indexed tab
    func pressTabWithIndex(_ index: Int) {
        for subview in self.subviews where subview.tag == index {
            if let button = subview as? UIButton {
                segmentPressed(button)
                return
            }
        }
    }
    
    /// Scales an image if it's over the maximum size of `frame height / 2`. It takes into account alpha. And it uses the screen's scale to resize.
    fileprivate func resizeImage(_ image: UIImage) -> UIImage {
        let maxSize = CGSize(width: frame.height / 2, height: frame.height / 2)
        // If the original image is within the maximum size limit, just return immediately without manual scaling
        if image.size.width <= maxSize.width && image.size.height <= maxSize.height {
            return image
        }
        let ratio = image.size.width / image.size.height
        let size = CGSize(width: maxSize.width*ratio, height: maxSize.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
