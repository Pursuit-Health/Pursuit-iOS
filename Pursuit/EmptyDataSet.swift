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
}

extension PSEmptyDatasource {
    
    //MARK: Methods
    
    func imageForEmpty(in view: UIView) -> UIImage? {
        return UIImage(named: self.emptyImageName)
    }
    
    func titleForEmpty(in view: UIView) -> NSAttributedString? {
        let attributes: [String : Any] = [NSFontAttributeName : UIFont(name: "Avenir-Book", size: self.fontSize)!, NSForegroundColorAttributeName : self.titleColor]
        return NSAttributedString(string: self.emptyTitle, attributes: attributes)
    }
}
