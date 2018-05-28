//
//  PagingTableView.swift
//  Pursuit
//
//  Created by ігор on 5/23/18.
//  Copyright © 2018 Pursuit Health Technologies. All rights reserved.
//

import Foundation

protocol PagingTableViewDelegate: class {
    func paginate(_ tableView: PagingTableView)
    func tableView(_ tableView: PagingTableView, didSelectRowAt indexPath: IndexPath)
}
 class PagingTableView: UITableView, UITableViewDelegate {
    
    private var loadingView: UIView!
    private var indicator: UIActivityIndicatorView!
    internal var page: Int = 0
    internal var previousItemCount: Int = 0
    
    open var currentPage: Int {
        get {
            return page
        }
    }
    
    open weak var pagingDelegate: PagingTableViewDelegate? {
        didSet {
            self.delegate = self
            //pagingDelegate?.paginate(self, to: page)
        }
    }
    
    open var isLoading: Bool = false {
        didSet {
            isLoading ? showLoading() : hideLoading()
        }
    }
    
    open func reset() {
        page = 0
        previousItemCount = 0
        pagingDelegate?.paginate(self)
    }
    
    private func paginate(_ tableView: PagingTableView, forIndexAt indexPath: IndexPath) {
        let itemCount = tableView.dataSource?.tableView(tableView, numberOfRowsInSection: indexPath.section) ?? 0
        guard indexPath.row == itemCount - 1 else { return }
        guard previousItemCount != itemCount else { return }
        page += 1
        previousItemCount = itemCount
        pagingDelegate?.paginate(self)
    }
    
    private func showLoading() {
        if loadingView == nil {
            createLoadingView()
        }
        tableFooterView = loadingView
    }
    
    private func hideLoading() {
        reloadData()
        //pagingDelegate?.didPaginate?(self)
        tableFooterView = nil
    }
    
    private func createLoadingView() {
        loadingView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 50))
        indicator = UIActivityIndicatorView()
        indicator.color = UIColor.lightGray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        loadingView.addSubview(indicator)
        centerIndicator()
        tableFooterView = loadingView
    }
    
    private func centerIndicator() {
        let xCenterConstraint = NSLayoutConstraint(
            item: loadingView, attribute: .centerX, relatedBy: .equal,
            toItem: indicator, attribute: .centerX, multiplier: 1, constant: 0
        )
        loadingView.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(
            item: loadingView, attribute: .centerY, relatedBy: .equal,
            toItem: indicator, attribute: .centerY, multiplier: 1, constant: 0
        )
        loadingView.addConstraint(yCenterConstraint)
    }
}

extension PagingTableView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        print(deltaOffset)
        if deltaOffset <= -200 && deltaOffset > -400 {
            self.pagingDelegate?.paginate(self)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pagingDelegate?.tableView(self, didSelectRowAt: indexPath)
    }
}
