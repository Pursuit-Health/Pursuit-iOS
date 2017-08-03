//
//  PageViewController.swift
//  Pursuit
//
//  Created by ігор on 8/2/17.
//  Copyright © 2017 Pursuit Health Technologies. All rights reserved.
//

import UIKit

protocol PageViewControllerDelegate: class {
    func changeControllersInPageVC(index: Int)
}

class PageViewController: UIPageViewController {
    
    //MARK:PageViewControllerDelegate variable
    var delegateForNotifyMain: PageViewControllerDelegate?
    
    //MARK: Variables
    private func newColoredViewController(id: String) -> UIViewController {
        return UIStoryboard(name: "Login", bundle: nil) .
            instantiateViewController(withIdentifier: "\(id)VCID")
    }
    
    var pageViewController: PageViewController?
    var mainAuth: MainAuthVC? {
        didSet {
            mainAuth?.delegate = self
        }
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signControllerForDelegate()
        
        setUpPageViewController()
        
        setDelegateForPageViewController()
    }
    
    private func setDelegateForPageViewController(){
        dataSource = self
        delegate = self
    }
    
    private func signControllerForDelegate(){
        let controller = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! MainAuthVC
        controller.pageVC = self
    }
    
    private func setUpPageViewController(){
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newColoredViewController(id: "SignIn"),
                self.newColoredViewController(id: "SignUp")]
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    
}

//MARK: UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
}

//MARK: UIPageViewControllerDelegate
extension PageViewController: UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        
        guard let page = orderedViewControllers.index(of:pageContentViewController) else { return }
        
        delegateForNotifyMain?.changeControllersInPageVC(index: page)
        print(page)
    }
}

//MARK: MainAuthVCDelegate
extension PageViewController: MainAuthVCDelegate {
    
    func userDidPressedSignUpButton() {
        setViewControllers([orderedViewControllers[1]],
                           direction: .forward,
                           animated: true,
                           completion: nil)
    }
    
    func userDidPressedSignInButton() {
        
        setViewControllers([orderedViewControllers.first!],
                           direction: .reverse,
                           animated: true,
                           completion: nil)
      
    }
}
