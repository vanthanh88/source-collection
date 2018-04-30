import UIKit

private let defaultNumberOfCell = 2
private let defaultCellHeight = CGFloat(-1)
private let defaultMarginBetweenCells = CGFloat(2)
private let defaultOutlineMargin = CGFloat(2)
private let defaultHeightRatio = CGFloat(117/175)

// MARK: - CTCollectionViewDataSource
public protocol CTCollectionViewDataSource: UICollectionViewDataSource {
    
    func numberOfCellsInLine(_ collectionView: CTCollectionView) -> Int
    /// if less than equal 0 then set cell height to cell width
    func marginBetweenCells(_ collectionView: CTCollectionView) -> CGFloat
    func outlineMargin(_ collectionView: CTCollectionView) -> CGFloat
    func collectionItemHeightRatio(_ collectionView: CTCollectionView) -> CGFloat
    
}

// MARK: - CTCollectionViewDataSource - default implementation
public extension CTCollectionViewDataSource {
    func numberOfCellsInLine(_ collectionView: CTCollectionView) -> Int {
        return defaultNumberOfCell
    }
    
    func marginBetweenCells(_ collectionView: CTCollectionView) -> CGFloat {
        return defaultMarginBetweenCells
    }
    
    func outlineMargin(_ collectionView: CTCollectionView) -> CGFloat {
        return defaultOutlineMargin
    }
    
    func collectionItemHeightRatio(_ collectionView: CTCollectionView) -> CGFloat {
        return defaultHeightRatio
    }
}

// MARK: - CTCollectionView
open class CTCollectionView: UICollectionView {
    
    fileprivate var _numberOfCells = defaultNumberOfCell
    open var numberOfCellsInLine: Int {
        get {
            return self._numberOfCells
        }
        set {
            let value = (self.myDataSource == nil) ? defaultNumberOfCell : self.myDataSource!.numberOfCellsInLine(self)
            self._numberOfCells = value
            self.collectionViewLayout = self.collectionViewFlowLayout(self._numberOfCells)
            self.reloadData()
        }
    }
    
    /// CTCollectionViewDataSource
    override weak open var dataSource: UICollectionViewDataSource? {
        didSet {
            assert(delegate == nil || delegate is CTCollectionViewDataSource, "The dataSource must be of type 'CTCollectionViewDataSource'")
            self.myDataSource = dataSource as? CTCollectionViewDataSource
            
            // update display
            self._numberOfCells = self.myDataSource!.numberOfCellsInLine(self)
            self.collectionViewLayout = self.collectionViewFlowLayout(self._numberOfCells)
        }
    }
    fileprivate weak var myDataSource: CTCollectionViewDataSource?
    
    
    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self._init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self._init()
    }
    
    fileprivate func _init() {
        self.collectionViewLayout = self.collectionViewFlowLayout(self._numberOfCells)
    }
    
    
    fileprivate func collectionViewFlowLayout(_ numberOfCells: Int) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        var marginCells: CGFloat = defaultMarginBetweenCells
        var marginOutline: CGFloat = defaultOutlineMargin
        if let _dataSource = self.myDataSource {
            marginCells = _dataSource.marginBetweenCells(self)
            marginOutline = _dataSource.outlineMargin(self)
        }
        let sumOfCellWidths = UIScreen.main.bounds.size.width - (2.0 * marginOutline + CGFloat(numberOfCells - 1) * marginCells)
        let cellWidth = sumOfCellWidths / CGFloat(numberOfCells)
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        if let dataSource = self.myDataSource {
            let h = cellWidth * dataSource.collectionItemHeightRatio(self)
            layout.itemSize = CGSize(width: cellWidth, height: h > 0 ? h : cellWidth)
        }
        layout.sectionInset = UIEdgeInsets(top: marginOutline, left: marginOutline, bottom: marginOutline, right: marginOutline)
        layout.minimumInteritemSpacing = marginCells
        layout.minimumLineSpacing = marginCells
        return layout
    }
    
    open func nextNumberOfCellsInLine() -> Int {
        return self._numberOfCells
    }
}
