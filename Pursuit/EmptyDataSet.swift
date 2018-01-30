//
//  EmptyDataSet.swift
//  Pursuit
//
//  Created by ігор on 1/29/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import EmptyKit

protocol PSEmptyDatasource: EmptyDataSource {
    var emptyTitle: String { get }
    var emptyImageName: String { get }
    var fontSize: CGFloat { get }
    var titleColor: UIColor { get }
    var verticalOffSet: CGFloat { get }
}

protocol PSEmptyDelegate: EmptyDelegate {
    
}

extension PSEmptyDatasource {
    
    //MARK: Methods
    
    var verticalOffSet: CGFloat {
        return 0
    }
    
    func imageForEmpty(in view: UIView) -> UIImage? {
        return UIImage(named: self.emptyImageName)
    }
    
    func titleForEmpty(in view: UIView) -> NSAttributedString? {
        let attributes: [String : Any] = [NSFontAttributeName : UIFont(name: "Avenir-Book", size: self.fontSize)!, NSForegroundColorAttributeName : self.titleColor]
        return NSAttributedString(string: self.emptyTitle, attributes: attributes)
    }
    
    func verticalOffsetForEmpty(in view: UIView) -> CGFloat{
        return self.verticalOffSet
    }
}

extension PSEmptyDelegate {

}
