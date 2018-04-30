import Foundation
import UIKit

class NavigationDropdownMenuConfig {
    var menuTitleColor: UIColor?
    var cellHeight: CGFloat = 0.0
    var cellBackgroundColor: UIColor?
    var cellSeparatorColor: UIColor?
    var cellTextLabelColor: UIColor?
    var selectedCellTextLabelColor: UIColor?
    var cellTextLabelFont: UIFont?
    var navigationBarTitleFont: UIFont?
    var cellTextLabelAlignment: NSTextAlignment?
    var cellSelectionColor: UIColor?
    var arrowTintColor: UIColor?
    var arrowImage: UIImage!
    var checkMarkImage: UIImage!
    var arrowPadding: CGFloat = 0.0
    var animationDuration: TimeInterval = TimeInterval(exactly: 0.0)!
    var maskBackgroundColor: UIColor?
    var maskBackgroundOpacity: CGFloat = 0.0
    var shouldChangeTitleText: Bool = false
    var tableViewHeight: CGFloat = 0.0
    var cellIdentifier: String!
    var cellReuseIdentifier: String!
    
    init() {
        self.defaultValue()
    }
    
    func defaultValue() {
        self.cellHeight = 50
        
        self.menuTitleColor = UIColor.white
        self.cellBackgroundColor = UIColor.white
//        self.arrowTintColor = UIColor.white
        self.cellSeparatorColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1.0)
        self.cellTextLabelColor = UIColor.black
        self.selectedCellTextLabelColor = UIColor.black
        self.cellSelectionColor = UIColor.lightGray
        self.maskBackgroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 0.2)
        
        self.cellTextLabelFont = UIFont(name: FontName.hiraginoSansW3.rawValue, size: 16)
        self.navigationBarTitleFont = UIFont(name: FontName.hiraginoSansW6.rawValue, size: 16)!
        
        self.cellTextLabelAlignment = NSTextAlignment.left
        
        self.checkMarkImage = #imageLiteral(resourceName: "icon_check_mark")
        self.arrowImage = #imageLiteral(resourceName: "ic_arrowdown_white")
        
        self.animationDuration = 0.5
        self.arrowPadding = 15
        self.maskBackgroundOpacity = 0.3
        self.tableViewHeight = 300.0
        
        self.shouldChangeTitleText = true
        
        self.cellIdentifier = "NavigationDropdownMenuTableViewCell"
        self.cellReuseIdentifier = "Cell"
    }
}
