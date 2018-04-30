import UIKit

class NavigationDropdownMenu: UIView {
    
    // MARK: Parameters - User
    
    var didSelectItemAtIndexHandler: ((_ indexPath: Int) -> Void)?
    var isShown = false
    var configuration = NavigationDropdownMenuConfig()
    var topSeparator: UIView?
    var menuButton: UIButton?
    var menuTitle: UILabel?
    var menuArrow: UIImageView?
    var backgroundView: UIView?
    var tableView: NavigationDropdownMenuTableView!
    var items: [String] = []
    var menuWrapper: UIView?
    
    weak var navigationController: UINavigationController?
    
    // MARK: Methods - Init
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(navigationController: UINavigationController? = nil, containerView: UIView = UIApplication.shared.keyWindow!, title: String, items: [String]) {
        // Key window
        guard let window = UIApplication.shared.keyWindow,
            let navigationController = navigationController else {
            super.init(frame: CGRect.zero)
            return
        }
        
        let menuWrapperBounds = window.bounds
        
        // Navigation controller
        self.navigationController = navigationController
        
        // set data
        self.items = items
        
        // Get titleSize
        let titleSize = (title as NSString).size(attributes: [NSFontAttributeName: self.configuration.navigationBarTitleFont ?? UIFont.systemFont(ofSize: 16.0)])
        
        // Set frame
        let frame = CGRect(x: 0, y: 0, width: titleSize.width + (self.configuration.arrowPadding + self.configuration.arrowImage.size.width) * 2, height: navigationController.navigationBar.frame.height)
        
        super.init(frame: frame)
        
        // Init button as navigation title
        self.setupTitleNavigation(title: title, frame: frame)
        
        // Set up DropdownMenu
        self.menuWrapper = UIView(frame: CGRect(x: menuWrapperBounds.origin.x, y: 0, width: menuWrapperBounds.width, height: menuWrapperBounds.height))
        self.menuWrapper?.clipsToBounds = true
        self.menuWrapper?.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        
        // Init background view (under table view)
        self.backgroundView = UIView(frame: menuWrapperBounds)
        self.backgroundView?.backgroundColor = self.configuration.maskBackgroundColor
        self.backgroundView?.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        
        let backgroundTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideMenu))
        self.backgroundView?.addGestureRecognizer(backgroundTapRecognizer)
        
        // Init table view
        let navBarHeight = self.navigationController?.navigationBar.bounds.size.height ?? 0
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let tableViewFrame = CGRect(x: menuWrapperBounds.origin.x, y: menuWrapperBounds.origin.y + 0.5, width: menuWrapperBounds.width, height: menuWrapperBounds.height + configuration.tableViewHeight - navBarHeight - statusBarHeight)
        self.tableView = NavigationDropdownMenuTableView(frame: tableViewFrame, items: items, title: title, configuration: self.configuration)
        
        self.tableView.selectRowAtIndexPathHandler = {[weak self](indexPath: Int) in
            guard let weakSelf = self else {
                return
            }
            
            if let didSelectItemAtIndex = weakSelf.didSelectItemAtIndexHandler {
                didSelectItemAtIndex(indexPath)
            }

            if weakSelf.configuration.shouldChangeTitleText {
                weakSelf.setNavigationTitle("\(weakSelf.tableView.items[indexPath])")
            }

            self?.hideMenu(animate: false)
            self?.layoutSubviews()
        }
        
        // Add background view & table view to container view
        self.menuWrapper?.addSubview(self.backgroundView!)
        self.menuWrapper?.addSubview(self.tableView)
        
        // Add Line on top
        self.topSeparator = UIView(frame: CGRect(x: 0, y: 0, width: menuWrapperBounds.size.width, height: 0.5))
        self.topSeparator?.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.menuWrapper?.addSubview(self.topSeparator!)
        
        // Add Menu View to container view
        containerView.addSubview(self.menuWrapper!)
        
        // By default, hide menu view
        self.menuWrapper?.isHidden = true
    }
    
    // MARK: Methods - Override
    
    override open func layoutSubviews() {
        self.menuTitle?.sizeToFit()
        self.menuTitle?.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.menuTitle?.textColor = self.configuration.menuTitleColor
        self.menuArrow?.sizeToFit()
        self.menuArrow?.center = CGPoint(x: (self.menuTitle?.frame.maxX)! + self.configuration.arrowPadding, y: self.frame.size.height/2)
        self.menuWrapper?.frame.origin.y = self.navigationController!.navigationBar.frame.maxY
        self.tableView.reloadData()
    }
    
    func setupTitleNavigation(title: String, frame: CGRect) {
        self.menuButton = UIButton(frame: frame)
        self.menuButton?.addTarget(self, action: #selector(menuButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        self.addSubview(self.menuButton!)
        
        self.menuTitle = UILabel(frame: frame)
        self.menuTitle?.text = title
        self.menuTitle?.textColor = self.configuration.menuTitleColor
        self.menuTitle?.font = self.configuration.navigationBarTitleFont
        self.menuTitle?.textAlignment = self.configuration.cellTextLabelAlignment!
        self.menuButton?.addSubview(self.menuTitle!)
        
        self.menuArrow = UIImageView(image: self.configuration.arrowImage)
//        self.menuArrow?.tintColor = self.configuration.arrowTintColor
        self.menuButton?.addSubview(self.menuArrow!)
    }

    func menuButtonTapped(_ sender: UIButton) {
        self.isShown == true ? hideMenu(animate: false) : showMenu()
    }
    
    func hideMenu(animate: Bool) {
        self.isShown = false
        
        // Change background alpha
        self.backgroundView?.alpha = self.configuration.maskBackgroundOpacity
        
        // Animation
        let animationsFirst = {
            self.tableView.frame.origin.y = CGFloat(-200)
        }
        var duration: Double?
        if animate {
            duration = 0
        }
        UIView.animate(withDuration: self.configuration.animationDuration * 1.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: animationsFirst,
                       completion: nil)
        
        let animationsSecond = {
            self.tableView.frame.origin.y = -CGFloat(self.items.count) * self.configuration.cellHeight - self.configuration.tableViewHeight
            self.backgroundView?.alpha = 0
        }
        
        let completion: ((Bool) -> Void) = { _ in
            if self.isShown == false &&
                self.tableView.frame.origin.y == -CGFloat(self.items.count) * self.configuration.cellHeight - self.configuration.tableViewHeight {
                self.menuWrapper?.isHidden = true
            }
        }
        
        UIView.animate(withDuration: duration ?? self.configuration.animationDuration,
                       delay: 0,
                       options: [],
                       animations: animationsSecond,
                       completion: completion)
    }
    
    func showMenu() {
        self.menuWrapper?.frame.origin.y = self.navigationController!.navigationBar.frame.maxY
        
        self.isShown = true
        
        // Table view header
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: configuration.tableViewHeight))
        headerView.backgroundColor = self.configuration.cellBackgroundColor
        self.tableView.tableHeaderView = headerView
        
        self.topSeparator?.backgroundColor = self.configuration.cellSeparatorColor
        
        // Visible menu view
        self.menuWrapper?.isHidden = false
        
        // Change background alpha
        self.backgroundView?.alpha = 0
        
        // Animation
        self.tableView.frame.origin.y = -CGFloat(self.items.count) * self.configuration.cellHeight - self.configuration.tableViewHeight
        
        self.menuWrapper?.superview?.bringSubview(toFront: self.menuWrapper!)
        
        let animations = {
            self.tableView.frame.origin.y = CGFloat(-self.configuration.tableViewHeight)
            self.backgroundView?.alpha = self.configuration.maskBackgroundOpacity
        }
        
        UIView.animate(withDuration: self.configuration.animationDuration * 1.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: animations,
                       completion: nil)
    }
    
    func setNavigationTitle(_ title: String) {
        self.menuTitle?.text = title
    }
    
    func rotateArrow() {
        UIView.animate(withDuration: self.configuration.animationDuration, animations: {[weak self] in
            if let selfie = self {
                selfie.menuArrow?.transform = (selfie.menuArrow?.transform.rotated(by: 180 * CGFloat(Double.pi/180)))!
            }
        })
    }
}
