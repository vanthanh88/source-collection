import Foundation
import UIKit

class NavigationDropdownMenuTableView: UITableView {
    var configuration: NavigationDropdownMenuConfig?
    var selectRowAtIndexPathHandler: ((_ indexPath: Int) -> Void)?
    var items: [String] = []
    var selectedIndexPath: Int?
    let navigationDropdownMenuTableViewCellTag = 69
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, items: [String], title: String, configuration: NavigationDropdownMenuConfig) {
        super.init(frame: frame, style: UITableViewStyle.plain)
        
        self.items = items
        self.selectedIndexPath = items.index(of: title)
        self.configuration = configuration
        
        // Setup table view
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.clear
        self.separatorStyle = UITableViewCellSeparatorStyle.none
        self.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.tableFooterView = UIView(frame: CGRect.zero)
        self.register(UINib(nibName: configuration.cellIdentifier, bundle: nil), forCellReuseIdentifier: configuration.cellReuseIdentifier)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event), hitView.tag == navigationDropdownMenuTableViewCellTag {
            return hitView
        }
        
        return nil
    }
}

extension NavigationDropdownMenuTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: configuration?.cellReuseIdentifier ?? "", for: indexPath) as? NavigationDropdownMenuTableViewCell {
            cell.titleLabel?.text = self.items[(indexPath as NSIndexPath).row]
            cell.checkmarkIcon.image = self.configuration?.checkMarkImage
            cell.checkmarkIcon.isHidden = ((indexPath as NSIndexPath).row == selectedIndexPath) ? false : true
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
}

extension NavigationDropdownMenuTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return configuration?.cellHeight ?? 0.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
        
        if let selectRowAtIndexPath = self.selectRowAtIndexPathHandler {
            selectRowAtIndexPath(indexPath.row)
        }
        
        self.reloadData()
    }
}
