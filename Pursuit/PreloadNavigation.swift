import UIKit

class PreloadNavigation: UINavigationController {
    
    //MARK: Initializers
    
    //TODO: change to support any initial controller/cooperate with router
//    init(root: UIViewController) {
//        super.init(nibName: nil, bundle: nil)
//        
//        self.root                               = root
//        self.setViewControllers([root], animated: false)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        guard let _ = self.root else {
//            self.root = self.viewControllers.first
//            return
//        }
//    }
//    
//    //MARK: Properties
//    
//    var root: UIViewController?
//    
//    //MARK: Public.Methods
//    
//    func restart(with root: UIViewController) {
//        if self.viewControllers.first !== root {
//            self.root = root
//            self.viewControllers.insert(root, at: 0)
//        }
//    }
//    
//    //MARK: Override
//    
//    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        CATransaction.begin()
//        CATransaction.setCompletionBlock({
//            self.bbb_remove(fromStack: self.root)
//            self.root = nil
//        })
//        super.pushViewController(viewController, animated: animated)
//        CATransaction.commit()
//    }
}
